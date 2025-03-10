# Cloudformation stack for two EC2 instances

This stack will deploy two EC2 instances. One into a public, another into a private subnet.

## Pre-requisite

The `vpc-full` and `keypair` CF stacks are pre-requisite for this stack.

## Deploy steps

Create a parameter file named `params.json`:
- Copy the template file:
   ```Bash
   cp ec2-pub-priv/params.json.template ec2-pub-priv/params.json
   ```
- Update the following parameters in the `params.json` file:
  - `PubSubnetIdParameter` - specify the subnetId of a **public** subnet
  - `PrivSubnetIdParameter` - specify the subnetId of a **private** subnet
  - `SgIdParameter` - specify a security group ID that allows SSH access

You can use the `nano` text editor for the task. Execute:

```Bash
nano ec2-pub-priv/params.json
```

To exit, use `CTRL-X`, press `Y` or `N` to save or not save, hit Enter to leave filename unchanged when prompted.

Run

```Bash
./deploy-stack.sh ec2-pub-priv
```

## Connect to the EC2 instance via SSH

> Note: there is a better / more secure way to connect to EC2 instances by using AWS session manager, but that's
a topic for a later session.

### Option 1 - agent forwarding

Run the following

```Bash
# start SSH agent so we don't need to copy the private key over
eval $(ssh-agent)
```

```Bash
# add private key
ssh-add ~/.ssh/YOUR-PRIV-KEY.pem
```

```Bash
# connect to the 1st instance in the public subnet
ssh -i ~/.ssh/YOUR-PRIV-KEY.pem -A ec2-user@PUBLIC-INSTANCE-IP-ADDRESS-HERE
```

You are now connected to the instance in the public subnet. Get the private IP address of the EC2 instance
deployed in the private subnet, and run the following:

```Bash
ssh ec2-ser@PRIVATE-INSTANCE-PRIV-IP-ADDRESS-HERE
```

### Option 2 - Proxy jump from command line

```Bash
ssh -o ProxyCommand="ssh -i ~/.ssh/uni-keypair.pem -vvv -W '[%h]:%p' ec2-user@PUBLIC-EC2-PUBLIC-IP" \
-i ~/.ssh/uni-keypair.pem ec2-user@PRIVATE-EC2-PRIVATE-IP
```

### Option 3 - Proxy jump with SSH config

Create the file `~/.ssh/config` with the following content:

```
HOST public-ec2
   hostname PUBLIC-EC2-PUBLIC-IP
   user ec2-user
   IdentityFile ~/.ssh/uni-keypair.pem

HOST private-ec2
   hostname PRIVATE-EC2-PRIVATE-IP
   user ec2-user
   IdentityFile ~/.ssh/uni-keypair.pem
   ProxyJump public-ec2
```

Run the following command:

```Bash
ssh private-ec2
```


## Undeploy steps

Run

```Bash
./undeploy-stack.sh ec2-pub-priv
```
