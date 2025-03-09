# Create a key pair for SSH connections

## Deploy steps

Review the `keypair/params.json` file. Optionally, change the `KeyPairName` parameter to your liking.

Run the the following command:

```bash
./deploy-stack.sh keypair
```

## Retrieve and store the private key

The CF stack created a keypair. Run the following commands to retrieve and store the private key locally,
to be used for SSH connections later. Alternatively you can use the AWS console ("Parameter Store" service).

```Bash
# make sure there is a .ssh folder in the user's home and has the right permissions
mkdir -p ~/.ssh && chmod 700 ~/.ssh

# get the keypair name from the CF stack parameters
keypair_name=$(aws cloudformation describe-stacks \
--stack-name uni-keypair-stack \
--query 'Stacks[*].Parameters[?ParameterKey==`KeyPairName`].ParameterValue' \
--output text)

# get the keypair id from the CF stack outout
keypair_id=$(aws cloudformation describe-stacks \
--stack-name uni-keypair-stack \
--query 'Stacks[*].Outputs[?OutputKey==`KeyPairId`].OutputValue' \
--output text)

# print key name and value to verify
echo "${keypair_name} - ${keypair_id}"

# retrieve the private key from parameter store
aws ssm get-parameter \
--name "/ec2/keypair/${keypair_id}" \
--query 'Parameter.Value' \
--output text \
--with-decryption > ~/.ssh/"${keypair_name}.pem"

chmod 600 ~/.ssh/${keypair_name}.pem

ls -la ~/.ssh
```

## Undeploy steps

```Bash
./undeploy-stack.sh keypair
```