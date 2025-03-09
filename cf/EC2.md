# Cloudformation stack for an EC2 instance

This stack will deploy an EC2 instance.

## Prerequisites

The `vpc-full` and `keypair` CF stacks are pre-requisite for this stack.

## Deploy steps

Create a parameter file named `param.json`:
- Copy the template file: `cp ec2/params.json.template ec2/params.json`.
- Update the following parameters in the params.json file:
  - `SubnetIdParameter` - specify the subnetId of a **public** subnet
  - `SgIdParameter` - specify a security group ID that provied SSH access

Run

```Bash
./deploy-stack.sh ec2
```

## Connect to the EC2 instance

Get the IP address of the EC2 instance form the AWS console.

Assuming you saved the private key in an earlier step, run the following:

```Bash
ssh -i ~/.ssh/uni-keypair.pem ec2-user@IP-ADDRESS-HERE
```

## Undeploy steps

Run

```Bash
undeploy-stack.sh ec2
```
