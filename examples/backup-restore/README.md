# Restore from backup example

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<p>
  <a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=icd-mongodb-backup-restore-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-icd-mongodb/tree/main/examples/backup-restore">
    <img src="https://img.shields.io/badge/Deploy%20with%20IBM%20Cloud%20Schematics-0f62fe?style=flat&logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics">
  </a><br>
  ℹ️ Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab.
</p>
<!-- END SCHEMATICS DEPLOY HOOK -->

This example provides an end-to-end executable flow of how a MongoDB instance can be restored from a backup. It supports both classic and Gen2 plans. This example uses the IBM Cloud Terraform provider to:

- Create a new resource group if one is not passed in.
- Create a restored ICD MongoDB instance pointing to the latest backup of the existing MongoDB instance CRN passed.

To restore a **classic** instance, use a classic plan (e.g. `standard` or `enterprise`). The `member_host_flavor` is automatically set to `multitenant`.

To restore a **Gen2** instance, set `plan` to a Gen2 plan (e.g. `standard-gen2` or `enterprise-gen2`). The `member_host_flavor` is automatically set to a dedicated host type (`bx3d.4x20`). The source backup CRN must also originate from a Gen2 instance.
