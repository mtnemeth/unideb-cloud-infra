# Hello Wold in AWS Lambda

## Create a function

- Log in to the AWS console. Open `Lambda` service.
- Click the `Create function` button in the top right.
- Select `Author from scratch`.
- Enter a name for `Function name`, for example: `MyTestFunc`.
- For `Runtime`, select `Python 3.13`.
- For `Architecture`, leave it on default `x86_64`.
- Under `Change default execution role`, select `Create a new role with basic Lambda permissions`.
- Leave `Additional Configurations` default.
- Hit the `Create function` button.

## Add code for the function

In the code editor (on the `Code` tab of the lambda function). Enter the following code:

```Python
def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'body': f'Hello {event["Name"]}!'
    }
```

Hit the `Deploy` button on the left of the code.

## Test the function with test events

- Go to the `Test` tab.
- Select `Create new event`.
- Name your event in the `Event name` field. For example: `MyTestEvent`.
- Select `Private` for `Event Sharing settings`.
- For `Event JSON`, enter the following:
  ```JSON
  {"Name": "YourName"}
  ```
- Hit `Save`
- Hit `Test`
- You should see a green `Executing function: succeeded` message on the top of the tab.
- Open `details`.
- You should see the following result:
  ```JSON
  {
    "statusCode": 200,
    "body": "Hello YourName!"
  }
  ```

## Let's call the function from the CLI

In a CloudShell window, execute the following code. Remember to adjust the command if you named your function differently.

```Bash
aws lambda invoke \
--function-name MyTestFunc \
--cli-binary-format raw-in-base64-out \
--payload '{"Name": "Your Name"}' \
/tmp/response.json
```

You should see the following output:

```
{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
```

Now, look at the response json, by running:

```Bash
cat /tmp/response.json
```

You should see the following result:

```JSON
{"statusCode": 200, "body": "Hello Your Name!"}
```

## Update the function code and add a function URL

Go back to the code tab and update the function code with the following:

```Python
import json

def lambda_handler(event, context):
    return f'Hello {event["queryStringParameters"]["Name"]}!'
```

Make sure to click on the `Deploy` button.

Add a function URL:
- Go to the `Configuration` tab.
- Select `Function URL` on the left hand side.
- Click `Create function URL`.
- For auth type, chose `NONE`.
- Click `Save` at the bottom.

In the Console, in the `Function overview` panel, copy the `Function URL` to clipboard and paste it into a browser.

Append the following string to the end of the URL in order to specify the input parameters for the function:
`?Name=YourName`.

You should receive the following result in the browser:

```
Hello YourName!
```

## Optional - check the logs

- Go to the `CloudWatch` service in the console.
- Under `Log groups`, search for your function name, for example: `MyTestFunc`.
- You should see a log group named `/aws/lambda/MyTestFunc`. Click on it.
- Click on any of the log streams to see the log messages.

## Delete the function

In the AWS Console, under the Lambda service, open your function.
Select `Actions`, then `Delete function` on the `Function overview` panel.
