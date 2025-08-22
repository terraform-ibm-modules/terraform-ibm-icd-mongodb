##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "MongoDB instance id"
  value       = module.icd_mongodb.id
}

output "version" {
  description = "MongoDB instance version"
  value       = module.icd_mongodb.version
}

output "guid" {
  description = "mongodb instance guid"
  value       = module.icd_mongodb.guid
}

output "crn" {
  description = "MongoDB instance crn"
  value       = module.icd_mongodb.crn
}

output "service_credentials_json" {
  description = "Service credentials json map"
  value       = module.icd_mongodb.service_credentials_json
  sensitive   = true
}

output "service_credentials_object" {
  description = "Service credentials object"
  value       = module.icd_mongodb.service_credentials_object
  sensitive   = true
}

output "hostname" {
  description = "MongoDB instance hostname"
  value       = module.icd_mongodb.hostname
}

output "replica_hostnames" {
  description = "List of hostnames for all MongoDB replica set members"
  value       = module.icd_mongodb.replica_hostnames
}

output "port" {
  description = "MongoDB instance port"
  value       = module.icd_mongodb.port
}
