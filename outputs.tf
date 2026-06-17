##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "MongoDB instance ID"
  value       = ibm_database.mongodb.id
}

output "version" {
  description = "MongoDB instance version"
  value       = ibm_database.mongodb.version
}

output "guid" {
  description = "MongoDB instance guid"
  value       = ibm_database.mongodb.guid
}

output "crn" {
  description = "MongoDB instance crn"
  value       = ibm_database.mongodb.resource_crn
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
  value       = ibm_database.mongodb.adminuser
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
