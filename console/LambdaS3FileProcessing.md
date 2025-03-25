# Lambda function to process newly uploaded files in S3

This exercise creates an S3 bucket and a Lambda function. The Lambda function is triggered by
Event Bridge notificiations when new files are uploaded to the bucket. The event contains
details about the file, such as bucket name and key. The lambda function reads the original
file and creates a processed version of it. In this example, adds a line at the beginning
of the file.

- Files are uplodaded to `s3://YOURBUCKET/in`
- Processed files are written into `s3://YOURBUCKET/processed`

## Create a bucket

- In the AWS console, go to the `S3` service.
- Click `Create bucket`
- Select `General Purpose`
- Name your bucket. Remember, bucket names must be globally unique.
- Leave `ACLs disabled (recommended)` selected as default.
- Leave `Block all public access` selected as default.
- Leave `Bucket Versioning` at `Disable` as default.
- Leave `Default encryption` at `SSE-S3` as default.
- Leave `Bucket key` at `Enable` as default.
- Click `Create bucket`.
- View the details of your new bucket.
- Go to the `Properties` tab.
- Scroll down to `Amazon EventBridge`, select `Edit`, select `On`, then `Save changes`.

## Create the Lambda function

- Go to the `Lambda` service.
- Click `Create fuction`.
- Select `Author from scratch`.
- Enter a name for the function in the `Function name`, for example: `UniS3FileProcessLambda`.
- For `Runtime`, select `Python 3.13`.
- For `Architecture`, leave it on default `x86_64`.
- Lambda Execution role. Under `Change default execution role`:
  - If you don't have IAM permissions on the account:
    - select `Use an existing role`
    - select `UniRoles/UniLambdaRole`
  - If you have IAM permissions on the account:
    - select `Create a new role with basic Lambda permissions`.
- Leave `Additional Configurations` default.
- Hit the `Create function` button.

## Update Lambda execution role permissions

This step is applicable only if you have IAM permissions on the account and created a new role in the previous step.
(Selected `Create a new role with basic Lambda permissions`)

The default Lambda permission created in the previous step allows the Lambda function to write to CloudWatch Logs.
But we also want the function to read from and write to the bucket we just created. To achivee that,
we need to update the Lambda function execution role.

- On the `Configuration` tab of the lambda function, select `Permissions` on the left.
- Under `Execution Role`, there is a `Role name` section, click on the role name URL.
  This will open the lambda execution role in a new window.
- In `Permission policies`, click `Add permissions`, then `Create inline policy`.
- Toggle from `Visual` to `JSON` at the top.
  Add the conent of the attached [policy file](./lambda-s3-file-processing/lambda-execution-role-s3-policy.json),
  but make sure to replace `YOURBUCKET` with your actual bucket name.
- Click `Next`, then enter `S3Access` for the policy name, then click `Create poloicy`.

## Add code for the function

- Go back to the `Lambda` service and open your function. Select `lambda_function.py`.
Enter code from [lambda_function.py](./lambda-s3-file-processing/lambda_function.py)
- Click `Deploy`

## Configure Trigger for the lambda function

- On the `Function overview` panel, click `Add trigger`
- Select `EventBridge (CloudWatch Events)`
- Select `Create new rule`, enter `S3UniRule` for `Rule name`.
- Select `Event Pattern`
- Select `Simple Storage Service (S3)`
- Select `All Events`
- Click add.
- On the Lambda page in the `Configuration` tab, select `Triggers` on the left, then click on the `S3UniRule` link.
- On the `Event pattern` tab, click `Edit`, select `Edit pattern`, select `Custom pattern`.
- Enter the event pattern from the [event_pattern.json](./lambda-s3-file-processing/event_pattern.json) file,
  but make sure to replace `YOURBUCKET` with your actual bucket name.
- Click `next` a few times, then `Update rule`.

## Upload a test file

In a CloudShell window, create a test file:

```Bash
echo 'Hello World!' > /tmp/test.txt
```

Store your bucket name into an env variable, make sure to replace `YOURBUCKET` with your actual bucket name:

```Bash
bucket='YOURBUCKET'
```

Then upload the file to your bucket, under the `/in` prefix:

```Bash
aws s3 cp /tmp/test.txt s3://${bucket}/in/
```

Let's see if the processed file got created:

```Bash
aws s3 ls s3://${bucket}/processed/
```

If there is a processed file, check it out:

```Bash
aws s3 cp s3://${bucket}/processed/test.txt -
```

## Delete the function

In the AWS Console, under the Lambda service, open your function.
Select `Actions`, then `Delete function`.
