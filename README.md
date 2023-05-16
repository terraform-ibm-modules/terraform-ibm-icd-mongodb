# IBM Cloud Databases for MongoDB module

[![Stable (With quality checks)](https://img.shields.io/badge/Status-Stable%20(With%20quality%20checks)-green)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![Build status](https://github.com/terraform-ibm-modules/terraform-ibm-icd-mongodb/actions/workflows/ci.yml/badge.svg)](https://github.com/terraform-ibm-modules/terraform-ibm-icd-mongodb/actions/workflows/ci.yml)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-icd-mongodb?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-icd-mongodb/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

## Usage
> WARNING: **This module does not support major version upgrade or updates to encryption and backup encryption keys**: To upgrade version create a new postgresql instance with the updated version and follow the [Upgrading to a new major version](https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-upgrading).

> NOTE: Currently the database encryption for backups supports only Key Protect keys, not Hyper Protect Crypto keys. If enabling KMS encryption and no value is passed for 'backup_encryption_key_crn', the value of 'kms_key_crn' is used. If this value is a HPCS key, the module will default the backup encryption to use randomly generated keys due to this current limitation. More info: https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs

```hcl
provider "ibm" {
  ibmcloud_api_key = "XXXXXXXXXX"
  region           = "us-south"
}

module "mongodb" {
    # replace "main" with a GIT release version to lock into a specific release
    source            = "git::https://github.com/terraform-ibm-modules/terraform-ibm-icd-mongodb?ref=main"
    resource_group_id = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"
    region            = "us-south"
    instance_name     = "my-mongodb-instance"
}
```

## Required IAM access policies

You need the following permissions to run this module.

- Account Management
    - **Databases for MongoDB** service
        - `Editor` role access

<!-- BEGIN EXAMPLES HOOK -->
## Examples

- [ Basic example](examples/basic)
- [ Complete example with encryption, autoscaling, and CBR rules](examples/complete)
- [ Financial Services Cloud profile example](examples/fscloud)
<!-- END EXAMPLES HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.49.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cbr_rule"></a> [cbr\_rule](#module\_cbr\_rule) | git::https://github.com/terraform-ibm-modules/terraform-ibm-cbr//cbr-rule-module | v1.2.0 |

## Resources

| Name | Type |
|------|------|
| [ibm_database.mongodb](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/database) | resource |
| [ibm_iam_authorization_policy.kms_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_authorization_policy) | resource |
| [ibm_resource_key.service_credentials](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_scaling"></a> [auto\_scaling](#input\_auto\_scaling) | Optional rules to allow the database to increase resources in response to usage. Only a single autoscaling block is allowed. Make sure you understand the effects of autoscaling, especially for production environments. See https://ibm.biz/autoscaling-considerations in the IBM Cloud Docs. | <pre>object({<br>    cpu = object({<br>      rate_increase_percent       = optional(number, 10)<br>      rate_limit_count_per_member = optional(number, 20)<br>      rate_period_seconds         = optional(number, 900)<br>      rate_units                  = optional(string, "count")<br>    })<br>    disk = object({<br>      capacity_enabled             = optional(bool, false)<br>      free_space_less_than_percent = optional(number, 10)<br>      io_above_percent             = optional(number, 90)<br>      io_enabled                   = optional(bool, false)<br>      io_over_period               = optional(string, "15m")<br>      rate_increase_percent        = optional(number, 10)<br>      rate_limit_mb_per_member     = optional(number, 3670016)<br>      rate_period_seconds          = optional(number, 900)<br>      rate_units                   = optional(string, "mb")<br>    })<br>    memory = object({<br>      io_above_percent         = optional(number, 90)<br>      io_enabled               = optional(bool, false)<br>      io_over_period           = optional(string, "15m")<br>      rate_increase_percent    = optional(number, 10)<br>      rate_limit_mb_per_member = optional(number, 114688)<br>      rate_period_seconds      = optional(number, 900)<br>      rate_units               = optional(string, "mb")<br>    })<br>  })</pre> | `null` | no |
| <a name="input_backup_encryption_key_crn"></a> [backup\_encryption\_key\_crn](#input\_backup\_encryption\_key\_crn) | The CRN of a Key Protect key, that you want to use for encrypting disk that holds deployment backups. Only used if var.kms\_encryption\_enabled is set to true. If no value passed, the value passed for the 'kms\_key\_crn' variable will be used. BYOK for backups is available only in US regions us-south and us-east, and eu-de. Only keys in the us-south and eu-de are durable to region failures. To ensure that your backups are available even if a region failure occurs, you must use a key from us-south or eu-de. Take note that Hyper Protect Crypto Services for IBM Cloud® Databases backups is not currently supported, so if no value is passed here, but a HPCS value is passed for var.kms\_key\_crn, databases backup encryption will use the default encryption keys. | `string` | `null` | no |
| <a name="input_cbr_rules"></a> [cbr\_rules](#input\_cbr\_rules) | (Optional, list) List of CBR rules to create | <pre>list(object({<br>    description = string<br>    account_id  = string<br>    rule_contexts = list(object({<br>      attributes = optional(list(object({<br>        name  = string<br>        value = string<br>    }))) }))<br>    enforcement_mode = string<br>  }))</pre> | `[]` | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | Database Configuration. | <pre>object({<br>    maxmemory                   = optional(number)<br>    maxmemory-policy            = optional(string)<br>    appendonly                  = optional(string)<br>    maxmemory-samples           = optional(number)<br>    stop-writes-on-bgsave-error = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_cpu_count"></a> [cpu\_count](#input\_cpu\_count) | Allocated dedicated CPU per-member. For shared CPU, set to 0. For more information refer to the docs https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member | `number` | `0` | no |
| <a name="input_disk_mb"></a> [disk\_mb](#input\_disk\_mb) | Allocated disk per-member. For more information refer to the docs https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member | `number` | `10240` | no |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | Specify whether you want to enable the public, private, or both service endpoints. Supported values are 'public', 'private', or 'public-and-private'. | `string` | `"private"` | no |
| <a name="input_existing_kms_instance_guid"></a> [existing\_kms\_instance\_guid](#input\_existing\_kms\_instance\_guid) | The GUID of the Hyper Protect or Key Protect instance in which the key specified in var.kms\_key\_crn and var.backup\_encryption\_key\_crn is coming from. Only required if var.kms\_encryption\_enabled is 'true', var.skip\_iam\_authorization\_policy is 'false', and passing a value for var.kms\_key\_crn and/or var.backup\_encryption\_key\_crn. | `string` | `null` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | The name to give the MongoDB instance. | `string` | n/a | yes |
| <a name="input_kms_encryption_enabled"></a> [kms\_encryption\_enabled](#input\_kms\_encryption\_enabled) | Set this to true to control the encryption keys used to encrypt the data that you store in IBM Cloud® Databases. If set to false, the data is encrypted by using randomly generated keys. For more info on Key Protect integration, see https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect. For more info on HPCS integration, see https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs | `bool` | `false` | no |
| <a name="input_kms_key_crn"></a> [kms\_key\_crn](#input\_kms\_key\_crn) | The root key CRN of a Key Management Services like Key Protect or Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption. Only used if var.kms\_encryption\_enabled is set to true. | `string` | `null` | no |
| <a name="input_members"></a> [members](#input\_members) | Allocated number of members | `number` | `3` | no |
| <a name="input_memory_mb"></a> [memory\_mb](#input\_memory\_mb) | Allocated memory per-member. For more information refer to the docs https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member | `number` | `1024` | no |
| <a name="input_mongodb_version"></a> [mongodb\_version](#input\_mongodb\_version) | The version of the MongoDB to provision. If no value passed, the current ICD preferred version is used. | `string` | `null` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The name of the service plan that you choose for your MongoDB instance | `string` | `"standard"` | no |
| <a name="input_plan_validation"></a> [plan\_validation](#input\_plan\_validation) | Enable or disable validating the database parameters for MongoDB during the plan phase. | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where you want to deploy your instance. | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The resource group ID where the MongoDB instance will be created. | `string` | n/a | yes |
| <a name="input_service_credential_names"></a> [service\_credential\_names](#input\_service\_credential\_names) | Map of name, role for service credentials that you want to create for the database | `map(string)` | `{}` | no |
| <a name="input_skip_iam_authorization_policy"></a> [skip\_iam\_authorization\_policy](#input\_skip\_iam\_authorization\_policy) | Set to true to skip the creation of an IAM authorization policy that permits all MongoDB database instances in the given resource group to read the encryption key from the Hyper Protect or Key Protect instance passed in var.existing\_kms\_instance\_guid. If set to 'false', a value must be passed for var.existing\_kms\_instance\_guid. No policy is created if var.kms\_encryption\_enabled is set to 'false'. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional list of tags to be added to the MongoDB instance and the associated service credentials (if creating). | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cbr_rule_ids"></a> [cbr\_rule\_ids](#output\_cbr\_rule\_ids) | CBR rule ids created to restrict Postgresql |
| <a name="output_crn"></a> [crn](#output\_crn) | Postgresql instance crn |
| <a name="output_guid"></a> [guid](#output\_guid) | mongodb instance guid |
| <a name="output_id"></a> [id](#output\_id) | mongodb instance id (CRN) |
| <a name="output_service_credentials_json"></a> [service\_credentials\_json](#output\_service\_credentials\_json) | Service credentials json map |
| <a name="output_service_credentials_object"></a> [service\_credentials\_object](#output\_service\_credentials\_object) | Service credentials object |
| <a name="output_version"></a> [version](#output\_version) | mongodb instance version |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGIN CONTRIBUTING HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
<!-- Source for this readme file: https://github.com/terraform-ibm-modules/common-dev-assets/tree/main/module-assets/ci/module-template-automation -->
<!-- END CONTRIBUTING HOOK -->
