##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "mongodb instance id"
  value       = ibm_database.mongodb.id
}

output "version" {
  description = "mongodb instance version"
  value       = ibm_database.mongodb.version
}
