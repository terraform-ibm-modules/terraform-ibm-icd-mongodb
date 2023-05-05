<!-- BEGIN MODULE HOOK -->
# Financial Services Cloud Profile

This is a profile for MongoDB that meets FS Cloud requirements.
It has been scanned by [IBM Code Risk Analyzer (CRA)](https://cloud.ibm.com/docs/code-risk-analyzer-cli-plugin?topic=code-risk-analyzer-cli-plugin-cra-cli-plugin#terraform-command) and meets all applicable goals with the following exception:
- 3000205: Check whether Databases for MongoDB network access is restricted to a specific IP range.
  - This is ignored because the CBR locks this down and CRA does not check this

## Note: If no Context Based Restriction(CBR) rules are not passed, you must configure Context Based Restrictions externally to be compliant.
<!-- END MODULE HOOK -->

<!-- BEGIN EXAMPLES HOOK -->
## Examples
- [ Financial Services Cloud profile example](../../examples/fscloud)
<!-- END EXAMPLES HOOK -->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mongodb"></a> [mongodb](#module\_mongodb) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_scaling"></a> [auto\_scaling](#input\_auto\_scaling) | Configure rules to allow your database to automatically increase its resources. Single block of autoscaling is allowed at once. | <pre>object({<br>    cpu = object({<br>      rate_increase_percent       = optional(number)<br>      rate_limit_count_per_member = optional(number)<br>      rate_period_seconds         = optional(number)<br>      rate_units                  = optional(string)<br>    })<br>    disk = object({<br>      capacity_enabled             = optional(bool)<br>      free_space_less_than_percent = optional(number)<br>      io_above_percent             = optional(number)<br>      io_over_period               = optional(string)<br>      io_enabled                   = optional(bool)<br>      rate_increase_percent        = optional(number)<br>      rate_limit_mb_per_member     = optional(number)<br>      rate_period_seconds          = optional(number)<br>      rate_units                   = optional(string)<br>    })<br>    memory = object({<br>      io_above_percent         = optional(number)<br>      io_enabled               = optional(bool)<br>      io_over_period           = optional(string)<br>      rate_increase_percent    = optional(number)<br>      rate_limit_mb_per_member = optional(number)<br>      rate_period_seconds      = optional(number)<br>      rate_units               = optional(string)<br>    })<br>  })</pre> | <pre>{<br>  "cpu": {},<br>  "disk": {},<br>  "memory": {}<br>}</pre> | no |
| <a name="input_backup_encryption_key_crn"></a> [backup\_encryption\_key\_crn](#input\_backup\_encryption\_key\_crn) | The CRN of a Key Protect Key to use for encrypting backups. Take note that Hyper Protect Crypto Services for IBM Cloud® Databases backups is not currently supported. | `string` | n/a | yes |
| <a name="input_cbr_rules"></a> [cbr\_rules](#input\_cbr\_rules) | (Optional, list) List of CBR rules to create | <pre>list(object({<br>    description = string<br>    account_id  = string<br>    rule_contexts = list(object({<br>      attributes = optional(list(object({<br>        name  = string<br>        value = string<br>    }))) }))<br>    enforcement_mode = string<br>  }))</pre> | `[]` | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | (Optional, Json String) Database Configuration in JSON format. | <pre>object({<br>    maxmemory                   = optional(number)<br>    maxmemory-policy            = optional(string)<br>    appendonly                  = optional(string)<br>    maxmemory-samples           = optional(number)<br>    stop-writes-on-bgsave-error = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_cpu_count"></a> [cpu\_count](#input\_cpu\_count) | Number of CPU cores available to the mongodb instance | `number` | `7` | no |
| <a name="input_disk_mb"></a> [disk\_mb](#input\_disk\_mb) | Disk space available to the mongodb instance | `number` | `20480` | no |
| <a name="input_existing_kms_instance_guid"></a> [existing\_kms\_instance\_guid](#input\_existing\_kms\_instance\_guid) | The GUID of the Hyper Protect Crypto service. | `string` | n/a | yes |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name of the mongodb instance | `string` | n/a | yes |
| <a name="input_kms_key_crn"></a> [kms\_key\_crn](#input\_kms\_key\_crn) | The root key CRN of a Hyper Protect Crypto Service (HPCS) that you want to use for disk encryption. See https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs&interface=ui for more information on integrating HPCS with mongodb instance. | `string` | n/a | yes |
| <a name="input_memory_mb"></a> [memory\_mb](#input\_memory\_mb) | Memory available to the mongodb instance | `number` | `1024` | no |
| <a name="input_mongodb_version"></a> [mongodb\_version](#input\_mongodb\_version) | The version of mongodb. If null, the current default ICD mongodb version is used. | `string` | `null` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The name of the service plan that you choose for your mongodb instance | `string` | `"standard"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region mongodb is to be created on. The region must support KYOK. | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The resource group ID where the mongodb will be created | `string` | n/a | yes |
| <a name="input_skip_iam_authorization_policy"></a> [skip\_iam\_authorization\_policy](#input\_skip\_iam\_authorization\_policy) | Set to true to skip the creation of an IAM authorization policy that permits all mongodb instances in the provided resource group reader access to the instance specified in the existing\_kms\_instance\_guid variable. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional list of tags to be applied to the mongodb instance. | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guid"></a> [guid](#output\_guid) | mongodb instance guid |
| <a name="output_id"></a> [id](#output\_id) | mongodb instance id |
| <a name="output_version"></a> [version](#output\_version) | mongodb instance version |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGIN CONTRIBUTING HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
<!-- Source for this readme file: https://github.com/terraform-ibm-modules/common-dev-assets/tree/main/module-assets/ci/module-template-automation -->
<!-- END CONTRIBUTING HOOK -->
