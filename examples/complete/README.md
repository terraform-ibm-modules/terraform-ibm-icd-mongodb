# Complete example with Encryption and CBR rules

An end-to-end example that adds encryption to the [default example](../default/README.md). This example uses the IBM Cloud terraform provider to:

- Create a new resource group if one is not passed in.
- Create a new mongoDB database instance.
- Create Key Protect instance with root key.
- Backend encryption using generated Key Protect key.
- Create a Sample VPC.
- Create Context Based Restriction(CBR) to only allow MongoDB to be accessible from the VPC.
