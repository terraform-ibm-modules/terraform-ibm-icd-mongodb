##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "MongoDB instance id"
  value       = var.mongo_db_backup_crn == null ? module.mongo_db[0].id : null
}

output "restored_mongo_db_id" {
  description = "Restored MongoDB instance id"
  value       = module.restored_mongo_db.id
}

output "restored_mongo_db_version" {
  description = "Restored MongoDB instance version"
  value       = module.restored_mongo_db.version
}
