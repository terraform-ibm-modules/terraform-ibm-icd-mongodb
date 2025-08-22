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

output "hostname" {
  description = "Database hostname. Only contains value when var.service_credential_names or var.users are set."
  value       = module.mongodb.hostname
}

output "replica_hostnames" {
  description = "List of hostnames for all MongoDB replica set members"
  value       = module.mongodb.replica_hostnames
}

output "port" {
  description = "Database port. Only contains value when var.service_credential_names or var.users are set."
  value       = module.mongodb.port
}
