##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.5"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# ICD mongodb database
##############################################################################

module "mongo_db" {
  count             = var.mongo_db_backup_crn != null ? 0 : 1
  source            = "../.."
  resource_group_id = module.resource_group.resource_group_id
  instance_name     = "${var.prefix}-mongodb"
  region            = var.region
  mongodb_version   = var.mongodb_version
  access_tags       = var.access_tags
  tags              = var.resource_tags
}

data "ibm_database_backups" "backup_database" {
  count         = var.mongo_db_backup_crn != null ? 0 : 1
  deployment_id = module.mongo_db[0].id
}

# New mongo db instance pointing to the backup instance
module "restored_mongo_db" {
  source            = "../.."
  resource_group_id = module.resource_group.resource_group_id
  instance_name     = "${var.prefix}-mongodb-restored"
  region            = var.region
  mongodb_version   = var.mongodb_version
  access_tags       = var.access_tags
  tags              = var.resource_tags
  backup_crn        = var.mongo_db_backup_crn == null ? data.ibm_database_backups.backup_database[0].backups[0].backup_id : var.mongo_db_backup_crn
}
