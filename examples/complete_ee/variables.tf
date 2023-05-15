variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example"
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "mongodb"
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "mongodb_version" {
  type        = string
  description = "Version of the mongodb instance. If left at null, the latest version is provisioned."
  default     = null
}

variable "service_credentials" {
  description = "A list of service credentials that you want to create for the database"
  type        = list(string)
  default     = ["mongodb_credential_microservices", "mongodb_credential_dev_1", "mongodb_credential_dev_2"]
}

variable "enforcement_mode" {
  description = "whether or not enforce a rule upon creation and update the rule enforcement."
  type        = string
  default     = "enabled"
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
      io_enabled                   = optional(bool)
      io_over_period               = optional(string)
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
    cpu = {}
    disk = {
      capacity_enabled : true,
      io_enabled : true
    }
    memory = {
      io_enabled : true,
    }
  }
}

variable "plan" {
  type        = string
  description = "The name of the service plan that you choose for your mongodb instance"
  default     = "enterprise"
}

variable "memory_mb" {
  type        = number
  description = "Memory available to the database instance in MB. For more information refer to the docs https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member"
  default     = 24576
}

variable "disk_mb" {
  type        = number
  description = "Disk space available to the database instance. For more information refer to the docs https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member"
  default     = 122880
}

variable "cpu_count" {
  type        = number
  description = "The number of CPU cores available to the database instance. For more information refer to the docs https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member"
  default     = 6
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