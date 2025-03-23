# Cloud Infrastructure Course materials

## `/cli` - Command line examples

- [ec2-ic.md](cli/ec2-ic.md) - Create an EC2 instance using AWS CLI commands and connect with instance connect.
- [dynamodb.md](cli/dynamodb.md) - Create a DynamoDB table, insert a few items and query the table from the CLI.

## `/cf` - Cloudformation template examples

### VPC and EC2:

The recommended order to deploy/undeploy the CF stacks:

1. Deploy `keypair` - [KeyPair.md](cf/KeyPair.md)
1. Deploy `vpc-full` - [VPC-full.md](cf/VPC-full.md)
1. Deploy `ec2` - [EC2.md](cf/EC2.md)
1. Undeploy `ec2` - [EC2.md](cf/EC2.md)
1. Deploy `ec2-pub-priv` - [EC2-pub-priv.md](cf/EC2-pub-priv.md)
1. Undeploy `ec2-pub-priv` - [EC2-pub-priv.md](cf/EC2-pub-priv.md)
1. Undeploy `vpc-full` - [VPC-full.md](cf/VPC-full.md)

### RDS

1. Deploy `vpc-full` - [VPC-full.md](cf/VPC-full.md)
1. Deploy `rds` - [RDS.md](cf/RDS.md)
1. Undeploy `rds` - [RDS.md](cf/RDS.md)
1. Undeploy `vpc-full` - [VPC-full.md](cf/VPC-full.md)

### DyanmoDB + EC2 web app examle

1. `dynamo-web-app` - [DynamoDB-WebApp.md](cf/DynamoDB-WebApp.md)

### Cleanup

1. Undeploy `keypair` - [KeyPair.md](cf/KeyPair.md)

## `/console` - Examples using the AWS Console

- [LambdaHelloWorld.md](console/LambdaHelloWorld.md) - Lambda Hello World.
- [LambdaS3FileProcessing.md](console/LambdaS3FileProcessing.md) - Lambda to process files on S3.
