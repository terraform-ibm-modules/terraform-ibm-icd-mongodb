##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-resource-group.git?ref=v1.0.5"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# Key Protect All Inclusive
##############################################################################

module "key_protect_all_inclusive" {
  providers = {
    restapi = restapi.kp
  }
  source            = "git::https://github.com/terraform-ibm-modules/terraform-ibm-key-protect-all-inclusive.git?ref=v3.0.2"
  resource_group_id = module.resource_group.resource_group_id
  # Note: Database instance and Key Protect must be created in the same region when using BYOK
  # See https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok
  region                    = var.region
  key_protect_instance_name = "${var.prefix}-kp"
  resource_tags             = var.resource_tags
  key_map                   = { "icd" = ["${var.prefix}-mongodb"] }
}

# Create IAM Access Policy to allow Key protect to access Postgres instance
resource "ibm_iam_authorization_policy" "policy" {
  source_service_name         = "databases-for-mongodb"
  source_resource_group_id    = module.resource_group.resource_group_id
  target_service_name         = "kms"
  target_resource_instance_id = module.key_protect_all_inclusive.key_protect_guid
  roles                       = ["Reader"]
}

########################################
## Create Secrets Manager layer
########################################

resource "ibm_resource_instance" "secrets_manager" {
  name              = "${var.prefix}-sm"
  service           = "secrets-manager"
  service_endpoints = "public-and-private"
  plan              = var.sm_service_plan
  location          = var.region
  resource_group_id = module.resource_group.resource_group_id

  timeouts {
    create = "30m"
  }

}

##############################################################################
# Service Credentials
##############################################################################

resource "ibm_resource_key" "service_credentials" {
  count                = length(var.service_credentials)
  name                 = var.service_credentials[count.index]
  resource_instance_id = module.mongodb.id
  tags                 = var.resource_tags
}

##############################################################################
# ICD mongodb database
##############################################################################

module "mongodb" {
  source              = "../.."
  resource_group_id   = module.resource_group.resource_group_id
  mongodb_version     = var.mongodb_version
  instance_name       = "${var.prefix}-mongodb"
  region              = var.region
  key_protect_key_crn = module.key_protect_all_inclusive.keys["icd.${var.prefix}-mongodb"].crn
  tags                = var.resource_tags
}
