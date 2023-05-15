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
  description = "mongodb instance guid"
  value       = module.mongodb.guid
}
