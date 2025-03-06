#############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

# New ICD mongodb database instance pointing to a PITR time
module "mongodb_db_pitr" {
  source             = "../.."
  resource_group_id  = module.resource_group.resource_group_id
  name               = "${var.prefix}-mongodb-pitr"
  region             = var.region
  plan               = "enterprise"
  tags               = var.resource_tags
  access_tags        = var.access_tags
  member_host_flavor = "multitenant"
  member_memory_mb   = 14336
  member_disk_mb     = 20480
  member_cpu_count   = 6
  mongodb_version    = var.mongodb_version
  pitr_id            = var.pitr_id
  pitr_time          = var.pitr_time == "" ? " " : var.pitr_time
}
