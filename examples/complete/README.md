# Complete example with encryption, autoscaling, and CBR rules

An end-to-end example that uses the IBM Cloud Terraform provider to create the following infrastructure:

- A resource group, if one is not passed in.
- An instance of Databases for MongoDB with autoscaling enabled (automatically increases resources).
- A Key Protect instance with a root key.
- Backend encryption that uses the generated Key Protect key.
- A sample virtual private cloud (VPC).
- A context-based restriction (CBR) rule to prevent access from the VPC except to the MongoDB database.

:exclamation: **Important:** Make sure you understand the effects of autoscaling, especially for production environments. See https://ibm.biz/autoscaling-considerations in the IBM Cloud Docs.
