# IBM Cloud Databases for MongoDB module

[![Graduated (Supported)](https://img.shields.io/badge/Status-Graduated%20(Supported)-brightgreen)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-icd-mongodb?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-icd-mongodb/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

This module implements an instance of the IBM Cloud Databases for MongoDB service.

:exclamation: The module does not support major version upgrades or updates to encryption and backup encryption keys. To upgrade the version, create another instance of Databases for MongoDB with the updated version and follow the steps in [Upgrading to a new major version](https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-upgrading) in the IBM Cloud Docs.

:exclamation: The module only supports setting the disk encryption and backup encryption key CRNs on creation and no update support is available. The KMS manual or automatic key rotation may be used to change the key value and initiate the re-encryption of the deployment.

## Usage

IBM Cloud Databases supports:
- Key Protect encryption in `us-south`, `us-east`, and `eu-de` for backup encryption. For more information, see [Bring Your Own Key for Backups](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok) in the IBM Cloud Docs.
- Hyper Protect Crypto Services in all regions for backup encryption. For more information, see [Hyper Protect Crypto Services for Backup encryption](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs#use-hpcs-backups) in the IBM Cloud Docs.

If you enable key management encryption and no value is passed for 'backup_encryption_key_crn', the value of 'kms_key_crn' is used.

```hcl
provider "ibm" {
  ibmcloud_api_key = "XXXXXXXXXX"
  region           = "us-south"
}

module "mongodb" {
  source  = "terraform-ibm-modules/icd-mongodb/ibm"
  version = "latest" # Replace "latest" with a release version to lock into a specific release
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

- [ Restore from backup example](examples/backup-restore)
- [ Basic example](examples/basic)
- [ Complete example with BYOK encryption and CBR rules](examples/complete)
- [ Financial Services Cloud profile example with autoscaling enabled](examples/fscloud)
<!-- END EXAMPLES HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.70.0, < 2.0.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.1, < 1.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backup_key_crn_parser"></a> [backup\_key\_crn\_parser](#module\_backup\_key\_crn\_parser) | terraform-ibm-modules/common-utilities/ibm//modules/crn-parser | 1.1.0 |
| <a name="module_cbr_rule"></a> [cbr\_rule](#module\_cbr\_rule) | terraform-ibm-modules/cbr/ibm//modules/cbr-rule-module | 1.29.0 |
| <a name="module_kms_key_crn_parser"></a> [kms\_key\_crn\_parser](#module\_kms\_key\_crn\_parser) | terraform-ibm-modules/common-utilities/ibm//modules/crn-parser | 1.1.0 |

### Resources

| Name | Type |
|------|------|
| [ibm_database.mongodb](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/database) | resource |
| [ibm_iam_authorization_policy.backup_kms_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_authorization_policy) | resource |
| [ibm_iam_authorization_policy.kms_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_authorization_policy) | resource |
| [ibm_resource_key.service_credentials](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_key) | resource |
| [ibm_resource_tag.mongodb_tag](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_tag) | resource |
| [time_sleep.wait_for_authorization_policy](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_for_backup_kms_authorization_policy](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [ibm_database_connection.database_connection](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/database_connection) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tags"></a> [access\_tags](#input\_access\_tags) | A list of access tags to apply to the MongoDB instance created by the module, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial for more details | `list(string)` | `[]` | no |
| <a name="input_admin_pass"></a> [admin\_pass](#input\_admin\_pass) | The password for the database administrator. If the admin password is null then the admin user ID cannot be accessed. More users can be specified in a user block. | `string` | `null` | no |
| <a name="input_auto_scaling"></a> [auto\_scaling](#input\_auto\_scaling) | Optional rules to allow the database to increase resources in response to usage. Only a single autoscaling block is allowed. Make sure you understand the effects of autoscaling, especially for production environments. See https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-autoscaling&interface=cli#autoscaling-considerations in the IBM Cloud Docs. | <pre>object({<br/>    disk = object({<br/>      capacity_enabled             = optional(bool, false)<br/>      free_space_less_than_percent = optional(number, 10)<br/>      io_above_percent             = optional(number, 90)<br/>      io_enabled                   = optional(bool, false)<br/>      io_over_period               = optional(string, "15m")<br/>      rate_increase_percent        = optional(number, 10)<br/>      rate_limit_mb_per_member     = optional(number, 3670016)<br/>      rate_period_seconds          = optional(number, 900)<br/>      rate_units                   = optional(string, "mb")<br/>    })<br/>    memory = object({<br/>      io_above_percent         = optional(number, 90)<br/>      io_enabled               = optional(bool, false)<br/>      io_over_period           = optional(string, "15m")<br/>      rate_increase_percent    = optional(number, 10)<br/>      rate_limit_mb_per_member = optional(number, 114688)<br/>      rate_period_seconds      = optional(number, 900)<br/>      rate_units               = optional(string, "mb")<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_backup_crn"></a> [backup\_crn](#input\_backup\_crn) | The CRN of a backup resource to restore from. The backup is created by a database deployment with the same service ID. The backup is loaded after provisioning and the new deployment starts up that uses that data. A backup CRN is in the format crn:v1:<…>:backup:. If omitted, the database is provisioned empty. | `string` | `null` | no |
| <a name="input_backup_encryption_key_crn"></a> [backup\_encryption\_key\_crn](#input\_backup\_encryption\_key\_crn) | The CRN of a Key Protect or Hyper Protect Crypto Services encryption key that you want to use for encrypting the disk that holds deployment backups. Applies only if `use_ibm_owned_encryption_key` is false and `use_same_kms_key_for_backups` is false. If no value is passed, and `use_same_kms_key_for_backups` is true, the value of `kms_key_crn` is used. Alternatively set `use_default_backup_encryption_key` to true to use the IBM Cloud Databases default encryption. Bare in mind that backups encryption is only available in certain regions. See [Bring your own key for backups](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok) and [Using the HPCS Key for Backup encryption](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs#use-hpcs-backups). | `string` | `null` | no |
| <a name="input_cbr_rules"></a> [cbr\_rules](#input\_cbr\_rules) | (Optional, list) List of context-based restrictions rules to create. | <pre>list(object({<br/>    description = string<br/>    account_id  = string<br/>    rule_contexts = list(object({<br/>      attributes = optional(list(object({<br/>        name  = string<br/>        value = string<br/>    }))) }))<br/>    enforcement_mode = string<br/>    tags = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })))<br/>    operations = optional(list(object({<br/>      api_types = list(object({<br/>        api_type_id = string<br/>      }))<br/>    })))<br/>  }))</pre> | `[]` | no |
| <a name="input_cpu_count"></a> [cpu\_count](#input\_cpu\_count) | Allocated dedicated CPU per member. For shared CPU, set to 0. [Learn more](https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member) | `number` | `0` | no |
| <a name="input_disk_mb"></a> [disk\_mb](#input\_disk\_mb) | The disk that is allocated per member. [Learn more](https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member) | `number` | `10240` | no |
| <a name="input_kms_key_crn"></a> [kms\_key\_crn](#input\_kms\_key\_crn) | The CRN of a Key Protect or Hyper Protect Crypto Services encryption key to encrypt your data. Applies only if `use_ibm_owned_encryption_key` is false. By default this key is used for both deployment data and backups, but this behaviour can be altered using the `use_same_kms_key_for_backups` and `backup_encryption_key_crn` inputs. Bare in mind that backups encryption is only available in certain regions. See [Bring your own key for backups](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok) and [Using the HPCS Key for Backup encryption](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs#use-hpcs-backups). | `string` | `null` | no |
| <a name="input_member_host_flavor"></a> [member\_host\_flavor](#input\_member\_host\_flavor) | Allocated host flavor per member. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/database#host_flavor). | `string` | `null` | no |
| <a name="input_members"></a> [members](#input\_members) | The number of members that are allocated. [Learn more](https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-resources-scaling) | `number` | `3` | no |
| <a name="input_memory_mb"></a> [memory\_mb](#input\_memory\_mb) | Allocated memory per member. [Learn more](https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-pricing#mongodb-scale-member) | `number` | `4096` | no |
| <a name="input_mongodb_version"></a> [mongodb\_version](#input\_mongodb\_version) | The version of the MongoDB to provision. If no value passed, the current ICD preferred version is used. For our version policy, see https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-versioning-policy for more details | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to give the MongoDB instance. | `string` | n/a | yes |
| <a name="input_plan"></a> [plan](#input\_plan) | The name of the service plan that you choose for your MongoDB instance | `string` | `"standard"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where you want to deploy your instance. | `string` | `"us-south"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The resource group ID where the MongoDB instance will be created. | `string` | n/a | yes |
| <a name="input_service_credential_names"></a> [service\_credential\_names](#input\_service\_credential\_names) | Map of name, role for service credentials that you want to create for the database | `map(string)` | `{}` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | The type of endpoint of the database instance. Possible values: `public`, `private`, `public-and-private`. | `string` | `"public"` | no |
| <a name="input_skip_iam_authorization_policy"></a> [skip\_iam\_authorization\_policy](#input\_skip\_iam\_authorization\_policy) | Set to true to skip the creation of IAM authorization policies that permits all Databases for MongoDB instances in the given resource group 'Reader' access to the Key Protect or Hyper Protect Crypto Services key that was provided in the `kms_key_crn` and `backup_encryption_key_crn` inputs. This policy is required in order to enable KMS encryption, so only skip creation if there is one already present in your account. No policy is created if `use_ibm_owned_encryption_key` is true. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional list of tags to be added to the MongoDB instance. | `list(any)` | `[]` | no |
| <a name="input_use_default_backup_encryption_key"></a> [use\_default\_backup\_encryption\_key](#input\_use\_default\_backup\_encryption\_key) | When `use_ibm_owned_encryption_key` is set to false, backups will be encrypted with either the key specified in `kms_key_crn`, or in `backup_encryption_key_crn` if a value is passed. If you do not want to use your own key for backups encryption, you can set this to `true` to use the IBM Cloud Databases default encryption for backups. Alternatively set `use_ibm_owned_encryption_key` to true to use the default encryption for both backups and deployment data. | `bool` | `false` | no |
| <a name="input_use_ibm_owned_encryption_key"></a> [use\_ibm\_owned\_encryption\_key](#input\_use\_ibm\_owned\_encryption\_key) | IBM Cloud Databases will secure your deployment's data at rest automatically with an encryption key that IBM hold. Alternatively, you may select your own Key Management System instance and encryption key (Key Protect or Hyper Protect Crypto Services) by setting this to false. If setting to false, a value must be passed for the `kms_key_crn` input. | `bool` | `true` | no |
| <a name="input_use_same_kms_key_for_backups"></a> [use\_same\_kms\_key\_for\_backups](#input\_use\_same\_kms\_key\_for\_backups) | Set this to false if you wan't to use a different key that you own to encrypt backups. When set to false, a value is required for the `backup_encryption_key_crn` input. Alternatiely set `use_default_backup_encryption_key` to true to use the IBM Cloud Databases default encryption. Applies only if `use_ibm_owned_encryption_key` is false. Bare in mind that backups encryption is only available in certain regions. See [Bring your own key for backups](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-key-protect&interface=ui#key-byok) and [Using the HPCS Key for Backup encryption](https://cloud.ibm.com/docs/cloud-databases?topic=cloud-databases-hpcs#use-hpcs-backups). | `bool` | `true` | no |
| <a name="input_users"></a> [users](#input\_users) | A list of users that you want to create on the database. Multiple blocks are allowed. The user password must be in the range of 10-32 characters. Be warned that in most case using IAM service credentials (via the var.service\_credential\_names) is sufficient to control access to the MongoDB instance. This blocks creates native MongoDB database users, more info on that can be found here https://cloud.ibm.com/docs/databases-for-mongodb?topic=databases-for-mongodb-user-management&interface=ui | <pre>list(object({<br/>    name     = string<br/>    password = string # pragma: allowlist secret<br/>    type     = optional(string)<br/>    role     = optional(string)<br/>  }))</pre> | `[]` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_adminuser"></a> [adminuser](#output\_adminuser) | Database admin user name |
| <a name="output_cbr_rule_ids"></a> [cbr\_rule\_ids](#output\_cbr\_rule\_ids) | CBR rule ids created to restrict MongoDB |
| <a name="output_certificate_base64"></a> [certificate\_base64](#output\_certificate\_base64) | Database connection certificate |
| <a name="output_crn"></a> [crn](#output\_crn) | MongoDB instance crn |
| <a name="output_guid"></a> [guid](#output\_guid) | MongoDB instance guid |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | Database connection hostname |
| <a name="output_id"></a> [id](#output\_id) | MongoDB instance ID |
| <a name="output_port"></a> [port](#output\_port) | Database connection port |
| <a name="output_service_credentials_json"></a> [service\_credentials\_json](#output\_service\_credentials\_json) | Service credentials json map |
| <a name="output_service_credentials_object"></a> [service\_credentials\_object](#output\_service\_credentials\_object) | Service credentials object |
| <a name="output_version"></a> [version](#output\_version) | MongoDB instance version |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGIN CONTRIBUTING HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
<!-- Source for this readme file: https://github.com/terraform-ibm-modules/common-dev-assets/tree/main/module-assets/ci/module-template-automation -->
<!-- END CONTRIBUTING HOOK -->
