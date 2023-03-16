locals {
  # tflint-ignore: terraform_unused_declarations
  validate_restrictions_set = (length(var.allowlist) == 0 && length(var.cbr_rules) == 0) ? tobool("Allow list and/or CBR Rules must be set") : true
}

module "mongodb" {
  source                    = "../.."
  resource_group_id         = var.resource_group_id
  instance_name             = var.instance_name
  region                    = var.region
  plan                      = var.plan
  allowlist                 = var.allowlist
  configuration             = var.configuration
  mongodb_version           = var.mongodb_version
  endpoints                 = "private"
  tags                      = var.tags
  key_protect_key_crn       = var.key_protect_key_crn
  backup_encryption_key_crn = var.backup_encryption_key_crn
  memory_mb                 = var.memory_mb
  disk_mb                   = var.disk_mb
  cpu_count                 = var.cpu_count
  auto_scaling              = var.auto_scaling
  cbr_rules                 = var.cbr_rules
}
