terraform {
  required_version = ">= 1.3.0"
  # Add any required providers below and uncomment
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.49.0"
      # Use "greater than or equal to" range in modules
    }
  }
}
