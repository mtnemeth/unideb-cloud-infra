# Create an EC2 instance using AWS CLI commands and connect with instance connect

## Gather VPC & subnet info

Open the AWS console and get the ID of both the VPC and a public subnet in it. They are are in the format of
`vpc-xxxxxxxx` and `subnet-xxxxxxxx` respectively.

Store them in environment variables for easy access moving forward. Replace the VPC and subnet ID placeholders in the commands below and execute them:

```Bash
VPC_ID=vpc-xxxxxx
```

```Bash
SUBNET_ID=subnet-xxxxxx
```

## Create a security group for SSH access

```Bash
SG_ID=$(aws ec2 create-security-group \
--group-name allow-ssh-sg \
--description "Security group for SSH access" \
--vpc-id "${VPC_ID}" \
--query "GroupId" --output text
)
```

```Bash
# check the security group id to make sure it got created successfully
echo "${SG_ID}"
```

```Bash
# add SSH rule
aws ec2 authorize-security-group-ingress \
--group-id "${SG_ID}" \
--protocol tcp \
--port 22 \
--cidr 0.0.0.0/0
```

Describe the security group

```Bash
aws ec2 describe-security-groups --group-id "${SG_ID}" | jq
```

## Create the EC2 instance

Run the following code:

```Bash
aws ec2 run-instances \
--image-id ami-05b10e08d247fb927 \
--count 1 \
--instance-type t3.micro \
--security-group-ids "${SG_ID}" \
--subnet-id "${SUBNET_ID}" \
--block-device-mappings "[{\"DeviceName\":\"/dev/sdf\",\"Ebs\":{\"VolumeSize\":20,\"DeleteOnTermination\":false}}]" \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=test}]' \
--associate-public-ip-address
```

You can use the up and down arrow keys to scroll through the output and hit `q` to exit.

## Describe the instances

Run the following command to get the instance ID and public IP address of running instances:

```Bash
aws ec2 describe-instances \
--filters 'Name=instance-state-name,Values="running"' \
--query 'Reservations[*].Instances[*].{Instance:InstanceId,PrivateIP:PrivateIpAddress,PublicIP:PublicIpAddress,Name:Tags[?Key==`Name`]|[0].Value}' \
--output table
```

Store the instance ID in an environment variable for future use. Copy the instance id from the output of the above
command and replace the `YOUR-INSTANCE-ID` placeholder with the acutal instance id in the command below:

```Bash
instance_id=YOUR-INSTANCE-ID
```

Describe the instance:

```Bash
aws ec2 describe-instances --instance-id "${instance_id}" | jq
```

## Connect to the instance

```Bash
aws ec2-instance-connect ssh --instance-id "${instance_id}"
```

Disconnect (by hitting CTRL+D).

## Terminate the instance

```Bash
aws ec2 terminate-instances --instance-id "${instance_id}"
```

## Delete the security group

```Bash
aws ec2 delete-security-group --group-id "${SG_ID}"
```
