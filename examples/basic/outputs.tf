##############################################################################
# Outputs
##############################################################################
output "id" {
  description = "Mongodb instance id"
  value       = module.mongodb.id
}

output "version" {
  description = "Mongodb instance version"
  value       = module.mongodb.version
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
