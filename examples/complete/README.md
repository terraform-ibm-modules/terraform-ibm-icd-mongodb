# Complete example with Encryption and CBR rules

An example that adds encryption to the [default example](../default/README.md).

This example uses the IBM Cloud Terraform provider to create the following infrastructure:

- A resource group, if one is not passed in.
- An encrypted ICD MongoDB instance with credentials stored in IBM Cloud Secrets Manager.
