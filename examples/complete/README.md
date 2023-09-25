# Complete example with BYOK encryption and CBR rules

An end-to-end example that uses the IBM Cloud Terraform provider to create the following infrastructure:

- A resource group, if one is not passed in.
- A Key Protect instance with a root key.
- An instance of Databases for MongoDB with BYOK encryption.
- Set 250 max connection for Databases for MongoDB instance.
- Service credentials for the database instance.
- A sample virtual private cloud (VPC).
- A context-based restriction (CBR) rule to only allow MongoDB to be accessible from within the VPC.
