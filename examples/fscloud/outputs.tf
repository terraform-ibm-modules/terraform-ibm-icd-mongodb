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
