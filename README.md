<!-- BEGIN MODULE HOOK -->

<!-- Update the title to match the module name and add a description -->
# IBM Cloud Databases for ICD MongoDB module
<!-- UPDATE BADGE: Update the link for the following badge-->
[![Stable (With quality checks)](https://img.shields.io/badge/Status-Stable%20(With%20quality%20checks)-green)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![Build status](https://github.com/terraform-ibm-modules/terraform-ibm-icd-mongodb/actions/workflows/ci.yml/badge.svg)](https://github.com/terraform-ibm-modules/terraform-ibm-icd-mongodb/actions/workflows/ci.yml)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-icd-mongodb?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-icd-mongodb/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

<!-- Remove the content in this H2 heading after completing the steps -->

## Usage

:exclamation: **Important:** This module does not support major version upgrades or updates to encryption and backup encryption keys. To upgrade the version, create a new MongoDB instance with the updated version, and follow the steps in [Upgrading to a new major version](https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-upgrading) in the IBM Cloud docs.

```terraform
module "mongodb" {
    # replace "main" with a GIT release version to lock into a specific release
    source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-icd-mongodb?ref=main"
    resource_group_id = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"
    region = "us-south"
    instance_name = "my-mongodb-instance"
}

```

## Required IAM access policies

You need the following permissions to run this module.

- Account Management
    - **Databases for MongoDB** service
        - `Editor` role access

<!-- END MODULE HOOK -->
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowlist"></a> [allowlist](#input\_allowlist) | (Optional, List of Objects) A list of allowed IP addresses for the database. | <pre>list(object({<br>    address     = string<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_auto_scaling"></a> [auto\_scaling](#input\_auto\_scaling) | Optional rules to allow the database to increase resources in response to usage. Only a single autoscaling block is allowed. Make sure you understand the effects of autoscaling, especially for production environments. See https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-autoscaling&interface=cli#autoscaling-considerations in the IBM Cloud Docs. | <pre>object({<br>    cpu = object({<br>      rate_increase_percent       = optional(number, 10)<br>      rate_limit_count_per_member = optional(number, 20)<br>      rate_period_seconds         = optional(number, 900)<br>      rate_units                  = optional(string, "count")<br>    })<br>    disk = object({<br>      capacity_enabled             = optional(bool, false)<br>      free_space_less_than_percent = optional(number, 10)<br>      io_above_percent             = optional(number, 90)<br>      io_enabled                   = optional(bool, false)<br>      io_over_period               = optional(string, "15m")<br>      rate_increase_percent        = optional(number, 10)<br>      rate_limit_mb_per_member     = optional(number, 3670016)<br>      rate_period_seconds          = optional(number, 900)<br>      rate_units                   = optional(string, "mb")<br>    })<br>    memory = object({<br>      io_above_percent         = optional(number, 90)<br>      io_enabled               = optional(bool, false)<br>      io_over_period           = optional(string, "15m")<br>      rate_increase_percent    = optional(number, 10)<br>      rate_limit_mb_per_member = optional(number, 114688)<br>      rate_period_seconds      = optional(number, 900)<br>      rate_units               = optional(string, "mb")<br>    })<br>  })</pre> | `null` | no |
| <a name="input_backup_encryption_key_crn"></a> [backup\_encryption\_key\_crn](#input\_backup\_encryption\_key\_crn) | (Optional) The CRN of a Key Protect Key to use for encrypting backups. If left null, the value passed for the 'kms\_key\_crn' variable will be used. Take note that Hyper Protect Crypto Services for IBM Cloud® Databases backups is not currently supported. | `string` | `null` | no |
| <a name="input_cbr_rules"></a> [cbr\_rules](#input\_cbr\_rules) | (Optional, list) List of CBR rules to create | <pre>list(object({<br>    description = string<br>    account_id  = string<br>    rule_contexts = list(object({<br>      attributes = optional(list(object({<br>        name  = string<br>        value = string<br>    }))) }))<br>    enforcement_mode = string<br>  }))</pre> | `[]` | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | Database Configuration in JSON format. | <pre>object({<br>    maxmemory                   = optional(number)<br>    maxmemory-policy            = optional(string)<br>    appendonly                  = optional(string)<br>    maxmemory-samples           = optional(number)<br>    stop-writes-on-bgsave-error = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_cpu_count"></a> [cpu\_count](#input\_cpu\_count) | The number of CPU cores available to the database instance. For more information refer to the docs https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member | `number` | `7` | no |
| <a name="input_disk_mb"></a> [disk\_mb](#input\_disk\_mb) | Disk space available to the database instance. For more information refer to the docs https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member | `number` | `20480` | no |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | Endpoints available to the mongodb instance (public, private, public-and-private) | `string` | `"private"` | no |
| <a name="input_existing_kms_instance_guid"></a> [existing\_kms\_instance\_guid](#input\_existing\_kms\_instance\_guid) | The GUID of the Hyper Protect or Key Protect instance in which the key specified in var.kms\_key\_crn is coming from. Only required if skip\_iam\_authorization\_policy is false | `string` | `null` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name of the MongoDB instance | `string` | n/a | yes |
| <a name="input_kms_key_crn"></a> [kms\_key\_crn](#input\_kms\_key\_crn) | (Optional) The root key CRN of a Key Management Service like Key Protect or Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption. If `null`, database is encrypted by using randomly generated keys. See https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok for current list of supported regions for BYOK | `string` | `null` | no |
| <a name="input_members"></a> [members](#input\_members) | Allocated number of members | `number` | `3` | no |
| <a name="input_memory_mb"></a> [memory\_mb](#input\_memory\_mb) | Memory available to the database instance in MB. For more information refer to the docs https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member | `number` | `1024` | no |
| <a name="input_mongodb_version"></a> [mongodb\_version](#input\_mongodb\_version) | The version of the mongodb to be provisioned | `string` | `null` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The name of the service plan that you choose for your mongodb instance | `string` | `"standard"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region MongoDB is to be created on. The region must support BYOK region if Key Protect Key is used or KYOK region if Hyper Protect Crypto Service (HPCS) is used. | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The ID of the IMB Cloud resource group where you want to create the instance | `string` | n/a | yes |
| <a name="input_skip_iam_authorization_policy"></a> [skip\_iam\_authorization\_policy](#input\_skip\_iam\_authorization\_policy) | Set to true to skip the creation of an IAM authorization policy that permits all MongoDB instances in the given Resource group to read the encryption key from the Hyper Protect or Key Protect instance in `existing_kms_instance_guid`. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags that you want to add to your instance | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guid"></a> [guid](#output\_guid) | mongodb instance guid |
| <a name="output_id"></a> [id](#output\_id) | mongodb instance id (CRN) |
| <a name="output_version"></a> [version](#output\_version) | mongodb instance version |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGIN CONTRIBUTING HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
<!-- Source for this readme file: https://github.com/terraform-ibm-modules/common-dev-assets/tree/main/module-assets/ci/module-template-automation -->
<!-- END CONTRIBUTING HOOK -->
