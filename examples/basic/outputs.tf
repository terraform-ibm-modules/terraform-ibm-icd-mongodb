##############################################################################
# Outputs
##############################################################################
output "id" {
  description = "Database instance id"
  value       = module.database.id
}

output "mongodb_crn" {
  description = "Mongodb CRN"
  value       = module.database.crn
}

output "version" {
  description = "Mongodb instance version"
  value       = module.database.version
}

output "adminuser" {
  description = "Database admin user name"
  value       = module.database.adminuser
}

output "hostname" {
  description = "Database connection hostname"
  value       = module.database.hostname
}

output "member_hosts" {
  description = "Replica set member list of objects with hostnames and ports"
  value       = module.database.member_hosts
}

output "port" {
  description = "Database connection port"
  value       = module.database.port
}

output "certificate_base64" {
  description = "Database connection certificate"
  value       = module.database.certificate_base64
  sensitive   = true
}
