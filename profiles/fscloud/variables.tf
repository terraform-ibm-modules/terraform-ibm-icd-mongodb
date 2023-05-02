##############################################################################
# Input Variables
##############################################################################

variable "resource_group_id" {
  description = "The resource group ID where the mongodb will be created"
  type        = string
}

variable "mongodb_version" {
  description = "The version of mongodb. If null, the current default ICD mongodb version is used."
  type        = string
  default     = null
}

variable "plan" {
  type        = string
  description = "The name of the service plan that you choose for your mongodb instance"
  default     = "standard"
}

variable "region" {
  description = "The region mongodb is to be created on. The region must support KYOK."
  type        = string
  default     = "us-south"
}

variable "configuration" {
  description = "(Optional, Json String) Database Configuration in JSON format."
  type = object({
    maxmemory                   = optional(number)
    maxmemory-policy            = optional(string)
    appendonly                  = optional(string)
    maxmemory-samples           = optional(number)
    stop-writes-on-bgsave-error = optional(string)
  })
  default = null
}

variable "cpu_count" {
  description = "Number of CPU cores available to the mongodb instance"
  type        = number
  default     = 7
}

variable "memory_mb" {
  description = "Memory available to the mongodb instance"
  type        = number
  default     = 1024
}

variable "disk_mb" {
  description = "Disk space available to the mongodb instance"
  type        = number
  default     = 20480
}


variable "instance_name" {
  description = "Name of the mongodb instance"
  type        = string
}

variable "tags" {
  type        = list(any)
  description = "Optional list of tags to be applied to the mongodb instance."
  default     = []
}

variable "kms_key_crn" {
  type        = string
  description = "The root key CRN of a Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption. See https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs&interface=ui for more information on integrating HPCS with mongodb instance."
}

variable "existing_kms_instance_guid" {
  description = "The GUID of the Hyper Protect Crypto service."
  type        = string
}

variable "backup_encryption_key_crn" {
  type        = string
  description = "The CRN of a Key Protect Key to use for encrypting backups. Take note that Hyper Protect Crypto Services for IBM Cloud® Databases backups is not currently supported."
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits all mongodb instances in the provided resource group reader access to the instance specified in the existing_kms_instance_guid variable."
  default     = false
}

variable "auto_scaling" {
  type = object({
    cpu = object({
      rate_increase_percent       = optional(number)
      rate_limit_count_per_member = optional(number)
      rate_period_seconds         = optional(number)
      rate_units                  = optional(string)
    })
    disk = object({
      capacity_enabled             = optional(bool)
      free_space_less_than_percent = optional(number)
      io_above_percent             = optional(number)
      io_over_period               = optional(string)
      io_enabled                   = optional(bool)
      rate_increase_percent        = optional(number)
      rate_limit_mb_per_member     = optional(number)
      rate_period_seconds          = optional(number)
      rate_units                   = optional(string)
    })
    memory = object({
      io_above_percent         = optional(number)
      io_enabled               = optional(bool)
      io_over_period           = optional(string)
      rate_increase_percent    = optional(number)
      rate_limit_mb_per_member = optional(number)
      rate_period_seconds      = optional(number)
      rate_units               = optional(string)
    })
  })
  description = "Configure rules to allow your database to automatically increase its resources. Single block of autoscaling is allowed at once."
  default = {
    cpu    = {}
    disk   = {}
    memory = {}
  }
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
