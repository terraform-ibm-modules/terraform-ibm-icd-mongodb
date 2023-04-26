##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "mongodb instance id"
  value       = module.mongodb.id
}

output "guid" {
  description = "mongodb instance guid"
  value       = module.mongodb.guid
}

output "version" {
  description = "mongodb instance version"
  value       = module.mongodb.version
}
