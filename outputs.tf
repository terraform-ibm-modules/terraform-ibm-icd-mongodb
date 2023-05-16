##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "mongodb instance id (CRN)"
  value       = ibm_database.mongodb.id
}

output "guid" {
  description = "mongodb instance guid"
  value       = ibm_database.mongodb.guid
}

output "version" {
  description = "mongodb instance version"
  value       = ibm_database.mongodb.version
}

output "crn" {
  description = "Postgresql instance crn"
  value       = ibm_database.mongodb.resource_crn
}

output "cbr_rule_ids" {
  description = "CBR rule ids created to restrict Postgresql"
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
