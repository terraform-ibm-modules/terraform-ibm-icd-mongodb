# IBM Cloud Databases for MongoDB

## Prerequisites
- An existing resource group

This architecture creates an instance of IBM Cloud Databases for MongoDB and supports provisioning of the following resources:

- A KMS root key, if one is not passed in.
- An IBM Cloud Databases for MongoDB instance with KMS encryption.
- Autoscaling rules for the database instance, if provided.
- Service credential secrets and store them in secret manager.

![fscloud-mongodb](../../reference-architecture/deployable-architecture-mongodb.svg)

:exclamation: **Important:** This solution is not intended to be called by other modules because it contains a provider configuration and is not compatible with the `for_each`, `count`, and `depends_on` arguments. For more information, see [Providers Within Modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers).
