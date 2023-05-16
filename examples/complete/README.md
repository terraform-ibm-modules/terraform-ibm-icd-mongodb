# Complete example with encryption, autoscaling, and CBR rules

This end-to-end example uses the IBM Cloud terraform provider to:

- Create a new resource group if one is not passed in.
- Create Key Protect instance with root key.
- Create a new ICD MongoDB database instance with auto-scaling and BYOK encryption enabled.
- Create service credentials for the database instance.
- Create a Virtual Private Cloud (VPC).
- Create Context Based Restriction (CBR) to only allow MongoDB to be accessible from the VPC.
