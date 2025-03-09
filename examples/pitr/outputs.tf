##############################################################################
# Outputs
##############################################################################

output "mongodb_time" {
  description = "PITR timestamp in UTC format (%Y-%m-%dT%H:%M:%SZ) used to create PITR instance"
  value       = var.pitr_time
}
output "pitr_mongodb_db_id" {
  description = "PITR MongoDB instance id"
  value       = module.mongodb_db_pitr.id
}

output "pitr_mongodb_db_version" {
  description = "PITR MongoDB instance version"
  value       = module.mongodb_db_pitr.version
}
