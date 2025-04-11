module "mongodb" {
  source                            = "../../"
  resource_group_id                 = var.resource_group_id
  name                              = var.name
  region                            = var.region
  plan                              = var.plan
  skip_iam_authorization_policy     = var.skip_iam_authorization_policy
  service_endpoints                 = "private"
  mongodb_version                   = var.mongodb_version
  use_ibm_owned_encryption_key      = var.use_ibm_owned_encryption_key
  use_same_kms_key_for_backups      = var.use_same_kms_key_for_backups
  use_default_backup_encryption_key = var.use_default_backup_encryption_key
  kms_key_crn                       = var.kms_key_crn
  backup_crn                        = var.backup_crn
  backup_encryption_key_crn         = var.backup_encryption_key_crn
  cbr_rules                         = var.cbr_rules
  access_tags                       = var.access_tags
  tags                              = var.tags
  members                           = var.members
  memory_mb                         = var.memory_mb
  admin_pass                        = var.admin_pass
  users                             = var.users
  disk_mb                           = var.disk_mb
  cpu_count                         = var.cpu_count
  member_host_flavor                = var.member_host_flavor
  auto_scaling                      = var.auto_scaling
  service_credential_names          = var.service_credential_names
}
