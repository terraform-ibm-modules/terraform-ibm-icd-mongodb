locals {
  # Determine if gen2 plan is being used
  is_gen2 = can(regex("-gen2$", var.plan))

  gen2_host_flavor    = "bx3d.4x20"
  classic_host_flavor = "multitenant"

  gen2_service_credential_names = [
    {
      name     = "mongodb_manager"
      role     = "Manager"
      endpoint = var.service_endpoints
    },
    {
      name     = "mongodb_writer"
      role     = "Writer"
      endpoint = var.service_endpoints
    }
  ]
  classic_service_credential_names = [
    {
      name     = "mongodb_admin"
      role     = "Administrator"
      endpoint = var.service_endpoints
    },
    {
      name     = "mongodb_operator"
      role     = "Operator"
      endpoint = var.service_endpoints
    },
    {
      name     = "mongodb_viewer"
      role     = "Viewer"
      endpoint = var.service_endpoints
    },
    {
      name     = "mongodb_editor"
      role     = "Editor"
      endpoint = var.service_endpoints
    }
  ]
}

##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.6.1"
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
  resource_group_id        = module.resource_group.resource_group_id
  name                     = "${var.prefix}-data-store"
  region                   = var.region
  plan                     = var.plan
  mongodb_version          = var.mongodb_version
  access_tags              = var.access_tags
  tags                     = var.resource_tags
  service_endpoints        = var.service_endpoints
  member_host_flavor       = local.is_gen2 ? local.gen2_host_flavor : local.classic_host_flavor
  deletion_protection      = false
  service_credential_names = local.is_gen2 ? local.gen2_service_credential_names : local.classic_service_credential_names

}
