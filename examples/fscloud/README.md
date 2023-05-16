# Financial Services Cloud profile example

An end-to-end example that uses the [Profile for IBM Cloud Framework for Financial Services](../../profiles/fscloud/) to deploy an instance of IBM Cloud Databases for MongoDB.

The example uses the IBM Cloud Terraform provider to create the following infrastructure:

- A resource group, if one is not passed in.
- An IAM authorization between all MongoDB database instances in the given resource group, and the Hyper Protect Crypto Services instance that is passed in.
- An IBM Cloud Databases MongoDB database instance that is encrypted with the Hyper Protect Crypto Services root key that is passed in.
- Service Credentials for the MongoDB database instance.
- A sample virtual private cloud (VPC).
- A context-based restriction (CBR) rule to only allow MongoDB to be accessible from within the VPC.

:exclamation: **Important:** In this example, only the IBM Cloud Databases for MongoDB instance complies with the IBM Cloud Framework for Financial Services. Other parts of the infrastructure do not necessarily comply.

## Before you begin

- You need a Hyper Protect Crypto Services instance and root key available in the region that you want to deploy your MongoDB database instance to.
