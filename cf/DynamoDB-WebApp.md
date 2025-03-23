# DynamoDB with an example Web App

This stack deploys a DynamoDB table and an EC2 instance with a minimal Flask (Python) web app that
reads and writes key-vales to a DynamoDB table via boto3.

This app is for demo purposes only.

## Deploy stack

Make a copy of the parmater file template (`params.json.template`) and start adding your parameters.

```Bash
# copy template into actual parameter file
cp dynamo-web-app/params.json.template dynamo-web-app/params.json
```

Update the following parameters in `params.json`:
  - Update `PVpcId`, provide the id of your VPC.
  - Update the `PSubnetId` parameter with the id of a public subnet in your VPC.
  - Save the file.

In the `cf` folder, execute the following:

```Bash
./deploy-stack.sh dynamo-web-app
```

# Test the app

Go into the AWS console, find the public IP of the webserver and paste it into a browser.

## Undeploy the stack

In the `cf` folder, execute the following:

```Bash
./deploy-stack.sh dynamo-web-app
```
