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

output "member_hosts" {
  description = "Replica set member list of objects with hostnames and ports"
  value       = module.mongodb.member_hosts
}

output "port" {
  description = "Database port. Only contains value when var.service_credential_names or var.users are set."
  value       = module.mongodb.port
}
