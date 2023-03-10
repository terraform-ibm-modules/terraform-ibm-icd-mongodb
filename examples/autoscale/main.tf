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
# ICD mongodb database with auto scale
##############################################################################
module "mongodb" {
  source            = "../.."
  resource_group_id = module.resource_group.resource_group_id
  instance_name     = "${var.prefix}-mongodb"
  region            = var.region
  tags              = var.resource_tags
  auto_scaling      = var.auto_scaling
}
