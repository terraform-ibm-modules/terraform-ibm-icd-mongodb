##############################################################################
# Locals
##############################################################################

locals {
  secrets_manager_guid   = var.existing_secrets_manager_instance_guid == null ? module.secrets_manager[0].secrets_manager_guid : var.existing_secrets_manager_instance_guid
  secrets_manager_region = var.existing_secrets_manager_instance_region == null ? var.region : var.existing_secrets_manager_instance_region
  service_credential_names = {
    "es_admin" : "Administrator",
    "es_operator" : "Operator",
    "es_viewer" : "Viewer",
    "es_editor" : "Editor",
  }
}

##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.0"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# VPC
##############################################################################
resource "ibm_is_vpc" "example_vpc" {
  name           = "${var.prefix}-vpc"
  resource_group = module.resource_group.resource_group_id
  tags           = var.resource_tags
}

resource "ibm_is_subnet" "testacc_subnet" {
  name                     = "${var.prefix}-subnet"
  vpc                      = ibm_is_vpc.example_vpc.id
  zone                     = "${var.region}-1"
  total_ipv4_address_count = 256
  resource_group           = module.resource_group.resource_group_id
}

##############################################################################
# Key Protect All Inclusive
##############################################################################

locals {
  data_key_name    = "${var.prefix}-mongo"
  backups_key_name = "${var.prefix}-mongo-backups"
}

module "key_protect_all_inclusive" {
  source            = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version           = "5.4.0"
  resource_group_id = module.resource_group.resource_group_id
  # Only us-south, us-east and eu-de backup encryption keys are supported. See https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok for details.
  # Note: Database instance and Key Protect must be created on the same region.
  region                    = var.region
  key_protect_instance_name = "${var.prefix}-kp"
  resource_tags             = var.resource_tags
  keys = [
    {
      key_ring_name = "icd"
      keys = [
        {
          key_name     = local.data_key_name
          force_delete = true
        },
        {
          key_name     = local.backups_key_name
          force_delete = true
        }
      ]
    }
  ]
}

##############################################################################
# Get Cloud Account ID
##############################################################################

data "ibm_iam_account_settings" "iam_account_settings" {
}

##############################################################################
# Create CBR Zone
##############################################################################
module "cbr_zone" {
  source           = "terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module"
  version          = "1.33.5"
  name             = "${var.prefix}-VPC-network-zone"
  zone_description = "CBR Network zone containing VPC"
  account_id       = data.ibm_iam_account_settings.iam_account_settings.account_id
  addresses = [{
    type  = "vpc", # to bind a specific vpc to the zone
    value = ibm_is_vpc.example_vpc.crn,
  }]
}

##############################################################################
#  MongoDB Instance
##############################################################################

module "icd_mongodb" {
  source = "../.."
  # remove the above line and uncomment the below 2 lines to consume the module from the registry
  # source            = "terraform-ibm-modules/icd-mongodb/ibm"
  # version           = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  resource_group_id   = module.resource_group.resource_group_id
  name                = "${var.prefix}-mongodb"
  mongodb_version     = var.mongodb_version
  admin_pass          = var.admin_pass
  users               = var.users
  region              = var.region
  plan                = var.plan
  access_tags         = var.access_tags
  tags                = var.resource_tags
  deletion_protection = false
  auto_scaling        = var.auto_scaling
  # Example of how to use different KMS keys for data and backups
  use_ibm_owned_encryption_key = false
  use_same_kms_key_for_backups = false
  kms_key_crn                  = module.key_protect_all_inclusive.keys["icd.${local.data_key_name}"].crn
  backup_encryption_key_crn    = module.key_protect_all_inclusive.keys["icd.${local.backups_key_name}"].crn
  service_credential_names     = local.service_credential_names
  member_host_flavor           = "multitenant"
  memory_mb                    = 4096
}

##############################################################################
## Secrets Manager layer
##############################################################################

# Create Secrets Manager Instance (if not using existing one)
module "secrets_manager" {
  count                = var.existing_secrets_manager_instance_guid == null ? 1 : 0
  source               = "terraform-ibm-modules/secrets-manager/ibm"
  version              = "2.10.3"
  resource_group_id    = module.resource_group.resource_group_id
  region               = var.region
  secrets_manager_name = "${var.prefix}-secrets-manager"
  sm_service_plan      = "trial"
  allowed_network      = "public-and-private"
  sm_tags              = var.resource_tags
}

# Add a Secrets Group to the secret manager instance
module "secrets_manager_secrets_group" {
  source               = "terraform-ibm-modules/secrets-manager-secret-group/ibm"
  version              = "1.3.15"
  region               = local.secrets_manager_region
  secrets_manager_guid = local.secrets_manager_guid
  #tfsec:ignore:general-secrets-no-plaintext-exposure
  secret_group_name        = "${var.prefix}-es-secrets"
  secret_group_description = "service secret-group" #tfsec:ignore:general-secrets-no-plaintext-exposure
}

# Add service credentials to secret manager as a username/password secret type in the created secret group
module "secrets_manager_service_credentials_user_pass" {
  source                  = "terraform-ibm-modules/secrets-manager-secret/ibm"
  version                 = "1.9.1"
  for_each                = local.service_credential_names
  region                  = local.secrets_manager_region
  secrets_manager_guid    = local.secrets_manager_guid
  secret_group_id         = module.secrets_manager_secrets_group.secret_group_id
  secret_name             = "${var.prefix}-${each.key}-credentials"
  secret_description      = "MongoDB Service Credentials for ${each.key}"
  secret_username         = module.icd_mongodb.service_credentials_object.credentials[each.key].username
  secret_payload_password = module.icd_mongodb.service_credentials_object.credentials[each.key].password
  secret_type             = "username_password" #checkov:skip=CKV_SECRET_6
}

# Add MongoDB certificate to secret manager as a certificate secret type in the created secret group.
module "secrets_manager_service_credentials_cert" {
  source                    = "terraform-ibm-modules/secrets-manager-secret/ibm"
  version                   = "1.9.1"
  region                    = local.secrets_manager_region
  secrets_manager_guid      = local.secrets_manager_guid
  secret_group_id           = module.secrets_manager_secrets_group.secret_group_id
  secret_name               = "${var.prefix}-es-cert"
  secret_description        = "MongoDB Service Credential Certificate"
  imported_cert_certificate = base64decode(module.icd_mongodb.service_credentials_object.certificate)
  secret_type               = "imported_cert" #checkov:skip=CKV_SECRET_6
}
