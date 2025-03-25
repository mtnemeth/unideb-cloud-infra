import logging
import traceback
import boto3

log = logging.getLogger(__name__)
log.setLevel("INFO")

s3 = boto3.client('s3')

def lambda_handler(event, context):
    if not (event['source'] == 'aws.s3' and
            event['detail-type'] == 'Object Created'):
        raise Exception('Event is not of type Object Created!')
    
    s3_bucket = event['detail']['bucket']['name']
    s3_key = event['detail']['object']['key']
    log.info(f'Object received: {s3_bucket}, {s3_key}')

    s3_processed_key = s3_key.replace('in/','processed/')
    log.info(f'New S3 object: {s3_bucket}, {s3_processed_key}')

    content = s3.get_object(Bucket=s3_bucket, Key=s3_key)['Body'].read().decode(encoding='utf-8')
    new_content=f'#processed\n{content}'

    s3.put_object(Bucket=s3_bucket, Key=s3_processed_key,
        Body=new_content.encode(encoding="utf-8"))
    
    log.info('Done')

