##############################################################################
# Outputs
##############################################################################

output "restored_icd_mongodb_id" {
  description = "Restored MongoDB instance id"
  value       = module.restored_icd_mongodb.id
}

output "restored_icd_mongodb_version" {
  description = "Restored MongoDB instance version"
  value       = module.restored_icd_mongodb.version
}
