# Restore from backup example

This example provides an end-to-end executable flow of how a Mongo DB instance can be created from a backup instance. This example uses the IBM Cloud terraform provider to:

- Create a new resource group if one is not passed in.
- Create a restored ICD Mongo database instance pointing to the lastest backup of the existing Mongo database instance crn passed.
