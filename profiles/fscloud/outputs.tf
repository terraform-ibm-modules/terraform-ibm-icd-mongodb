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

output "crn" {
  description = "MongoDB instance crn"
  value       = module.mongodb.crn
}

output "cbr_rule_ids" {
  description = "CBR rule ids created to restrict MongoDB"
  value       = module.mongodb.cbr_rule_ids
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = module.mongodb.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = module.mongodb.service_credentials_object
  sensitive   = true
}
