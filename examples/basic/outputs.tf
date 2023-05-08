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
