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
  default     = "dev"
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

variable "backup_encryption_key_crn" {
  type        = string
  description = "The CRN of a key protect key, that you want to use for encrypting disk that holds deployment backups. If null, will use 'key_protect_key_crn' as encryption key. If 'key_protect_key_crn' is also null database is encrypted by using randomly generated keys."
  default     = null
}
