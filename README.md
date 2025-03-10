# Cloud Infrastructure Course materials

## `/cli` - Command line examples

- `ec2` - Create an EC2 instance from the command line

## `/cf` - Cloudformation template examples

### VPC and EC2:

The recommended order to deploy/undeploy the CF stacks:

1. Deploy `keypair`
1. Deploy `vpc-full`
1. Deploy `ec2`
1. Undeploy `ec2`
1. Deploy `ec2-pub-priv`
1. Undeploy `ec2-pub-priv`
1. Undeploy `vpc-full`

### RDS

1. Deploy `vpc-full`
1. Deploy `rds`
1. Undeploy `rds`
1. Undeploy `vpc-full`

### Cleanup

1. Undeploy `keypair`
