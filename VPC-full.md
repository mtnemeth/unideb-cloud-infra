# Cloudformation stack for a VPC

## Recap on VPC

VPC stands for virtual private cloud, and it is essentially your virtual network in the cloud where you can place your
cloud infrastructure. See the [AWS Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
for more details.

## About this stack

This stack deploys a "full" VPC with multiple private and public subnets, NAT gateway and internet gateway. Note, that
the NAT GW has extra cost, so remove this VPC by deleting the stack if no longer needed.


## Overview of VPC configuration

- VPC (CIDR: 10.2.0.0/16):
  - Internet Gateway
  - Public Subnet 1 (AZ1)
    - Public Route Table
    - NAT GW 1
  - Public Subnet 2 (AZ2)
    - Public Route Table
    - (NAT GW 2) - for cost saving, will use a single NAT GW only
  - Private Subnet 1 (AZ1)
    - Private Route Table 1
  - Private Subnet 2 (AZ2)
    - Private Route Table 2

## Deploy steps

Review the `vpc-full/params.json` file.
  - Change the `EnvironmentName` parameter to your liking.
  - Optionally, you may also change the CIDR blocks. But you can of course leave it as is.
Run the following command:

```Bash
./deploy-stack.sh vpc-full
```


## Undeploy steps

First, make sure you removed all resources you created in the VPC manually.

```Bash
./undeploy-stack.sh vpc-full
```