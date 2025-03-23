import boto3
from botocore.exceptions import ClientError

class DynamoDbException(Exception):
    pass

class DynamoDb:
    DYNAMODB_TABLE = 'dynamo-project-table'

    def __init__(self, dyn_client=boto3.client('dynamodb')):
        self.dyn_client = dyn_client

    def put_key(self, key, value):
        try:
            self.dyn_client.put_item(
                TableName=self.DYNAMODB_TABLE,
                Item={
                    "Key": {"S": key},
                    'Value': {'S': value}
                }
            )
        except ClientError as err:
            raise DynamoDbException(
                f'Could not update key {key}.') from err

    def get_key(self, key):
        try:
            response = self.dyn_client.get_item(
                TableName=self.DYNAMODB_TABLE,
                Key={'Key': {'S': key}})
        except ClientError as err:
            raise DynamoDbException(
                f'Could not read key {key} key from DynamoDB table.') from err
        if 'Item' not in response:
            raise DynamoDbException(
                f'Could not read key {key} from DynamoDB table.')
        item = response['Item']
        return item['Value']['S']

    def list_keys(self, limit=100):
        response = self.dyn_client.scan(TableName=self.DYNAMODB_TABLE, AttributesToGet=['Key','Value'], Limit=limit)
        return [(i['Key']['S'], i['Value']['S']) for i in response['Items']]

    def delete_key(self, key):
        try:
            self.dyn_client.delete_item(
                TableName=self.DYNAMODB_TABLE,
                Key={'Key': {'S': key}})
        except ClientError as e:
            raise DynamoDbException(f'Failed to delete key: {key}. Error: {e}') from e
