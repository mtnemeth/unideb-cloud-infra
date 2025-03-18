# Cloudformation stack for an RDS

This CloudFormation stack deploys a MySQL compatbile Aurora RDS. An RDS is deployed into a VPC, and we deploy it
into the private subnets, making the database (directly) unreachable from outside of the VPC. This is standard
best practice.

## Deploy steps

### Create a master password

We need a master (admin/root) password for the RDS. Create one and store it in AWS parameter store, so we don't need to
manage it in files or pass it in as parameter to the Cloudformation template. Run the following code to set the
password. Use a password that is at least 8 characters long.

```Bash
rds_master_pass='ENTER-PASSWORD-HERE'
```

```Bash
aws ssm put-parameter \
--name "/rds/uni-rds/masterpass" \
--value "${rds_master_pass}" \
--type SecureString
```

Verify the password from the AWS Console. Go to `AWS Systems Manager` > `Parameter Store`, locate and retrieve the
secret. Alternatively, you can use the following command:

```Bash
aws ssm get-parameter \
--name "/rds/uni-rds/masterpass" \
--with-decryption
```

### Get the VPC id and the list of private subnets you want to deploy the RDS to

In case you used the CloudFormation stack in the `vpc` folder to deploy your VPC, you can do this by querying
the output values of the CF stack, running the following commands. In case you created the VPC manually, you will need
to get this info (VPC & subnet IDs of your private subnets) from the AWS console.

```Bash
aws cloudformation describe-stacks \
--stack-name uni-vpc-full-stack \
--query 'Stacks[*].Outputs[?OutputKey==`VPC`].OutputValue' --output text
```

```Bash
aws cloudformation describe-stacks \
--stack-name uni-vpc-full-stack \
--query 'Stacks[*].Outputs[?OutputKey==`PrivateSubnets`].OutputValue' --output text
```

### Edit parameters file

Make a copy of the parmater file template (`params.json.template`) and start adding your parameters.

```Bash
# copy template into actual parameter file
cp rds/params.json.template rds/params.json
```

Update the following parameters in `params.json`:
  - Update `RDSVPCParameter`, provide the VPC id you retrieved in the previous step.
  - Update the `DBSubnetIdsParameter` parameter value with the list of private subnets retrieved in the previous step.
  Enter a comma separated list of private subnet IDs.
  - Save the file.

> Note: You can use `nano` as a text editor. Run `nano rds/params.json`. Edit the parameters, hit `CTRL-X` to exit,
`Y` to save, and `Enter` to keep the original file name when prompted.

### Deploy the CF stack

```Bash
./deploy-stack.sh rds
```

You can monitor the progress of the CF stack creation in the AWS Console. Select the `Cloudformation` service. Click
on `Stacks`, then select the appropriate stack, then go to the `Events` tab.

## Connect to the RDS

Since the RDS sits in a private subnet, we need an EC2 instance inside the VPC to connect to the RDS. Furthermore,
we need to add the RDS security group to the EC2 instance to allow the MySQL port for connections.

Get the RDS endpoint. Either find it on the AWS Console, or run the following command:

```Bash
aws rds describe-db-clusters \
--query 'DBClusters[?DBClusterIdentifier==`uni-rds-00-cluster`].Endpoint' --output text
```

Connect to the EC2 instance using SSH. See details in [EC2.md](./EC2.md).

Once connected to the EC2 instance, install command line tools to connect to MySQL by running the following commands:

```Bash
sudo dnf install -y mariadb105
```

Set an environment variable to the RDS endpoint.

```Bash
DB_CLUSTER_ENDPOINT=YOUR-DB-CLUSTER-ENDPOINT.us-east-1.rds.amazonaws.com
```

Connect to the RDS.

```Bash
mysql -h "${DB_CLUSTER_ENDPOINT}" -u admin -p
```

You will need to specify the password you set in previous steps. If you need to, you can get it from the parameter
store. See previous sections for details.

Once connected to the RDS, look around:

```SQL
show databases;
```

You should get something like this:

```
MySQL [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| uni                |
+--------------------+
5 rows in set (0.002 sec)
```

Create a table and insert some dummy records:

```
MySQL [(none)]> use uni;
Database changed

MySQL [uni]> create table test(id INTEGER, a TEXT(100));
Query OK, 0 rows affected (0.026 sec)

MySQL [uni]> insert into test VALUES(1, 'a');
Query OK, 1 row affected (0.014 sec)

MySQL [uni]> insert into test VALUES(2, 'b');
Query OK, 1 row affected (0.003 sec)

MySQL [uni]> select * from test;
+------+------+
| id   | a    |
+------+------+
|    1 | a    |
|    2 | b    |
+------+------+
2 rows in set (0.001 sec)
```

## Undeploy steps

Make sure you either detached the security group from the EC2 instance, or terminated the instance before deleting
the stack.

```Bash
./undeploy-stack.sh rds
```
