/********************************************************************
# This file is used to implement the ROOT module
*********************************************************************/
locals {
  # The backup encryption key crn doesn't support Hyper Protect Crypto Service (HPCS) at the moment. If 'backup_encryption_key_crn' is null, will use 'kms_key_crn' as encryption key if its Key Protect key otherwise it will use using randomly generated keys.
  # https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs&interface=cli
  kp_backup_crn = var.backup_encryption_key_crn != null ? var.backup_encryption_key_crn : (can(regex(".*kms.*", var.kms_key_crn)) ? var.kms_key_crn : null)

  auto_scaling_enabled = var.auto_scaling == null ? [] : [1]

  kms_service = var.kms_key_crn != null ? (
    can(regex(".*kms.*", var.kms_key_crn)) ? "kms" : (
      can(regex(".*hs-crypto.*", var.kms_key_crn)) ? "hs-crypto" : "unrecognized key type"
    )
  ) : "no key crn"

  # tflint-ignore: terraform_unused_declarations
  validate_hpcs_guid_input = var.skip_iam_authorization_policy == false && var.existing_kms_instance_guid == null ? tobool("A value must be passed for var.existing_kms_instance_guid when creating an instance, var.skip_iam_authorization_policy is false.") : true
  # tflint-ignore: terraform_unused_declarations
  validate_kms_key_input = var.skip_iam_authorization_policy == false && var.kms_key_crn == null ? tobool("A value must be passed for var.kms_key_crn when creating an instance, var.skip_iam_authorization_policy is false.") : true
}

# Create IAM Authorization Policies to allow MongoDB to access kms for the encryption key
resource "ibm_iam_authorization_policy" "kms_policy" {
  count                       = var.skip_iam_authorization_policy ? 0 : 1
  source_service_name         = "databases-for-mongodb"
  source_resource_group_id    = var.resource_group_id
  target_service_name         = local.kms_service
  target_resource_instance_id = var.existing_kms_instance_guid
  roles                       = ["Reader"]
}

resource "ibm_database" "mongodb" {
  depends_on        = [ibm_iam_authorization_policy.kms_policy]
  name              = var.instance_name
  location          = var.region
  plan              = var.plan
  service           = "databases-for-mongodb"
  version           = var.mongodb_version
  resource_group_id = var.resource_group_id
  tags              = var.tags
  service_endpoints = var.endpoints

  key_protect_key           = var.kms_key_crn
  backup_encryption_key_crn = local.kp_backup_crn

  configuration = var.configuration != null ? jsonencode(var.configuration) : null

  ## This for_each block is NOT a loop to attach to multiple auto_scaling blocks.
  ## This block is only used to conditionally add auto_scaling block depending on var.auto_scaling
  dynamic "auto_scaling" {
    for_each = local.auto_scaling_enabled
    content {
      cpu {
        rate_increase_percent       = var.auto_scaling.cpu.rate_increase_percent
        rate_limit_count_per_member = var.auto_scaling.cpu.rate_limit_count_per_member
        rate_period_seconds         = var.auto_scaling.cpu.rate_period_seconds
        rate_units                  = var.auto_scaling.cpu.rate_units
      }
      disk {
        capacity_enabled             = var.auto_scaling.disk.capacity_enabled
        free_space_less_than_percent = var.auto_scaling.disk.free_space_less_than_percent
        io_above_percent             = var.auto_scaling.disk.io_above_percent
        io_enabled                   = var.auto_scaling.disk.io_enabled
        io_over_period               = var.auto_scaling.disk.io_over_period
        rate_increase_percent        = var.auto_scaling.disk.rate_increase_percent
        rate_limit_mb_per_member     = var.auto_scaling.disk.rate_limit_mb_per_member
        rate_period_seconds          = var.auto_scaling.disk.rate_period_seconds
        rate_units                   = var.auto_scaling.disk.rate_units
      }
      memory {
        io_above_percent         = var.auto_scaling.memory.io_above_percent
        io_enabled               = var.auto_scaling.memory.io_enabled
        io_over_period           = var.auto_scaling.memory.io_over_period
        rate_increase_percent    = var.auto_scaling.memory.rate_increase_percent
        rate_limit_mb_per_member = var.auto_scaling.memory.rate_limit_mb_per_member
        rate_period_seconds      = var.auto_scaling.memory.rate_period_seconds
        rate_units               = var.auto_scaling.memory.rate_units
      }
    }
  }

  group {
    group_id = "member"
    memory {
      allocation_mb = var.memory_mb
    }
    disk {
      allocation_mb = var.disk_mb
    }
    cpu {
      allocation_count = var.cpu_count
    }
    members {
      allocation_count = var.members
    }
  }

  dynamic "allowlist" {
    for_each = { for ipaddress in var.allowlist : ipaddress.address => ipaddress }
    content {
      address     = allowlist.value.address
      description = allowlist.value.description
    }
  }

  timeouts {
    create = "120m"
  }

  lifecycle {
    ignore_changes = [
      version,
      key_protect_key,
      backup_encryption_key_crn,
    ]
  }
}

##############################################################################
# Context Based Restrictions
##############################################################################

module "cbr_rule" {
  count            = length(var.cbr_rules) > 0 ? length(var.cbr_rules) : 0
  source           = "git::https://github.com/terraform-ibm-modules/terraform-ibm-cbr//cbr-rule-module?ref=v1.2.0"
  rule_description = var.cbr_rules[count.index].description
  enforcement_mode = var.cbr_rules[count.index].enforcement_mode
  rule_contexts    = var.cbr_rules[count.index].rule_contexts
  resources = [{
    attributes = [
      {
        name     = "accountId"
        value    = var.cbr_rules[count.index].account_id
        operator = "stringEquals"
      },
      {
        name     = "serviceInstance"
        value    = ibm_database.mongodb.guid
        operator = "stringEquals"
      },
      {
        name     = "serviceName"
        value    = "databases-for-mongodb"
        operator = "stringEquals"
      }
    ]
  }]
  #  There is only 1 operation type for Redis so it is not exposed as a configuration
  operations = [{
    api_types = [
      {
        api_type_id = "crn:v1:bluemix:public:context-based-restrictions::::api-type:data-plane"
      }
    ]
  }]
}
