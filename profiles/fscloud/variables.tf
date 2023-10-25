##############################################################################
# Input Variables
##############################################################################

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where the MongoDB instance will be created."
}

variable "mongodb_version" {
  description = "Version of the MongoDB instance. If no value is passed, the current preferred version of IBM Cloud Databases is used."
  type        = string
  default     = null
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the MongoDB instance created by the module, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial for more details"
  default     = []
}

variable "region" {
  description = "The region where you want to deploy your instance. Must be the same region as the Hyper Protect Crypto Services instance."
  type        = string
  default     = "us-south"
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
  description = "Allocated memory per member. For more information, see https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member"
  default     = 14336
  # Validation is done in terraform plan phase by IBM provider, so no need to add any extra validation here
}

variable "disk_mb" {
  type        = number
  description = "Allocated disk per member. For more information, see https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member"
  default     = 20480
  # Validation is done in terraform plan phase by IBM provider, so no need to add any extra validation here
}

variable "cpu_count" {
  type        = number
  description = "Allocated dedicated CPU per member. For shared CPU, set to 0. For more information, see https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member"
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

variable "admin_pass" {
  type        = string
  description = "The password for the database administrator. If the admin password is null then the admin user ID cannot be accessed. More users can be specified in a user block. The admin password must be in the range of 10-32 characters and cannot start with a special character."
  default     = null
  sensitive   = true
}

variable "users" {
  type = list(object({
    name     = string
    password = string # pragma: allowlist secret
    type     = string # "type" is required to generate the connection string for the outputs.
    role     = optional(string)
  }))
  default     = []
  sensitive   = true
  description = "A list of users that you want to create on the database. Multiple blocks are allowed. The user password must be in the range of 10-32 characters. Be warned that in most case using IAM service credentials (via the var.service_credential_names) is sufficient to control access to the MongoDB instance. This blocks creates native MongoDB database users, more info on that can be found here https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-user-management&interface=ui"
}

variable "instance_name" {
  description = "Name of the mongodb instance"
  type        = string
}

variable "tags" {
  type        = list(any)
  description = "Optional list of tags to be added to the MongoDB instance."
  default     = []
}

variable "kms_key_crn" {
  type        = string
  description = "The root key CRN of the Hyper Protect Crypto Service (HPCS) to use for disk encryption."
}

variable "existing_kms_instance_guid" {
  description = "The GUID of the Hyper Protect Crypto Services instance."
  type        = string
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits all MongoDB database instances in the resource group to read the encryption key from the Hyper Protect Crypto Services instance. The HPCS instance is passed in through the var.existing_kms_instance_guid variable."
  default     = false
}

variable "auto_scaling" {
  type = object({
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
