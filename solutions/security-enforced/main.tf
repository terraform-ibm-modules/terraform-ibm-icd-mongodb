module "mongodb" {
  source                        = "../fully-configurable"
  ibmcloud_api_key              = var.ibmcloud_api_key
  existing_resource_group_name  = var.existing_resource_group_name
  prefix                        = var.prefix
  mongodb_name                  = var.mongodb_name
  region                        = var.region
  mongodb_version               = var.mongodb_version
  plan                          = var.plan
  service_endpoints             = "private"
  existing_mongodb_instance_crn = var.existing_mongodb_instance_crn
  # ICD hosting model properties
  members                  = var.members
  memory_mb                = var.memory_mb
  cpu_count                = var.cpu_count
  disk_mb                  = var.disk_mb
  member_host_flavor       = var.member_host_flavor
  service_credential_names = var.service_credential_names
  admin_pass               = var.admin_pass
  users                    = var.users
  mongodb_tags             = var.mongodb_tags
  mongodb_access_tags      = var.mongodb_access_tags
  # Encryption
  kms_encryption_enabled            = true
  use_ibm_owned_encryption_key      = false
  existing_kms_instance_crn         = var.existing_kms_instance_crn
  existing_kms_key_crn              = var.existing_kms_key_crn
  existing_backup_kms_key_crn       = var.existing_backup_kms_key_crn
  kms_endpoint_type                 = "private"
  skip_mongodb_kms_auth_policy      = var.skip_mongodb_kms_auth_policy
  ibmcloud_kms_api_key              = var.ibmcloud_kms_api_key
  key_ring_name                     = var.key_ring_name
  key_name                          = var.key_name
  use_default_backup_encryption_key = false
  backup_crn                        = var.backup_crn
  provider_visibility               = "private"
  # Auto Scaling
  auto_scaling = var.auto_scaling
  # Secrets Manager Service Credentials
  existing_secrets_manager_instance_crn                = var.existing_secrets_manager_instance_crn
  existing_secrets_manager_endpoint_type               = "private"
  service_credential_secrets                           = var.service_credential_secrets
  skip_mongodb_secrets_manager_auth_policy             = var.skip_mongodb_secrets_manager_auth_policy
  admin_pass_secrets_manager_secret_group              = var.admin_pass_secrets_manager_secret_group
  use_existing_admin_pass_secrets_manager_secret_group = var.use_existing_admin_pass_secrets_manager_secret_group
  admin_pass_secrets_manager_secret_name               = var.admin_pass_secrets_manager_secret_name
}
