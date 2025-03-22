# DynamoDB with an example Web App

This stack deploys a DynamoDB table and an EC2 instance with a minimal Flask (Python) web app that accesses the DynamoDB table via boto3.
This is for demo purposes only.

## Deploy stack

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
