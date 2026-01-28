##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "MongoDB instance id"
  value       = module.mongodb.id
}

output "guid" {
  description = "MongoDB instance guid"
  value       = module.mongodb.guid
}

output "version" {
  description = "MongoDB instance version"
  value       = module.mongodb.version
}

output "crn" {
  description = "MongoDB instance crn"
  value       = module.mongodb.crn
}

output "cbr_rule_ids" {
  description = "CBR rule ids created to restrict MongoDB"
  value       = module.mongodb.cbr_rule_ids
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = module.mongodb.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = module.mongodb.service_credentials_object
  sensitive   = true
}

output "adminuser" {
  description = "Database admin user name"
  value       = module.mongodb.adminuser
}

output "hostname" {
  description = "Database connection hostname"
  value       = module.mongodb.hostname
}

output "member_hosts" {
  description = "Replica set member list of objects with hostnames and ports"
  value       = module.mongodb.member_hosts
}

output "port" {
  description = "Database connection port"
  value       = module.mongodb.port
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = module.mongodb.certificate_base64
  sensitive   = true
}
