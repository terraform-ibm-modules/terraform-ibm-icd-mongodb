##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "MongoDB instance ID"
  value       = ibm_database.mongodb_database.id
}

output "guid" {
  description = "MongoDB instance guid"
  value       = ibm_database.mongodb_database.guid
}

output "version" {
  description = "MongoDB instance version"
  value       = ibm_database.mongodb_database.version
}

output "crn" {
  description = "MongoDB instance crn"
  value       = ibm_database.mongodb_database.resource_crn
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

output "adminuser" {
  description = "Database admin user name"
  value       = ibm_database.mongodb_database.adminuser
}

output "hostname" {
  description = "Database connection hostname"
  value       = data.ibm_database_connection.database_connection.mongodb[0].hosts[0].hostname
}

output "port" {
  description = "Database connection port"
  value       = data.ibm_database_connection.database_connection.mongodb[0].hosts[0].port
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = data.ibm_database_connection.database_connection.mongodb[0].certificate[0].certificate_base64
  sensitive   = true
}
