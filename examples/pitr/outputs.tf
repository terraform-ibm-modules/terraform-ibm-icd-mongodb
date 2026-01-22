##############################################################################
# Outputs
##############################################################################

output "pitr_instance_id" {
  description = "PITR MongoDB instance id"
  value       = module.mongo_db_pitr.id
}

output "pitr_instance_version" {
  description = "PITR MongoDB instance version"
  value       = module.mongo_db_pitr.version
}

output "pitr_time" {
  description = "PITR timestamp in UTC format (%Y-%m-%dT%H:%M:%SZ) used to create PITR instance"
  value       = var.pitr_time
}
