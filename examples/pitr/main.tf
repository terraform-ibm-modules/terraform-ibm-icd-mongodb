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

# New ICD mongodb database instance pointing to a PITR time
module "mongo_db_pitr" {
  source = "../.."
  # remove the above line and uncomment the below 2 lines to consume the module from the registry
  # source            = "terraform-ibm-modules/icd-mongodb/ibm"
  # version           = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  resource_group_id   = module.resource_group.resource_group_id
  name                = "${var.prefix}-mongo-pitr"
  region              = var.region
  tags                = var.resource_tags
  access_tags         = var.access_tags
  disk_mb             = 20480
  deletion_protection = false
  mongodb_version     = var.mongodb_version
  pitr_id             = var.pitr_id
  pitr_time           = var.pitr_time == "" ? " " : var.pitr_time
  plan                = var.plan
  member_host_flavor  = var.member_host_flavor
}
