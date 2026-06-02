##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "MongoDB instance ID"
  value       = can(ibm_database.mongodb.id) ? ibm_database.mongodb.id : null
}

output "version" {
  description = "MongoDB instance version"
  value       = can(ibm_database.mongodb.version) ? ibm_database.mongodb.version : null
}

output "guid" {
  description = "MongoDB instance guid"
  value       = can(ibm_database.mongodb.guid) ? ibm_database.mongodb.guid : null
}

output "crn" {
  description = "MongoDB instance crn"
  value       = can(ibm_database.mongodb.resource_crn) ? ibm_database.mongodb.resource_crn : null
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

output "cbr_rule_ids" {
  description = "CBR rule ids created to restrict MongoDB"
  value       = module.cbr_rule[*].rule_id
}

output "adminuser" {
  description = "Database admin user name"
  value       = can(ibm_database.mongodb.adminuser) ? ibm_database.mongodb.adminuser : null
}

output "hostname" {
  description = "Database connection hostname"
  value       = can(data.ibm_database_connection.database_connection[0].mongodb[0].hosts[0].hostname) ? data.ibm_database_connection.database_connection[0].mongodb[0].hosts[0].hostname : null
}

output "member_hosts" {
  description = "Replica set member list of objects with hostnames and ports"
  value       = can(data.ibm_database_connection.database_connection[0].mongodb[0].hosts) ? data.ibm_database_connection.database_connection[0].mongodb[0].hosts : null
}

output "port" {
  description = "Database connection port"
  value       = can(data.ibm_database_connection.database_connection[0].mongodb[0].hosts[0].port) ? data.ibm_database_connection.database_connection[0].mongodb[0].hosts[0].port : null
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = can(data.ibm_database_connection.database_connection[0].mongodb[0].certificate[0].certificate_base64) ? data.ibm_database_connection.database_connection[0].mongodb[0].certificate[0].certificate_base64 : null
  sensitive   = true
}
