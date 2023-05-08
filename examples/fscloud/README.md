# Financial Services Cloud profile example

## *Note:* This example is only deploying MongoDB in a compliant manner the other infrastructure is not necessarily compliant.

### Requirements
This example expects you have Hyper Protect Crypto Service instances in the region you wish to deploy your MongoDB instance.

### Deploys
An example using the fscloud profile to deploy a compliant MongoDB instance. This example uses the IBM Cloud terraform provider to:

- Create a new resource group if one is not passed in.
- Create a Key protect instance and generate backup encryption key.
- Create an IAM Authorization between MongoDB instance resource group and Key Protect Instance for backup_encryption_key_crn as backup encryption key is not supported by Hyper Protect instances yet.
- Create an IAM Authorization between MongoDB instance Resource group and HPSC permanent Instance.
- Create a new ICD MongoDB instance and credentials that is encrypted using the Hyper Protect Crypto Service resources that are passed in.
- Create a Sample VPC.
- Create Context Based Restriction(CBR) to only allow MongoDB to be accessible from the VPC.
