# FS Cloud profile example

An example using the fscloud profile to deploy a compliant MongoDB instance:
- Create a new resource group if one is not passed in.
- Create a Sample VPC.
- Create Key Protect instance with root key.
- Create a new mongodb database instance.
- Backend encryption using generated Key Protect key.
- Create Context Based Restriction(CBR) to only allow MongoDB to be accessible from the VPC.
