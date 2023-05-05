# Complete example with Encryption and CBR rules

An end-to-end example that adds encryption to the [basic example](../basic/README.md). This example uses the IBM Cloud terraform provider to:

- Create a new resource group if one is not passed in.
- An ICD MongoDB database instance with autoscaling enabled (automatically increase resources).
- Create Key Protect instance with root key.
- Backend encryption using generated Key Protect key.
- Create a Sample VPC.
- Create Context Based Restriction(CBR) to only allow MongoDB to be accessible from the VPC.
