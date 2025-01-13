##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "MongoDB instance id"
  value       = module.mongodb.id
}

output "version" {
  description = "MongoDB instance version"
  value       = module.mongodb.version
}

output "guid" {
  description = "MongoDB instance guid"
  value       = module.mongodb.guid
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

output "port" {
  description = "Database connection port"
  value       = module.mongodb.port
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = module.mongodb.certificate_base64
  sensitive   = true
}

output "secrets_manager_secrets" {
  description = "Service credential secrets"
  value       = length(local.service_credential_secrets) > 0 ? module.secrets_manager_service_credentials[0].secrets : null
}