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

variable "plan" {
  type        = string
  description = "The name of the service plan that you choose for your MongoDB instance"
  default     = "standard"
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the MongoDB instance created by the module, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial for more details"
  default     = []
}

variable "mongodb_version" {
  type        = string
  description = "Version of the MongoDB instance. If no value is passed, the current preferred version of IBM Cloud Databases is used."
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "service_endpoints" {
  type        = string
  description = "Specify whether you want to enable the public or private endpoints on the instance. Supported values are 'public' or 'private'."
  default     = "public"

  validation {
    condition     = can(regex("^(public|private)$", var.service_endpoints))
    error_message = "Valid values for service_endpoints are 'public' or 'private'"
  }
}
