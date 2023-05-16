# Complete example with encryption, autoscaling, and CBR rules

An end-to-end example that uses the IBM Cloud Terraform provider to create the following infrastructure:

- A resource group, if one is not passed in.
- A Key Protect instance with a root key.
- An instance of Databases for MongoDB with BYOK encryption and autoscaling enabled (automatically increases resources).
- Service credentials for the database instance.
- A sample virtual private cloud (VPC).
- A context-based restriction (CBR) rule to only allow MongoDB to be accessible from within the VPC.
