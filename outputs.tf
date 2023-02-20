##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "mongodb instance id (CRN)"
  value       = ibm_database.mongodb.id
}

output "guid" {
  description = "mongodb instance guid"
  value       = ibm_database.mongodb.guid
}

output "version" {
  description = "mongodb instance version"
  value       = ibm_database.mongodb.version
}
