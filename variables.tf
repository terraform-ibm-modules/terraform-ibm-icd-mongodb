##############################################################################
# Input Variables
##############################################################################

variable "instance_name" {
  type        = string
  description = "Name of the MongoDB instance"
}

variable "region" {
  type        = string
  description = "The IBM Cloud region where instance will be created"
  default     = "us-south"
}

variable "plan" {
  type        = string
  description = "The name of the service plan that you choose for your mongodb instance"
  default     = "standard"
}

variable "allowlist" {
  description = "(Optional, List of Objects) A list of allowed IP addresses for the database."
  type = list(object({
    address     = string
    description = string
  }))
  default = []
}

variable "configuration" {
  description = "Database Configuration in JSON format."
  type = object({
    maxmemory                   = optional(number)
    maxmemory-policy            = optional(string)
    appendonly                  = optional(string)
    maxmemory-samples           = optional(number)
    stop-writes-on-bgsave-error = optional(string)
  })
  default = null
}

variable "mongodb_version" {
  type        = string
  description = "The version of the mongodb to be provisioned"
  default     = null
  validation {
    condition = anytrue([
      var.mongodb_version == null,
      var.mongodb_version == "4.4",
      var.mongodb_version == "4.2",
    ])
    error_message = "Version must be 4.2 or 4.4. If null, the current default ICD mongodb version is used"
  }
}

variable "resource_group_id" {
  type        = string
  description = "The ID of the IMB Cloud resource group where you want to create the instance"
}

variable "tags" {
  type        = list(any)
  description = "A list of tags that you want to add to your instance"
  default     = []
}

variable "endpoints" {
  type        = string
  description = "Endpoints available to the mongodb instance (public, private, public-and-private)"
  default     = "private"

  validation {
    condition     = can(regex("public|private|public-and-private", var.endpoints))
    error_message = "Valid values are (public, private, or public-and-private)."
  }
}

variable "key_protect_key_crn" {
  type        = string
  description = "(Optional) The root key CRN of a Key Management Service like Key Protect or Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption. If `null`, database is encrypted by using randomly generated keys. See https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok for current list of supported regions for BYOK"
  default     = null
}

variable "backup_encryption_key_crn" {
  type        = string
  description = "(Optional) The CRN of a key protect key, that you want to use for encrypting disk that holds deployment backups. If null, will use 'key_protect_key_crn' as encryption key. If 'key_protect_key_crn' is also null database is encrypted by using randomly generated keys."
  default     = null
}

variable "memory_mb" {
  type        = number
  description = "Memory available to the mongodb instance"
  default     = 1024

  validation {
    condition = alltrue([
      var.memory_mb >= 1024,
      var.memory_mb <= 114688
    ])
    error_message = "Member group memory must be >= 1024 and <= 114688 in increments of 128."
  }
}

variable "disk_mb" {
  type        = number
  description = "Disk available to the mongodb instance"
  default     = 20480

  validation {
    condition = alltrue([
      var.disk_mb >= 5120,
      var.disk_mb <= 4194304
    ])
    error_message = "Member group disk must be >= 5120 and <= 4194304 in increments of 1024."
  }
}

variable "cpu_count" {
  type        = number
  description = "Number of CPU cores available to the mongodb instance"
  default     = 7

  validation {
    condition = alltrue([
      var.cpu_count >= 6,
      var.cpu_count <= 28
    ])
    error_message = "Number of cpus must be >= 6 and <= 28 in increments of 1."
  }
}


variable "members" {
  type        = number
  description = "Allocated number of members"
  default     = 3

  validation {
    condition = alltrue([
      var.members == 3
    ])
    error_message = "Member group members must be >= 3 or <=3 in increments of 1."
  }
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
  description = "Configure rules to allow your database to automatically increase its resources. Single block of autoscaling is allowed at once."
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
