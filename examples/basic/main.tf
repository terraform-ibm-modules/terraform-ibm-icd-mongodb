##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.4"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

##############################################################################
# MongoDB Instance
##############################################################################

module "database" {
  source = "../.."
  # remove the above line and uncomment the below 2 lines to consume the module from the registry
  # source            = "terraform-ibm-modules/icd-mongodb/ibm"
  # version           = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  resource_group_id   = module.resource_group.resource_group_id
  name                = "${var.prefix}-data-store"
  region              = var.region
  mongodb_version     = var.mongodb_version
  access_tags         = var.access_tags
  tags                = var.resource_tags
  service_endpoints   = var.service_endpoints
  member_host_flavor  = var.member_host_flavor
  deletion_protection = false
  service_credential_names = {
    "mongodb_admin" : "Administrator",
    "mongodb_operator" : "Operator",
    "mongodb_viewer" : "Viewer",
    "mongodb_editor" : "Editor",
  }
}
