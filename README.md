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

- [ Autoscale example](examples/autoscale)
- [ Complete example with Encryption and CBR rules](examples/complete)
- [ Default example](examples/default)
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
| <a name="module_cbr_rule"></a> [cbr\_rule](#module\_cbr\_rule) | git::https://github.com/terraform-ibm-modules/terraform-ibm-cbr//cbr-rule-module | v1.1.4 |

## Resources

| Name | Type |
|------|------|
| [ibm_database.mongodb](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/database) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowlist"></a> [allowlist](#input\_allowlist) | (Optional, List of Objects) A list of allowed IP addresses for the database. | <pre>list(object({<br>    address     = string<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_auto_scaling"></a> [auto\_scaling](#input\_auto\_scaling) | Configure rules to allow your database to automatically increase its resources. Single block of autoscaling is allowed at once. | <pre>object({<br>    cpu = object({<br>      rate_increase_percent       = optional(number)<br>      rate_limit_count_per_member = optional(number)<br>      rate_period_seconds         = optional(number)<br>      rate_units                  = optional(string)<br>    })<br>    disk = object({<br>      capacity_enabled             = optional(bool)<br>      free_space_less_than_percent = optional(number)<br>      io_above_percent             = optional(number)<br>      io_over_period               = optional(string)<br>      io_enabled                   = optional(bool)<br>      rate_increase_percent        = optional(number)<br>      rate_limit_mb_per_member     = optional(number)<br>      rate_period_seconds          = optional(number)<br>      rate_units                   = optional(string)<br>    })<br>    memory = object({<br>      io_above_percent         = optional(number)<br>      io_enabled               = optional(bool)<br>      io_over_period           = optional(string)<br>      rate_increase_percent    = optional(number)<br>      rate_limit_mb_per_member = optional(number)<br>      rate_period_seconds      = optional(number)<br>      rate_units               = optional(string)<br>    })<br>  })</pre> | <pre>{<br>  "cpu": {},<br>  "disk": {},<br>  "memory": {}<br>}</pre> | no |
| <a name="input_backup_encryption_key_crn"></a> [backup\_encryption\_key\_crn](#input\_backup\_encryption\_key\_crn) | (Optional) The CRN of a key protect key, that you want to use for encrypting disk that holds deployment backups. If null, will use 'key\_protect\_key\_crn' as encryption key. If 'key\_protect\_key\_crn' is also null database is encrypted by using randomly generated keys. | `string` | `null` | no |
| <a name="input_cbr_rules"></a> [cbr\_rules](#input\_cbr\_rules) | (Optional, list) List of CBR rules to create | <pre>list(object({<br>    description = string<br>    account_id  = string<br>    rule_contexts = list(object({<br>      attributes = optional(list(object({<br>        name  = string<br>        value = string<br>    }))) }))<br>    enforcement_mode = string<br>  }))</pre> | `[]` | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | Database Configuration in JSON format. | <pre>object({<br>    maxmemory                   = optional(number)<br>    maxmemory-policy            = optional(string)<br>    appendonly                  = optional(string)<br>    maxmemory-samples           = optional(number)<br>    stop-writes-on-bgsave-error = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_cpu_count"></a> [cpu\_count](#input\_cpu\_count) | Number of CPU cores available to the mongodb instance | `number` | `7` | no |
| <a name="input_disk_mb"></a> [disk\_mb](#input\_disk\_mb) | Disk available to the mongodb instance | `number` | `20480` | no |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | Endpoints available to the mongodb instance (public, private, public-and-private) | `string` | `"private"` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name of the MongoDB instance | `string` | n/a | yes |
| <a name="input_key_protect_key_crn"></a> [key\_protect\_key\_crn](#input\_key\_protect\_key\_crn) | (Optional) The root key CRN of a Key Management Service like Key Protect or Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption. If `null`, database is encrypted by using randomly generated keys. See https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok for current list of supported regions for BYOK | `string` | `null` | no |
| <a name="input_members"></a> [members](#input\_members) | Allocated number of members | `number` | `3` | no |
| <a name="input_memory_mb"></a> [memory\_mb](#input\_memory\_mb) | Memory available to the mongodb instance | `number` | `1024` | no |
| <a name="input_mongodb_version"></a> [mongodb\_version](#input\_mongodb\_version) | The version of the mongodb to be provisioned | `string` | `null` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The name of the service plan that you choose for your mongodb instance | `string` | `"standard"` | no |
| <a name="input_region"></a> [region](#input\_region) | The IBM Cloud region where instance will be created | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The ID of the IMB Cloud resource group where you want to create the instance | `string` | n/a | yes |
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
