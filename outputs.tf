##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "MongoDB instance ID"
  value       = ibm_database.mongodb.id
}

output "guid" {
  description = "MongoDB instance guid"
  value       = ibm_database.mongodb.guid
}

output "version" {
  description = "MongoDB instance version"
  value       = ibm_database.mongodb.version
}

output "crn" {
  description = "MongoDB instance crn"
  value       = ibm_database.mongodb.resource_crn
}

output "cbr_rule_ids" {
  description = "CBR rule ids created to restrict MongoDB"
  value       = module.cbr_rule[*].rule_id
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = local.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = local.service_credentials_object
  sensitive   = true
}
