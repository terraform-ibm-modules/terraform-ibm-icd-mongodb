# Complete example with encryption, autoscaling, and CBR rules

This end-to-end example uses the IBM Cloud terraform provider to:

- Create a new resource group if one is not passed in.
- An ICD MongoDB database instance with autoscaling enabled (automatically increase resources).
- Create Key Protect instance with root key.
- Backend encryption using generated Key Protect key.
- Create a Sample VPC.
- Create Context Based Restriction(CBR) to only allow MongoDB to be accessible from the VPC.
