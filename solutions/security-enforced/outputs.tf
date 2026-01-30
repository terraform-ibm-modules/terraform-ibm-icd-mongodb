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

output "hostname" {
  description = "Database connection hostname"
  value       = module.mongodb.hostname
}

output "port" {
  description = "Database connection port"
  value       = module.mongodb.port
}

output "secrets_manager_secrets" {
  description = "Service credential secrets"
  value       = module.mongodb.secrets_manager_secrets
}

output "next_steps_text" {
  value       = module.mongodb.next_steps_text
  description = "Next steps text"
}

output "next_step_primary_label" {
  value       = module.mongodb.next_step_primary_label
  description = "Primary label"
}

output "next_step_primary_url" {
  value       = module.mongodb.next_step_primary_url
  description = "Primary URL"
}

output "next_step_secondary_label" {
  value       = module.mongodb.next_step_secondary_label
  description = "Secondary label"
}

output "next_step_secondary_url" {
  value       = module.mongodb.next_step_secondary_url
  description = "Secondary URL"
}
