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
  type        = number
  description = "Version of the mongodb instance"
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
