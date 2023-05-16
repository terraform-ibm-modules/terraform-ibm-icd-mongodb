##############################################################################
# Input Variables
##############################################################################

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where the MongoDB instance will be created."
}

variable "mongodb_version" {
  description = "The version of the MongoDB to provision. If no value passed, the current ICD preferred version is used."
  type        = string
  default     = null
}

variable "region" {
  description = "The region where you want to deploy your instance. Must be the same region as the Hyper Protect Crypto Service."
  type        = string
  default     = "us-south"
}

variable "configuration" {
  description = "Database Configuration."
  type = object({
    maxmemory                   = optional(number)
    maxmemory-policy            = optional(string)
    appendonly                  = optional(string)
    maxmemory-samples           = optional(number)
    stop-writes-on-bgsave-error = optional(string)
  })
  default = null
}

variable "plan" {
  type        = string
  description = "The name of the service plan that you choose for your MongoDB instance"
  default     = "enterprise"
  validation {
    condition = anytrue([
      var.plan == "standard",
      var.plan == "enterprise",
    ])
    error_message = "Only supported plans are standard or enterprise"
  }
}

variable "memory_mb" {
  type        = number
  description = "Allocated memory per-member. For more information refer to the docs https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member"
  default     = 14336
  # Validation is done in terraform plan phase by IBM provider, so no need to add any extra validation here
}

variable "disk_mb" {
  type        = number
  description = "Allocated disk per-member. For more information refer to the docs https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member"
  default     = 20480
  # Validation is done in terraform plan phase by IBM provider, so no need to add any extra validation here
}

variable "cpu_count" {
  type        = number
  description = "Allocated dedicated CPU per-member. For shared CPU, set to 0. For more information refer to the docs https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member"
  default     = 6
  # Validation is done in terraform plan phase by IBM provider, so no need to add any extra validation here
}

variable "members" {
  type        = number
  description = "Allocated number of members"
  default     = 3
  # Validation is done in terraform plan phase by IBM provider, so no need to add any extra validation here
}

variable "service_credential_names" {
  description = "Map of name, role for service credentials that you want to create for the database"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for name, role in var.service_credential_names : contains(["Administrator", "Operator", "Viewer", "Editor"], role)])
    error_message = "Valid values for service credential roles are 'Administrator', 'Operator', 'Viewer', and `Editor`"
  }
}

variable "instance_name" {
  description = "Name of the mongodb instance"
  type        = string
}

variable "tags" {
  type        = list(any)
  description = "Optional list of tags to be added to the MongoDB instance and the associated service credentials (if creating)."
  default     = []
}

variable "kms_key_crn" {
  type        = string
  description = "The root key CRN of the Hyper Protect Crypto Service (HPCS) to use for disk encryption."
}

variable "existing_kms_instance_guid" {
  description = "The GUID of the Hyper Protect Crypto Service."
  type        = string
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits all MongoDB database instances in the given resource group to read the encryption key from the Hyper Protect instance passed in var.existing_kms_instance_guid."
  default     = false
}

variable "auto_scaling" {
  type = object({
    cpu = object({
      rate_increase_percent       = optional(number, 10)
      rate_limit_count_per_member = optional(number, 20)
      rate_period_seconds         = optional(number, 900)
      rate_units                  = optional(string, "count")
    })
    disk = object({
      capacity_enabled             = optional(bool, false)
      free_space_less_than_percent = optional(number, 10)
      io_above_percent             = optional(number, 90)
      io_enabled                   = optional(bool, false)
      io_over_period               = optional(string, "15m")
      rate_increase_percent        = optional(number, 10)
      rate_limit_mb_per_member     = optional(number, 3670016)
      rate_period_seconds          = optional(number, 900)
      rate_units                   = optional(string, "mb")
    })
    memory = object({
      io_above_percent         = optional(number, 90)
      io_enabled               = optional(bool, false)
      io_over_period           = optional(string, "15m")
      rate_increase_percent    = optional(number, 10)
      rate_limit_mb_per_member = optional(number, 114688)
      rate_period_seconds      = optional(number, 900)
      rate_units               = optional(string, "mb")
    })
  })
  description = "Optional rules to allow the database to increase resources in response to usage. Only a single autoscaling block is allowed. Make sure you understand the effects of autoscaling, especially for production environments. See https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-autoscaling&interface=cli#autoscaling-considerations in the IBM Cloud Docs."
  default     = null
}

##############################################################
# Context-based restriction (CBR)
##############################################################

variable "cbr_rules" {
  type = list(object({
    description = string
    account_id  = string
    rule_contexts = list(object({
      attributes = optional(list(object({
        name  = string
        value = string
    }))) }))
    enforcement_mode = string
  }))
  description = "(Optional, list) List of CBR rules to create"
  default     = []
  # Validation happens in the rule module
}
