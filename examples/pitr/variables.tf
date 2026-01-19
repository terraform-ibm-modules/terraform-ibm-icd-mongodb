variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example."
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "mdb-pitr"
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "mongodb_version" {
  description = "Version of the MongoDB instance. If no value passed, the current ICD preferred version is used."
  type        = string
  default     = null
}

variable "plan" {
  type        = string
  description = "The name of the service plan that you choose for your MongoDB instance , Note: PITR is only supported by enterprise plan [Learn more](https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pitr&interface=ui ) "
  default     = "enterprise"
}

variable "member_host_flavor" {
  type        = string
  description = "Allocated host flavor per member. Note: enterprise plan does not supports multitenent(shared) hosting [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/database#host_flavor)."
  default     = "b3c.4x16.encrypted"
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "Optional list of access management tags to add to resources that are created"
  default     = []
}

variable "pitr_id" {
  type        = string
  description = "The ID of the source deployment MongoDB instance that you want to recover back to. The MongoDB instance is expected to be in an up and in running state."
}

variable "pitr_time" {
  type        = string
  description = "The timestamp in UTC format (%Y-%m-%dT%H:%M:%SZ) for any time in the last 7 days that you want to restore to. If empty string (\"\") or spaced string (\" \") is passed, latest_point_in_time_recovery_time will be used as pitr_time. To retrieve the timestamp, run the command (ibmcloud cdb mongodb-enterprise earliest-pitr-timestamp <deployment name or CRN>). For more info on Point-in-time Recovery, see https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pitr&interface=ui"
}