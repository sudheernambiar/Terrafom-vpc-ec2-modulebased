# Terrafom-vpc-ec2-modulebased
#### creating a VPC (can be used for module based integration

## IMP This is the reference to Terraform-EC2-Creation-modulebased
### This script can either be used individually (need to create provider for AWS and terraform init), otherwise 

## Prerequisites
- Script is for AWS environment.
- An EC2 instance with role of admin. 
- Terraform installed.
- Installed with packages tree, git for verification and collection of data.
- cloned all contents in this repo to a single location.

## Files Explained

### Overview
This file contains all needed to create a VPC with 6 subnets (first 3 subnets in public and last 3 in private). NAT gateway is there to ensure outbound connectivity to internet for those machines in the private network. 

#### variable.tf
You can either use this to edit directly for a VPC deployment which has variables,
- cidr_block  - the private IP address range you can choose from say 172.30.0.0/16
- project     - name of the project
- level       - Level in which instance is running, development/testing/UAT/Production.
- owner       - Owner name/ID
- bits        - Bits you want to borrow for subnet creation (here 3 bits and we will get 8 subnets)

#### vpc.tf
By this we can create VPC, IGW, NAT-GW, 3 public subnet and 3 private subnets and associated route tables.

#### output.tf
By this those return types we can specify for the module based (refer https://github.com/sudheernambiar/Terraform-EC2-Creation-modulebased.git for more)

## Execution steps.
- terraform init (to initialise with the provider)
```
$ terraform init 
```
- To identify the procedure pre flight results
```
$ terraform plan 
```
- Execute the plan (with a yes you can permit after an overview, or explicitly work it with "terraform apply -auto-approve".
```
$ terraform apply 
```
- Incase to deploy without a pre flight check.
```
$ terraform apply -auto-approve 
```
Note: In case you want to make a clean-up use "terraform destroy"
```
$ terraform destroy
```
## Observations.
- First VPC, Private subnets, Route Tables, NAT GW and IGW will pop up.
- Route tables for private has no direct access via IGW to internet but via NAT GW
## Summary
An entire VPC with 6 subnets created to host 3 instances with different characteristics are born. A general purpose VPC is ready to use.
