##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "mongodb instance id"
  value       = module.mongodb.id
}

output "version" {
  description = "mongodb instance version"
  value       = module.mongodb.version
}
