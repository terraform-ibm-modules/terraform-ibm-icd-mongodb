##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "MongoDB instance id"
  value       = local.mongodb_id
}

output "version" {
  description = "MongoDB instance version"
  value       = local.mongodb_version
}

output "guid" {
  description = "MongoDB instance guid"
  value       = local.mongodb_guid
}

output "crn" {
  description = "MongoDB instance crn"
  value       = local.mongodb_crn
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = var.existing_mongodb_instance_crn != null ? null : module.mongodb[0].service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = var.existing_mongodb_instance_crn != null ? null : module.mongodb[0].service_credentials_object
  sensitive   = true
}

output "hostname" {
  description = "Database connection hostname"
  value       = local.mongodb_hostname
}

output "port" {
  description = "Database connection port"
  value       = local.mongodb_port
}

output "secrets_manager_secrets" {
  description = "Service credential secrets"
  value       = length(local.service_credential_secrets) > 0 ? module.secrets_manager_service_credentials[0].secrets : null
}

output "next_steps_text" {
  value       = "Your Database for MongoDB is ready."
  description = "Next steps text"
}

output "next_step_primary_label" {
  value       = "Go To Database"
  description = "Primary label"
}

output "next_step_primary_url" {
  value       = "https://cloud.ibm.com/services/databases-for-mongodb/${local.mongodb_crn}"
  description = "Primary URL"
}
