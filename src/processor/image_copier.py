import boto3
import json
import os
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

SQS_URL = None
TARGET_BUCKET = None
OUTPUT_IMAGE_FOLDER_NAME = None
ALERT_SNS_TOPIC_ARN = None
STEPFUNCTION_ARN = None
s3_client = None
sqs_client = None
sns_client = None
sfn_client = None
sqs_messages_to_delete = []


def init():
    global SQS_URL, TARGET_BUCKET, OUTPUT_IMAGE_FOLDER_NAME, ALERT_SNS_TOPIC_ARN, STEPFUNCTION_ARN, s3_client, sqs_client, sns_client, sfn_client, sqs_messages_to_delete
    try:
        SQS_URL = os.environ.get("SQS_URL")
        TARGET_BUCKET = os.environ.get("TARGET_BUCKET")
        OUTPUT_IMAGE_FOLDER_NAME = os.environ.get("OUTPUT_IMAGE_FOLDER_NAME")
        ALERT_SNS_TOPIC_ARN = os.environ.get("ALERT_SNS_TOPIC_ARN")
        STEPFUNCTION_ARN = os.environ.get("STEPFUNCTION_ARN")
        if not s3_client:
            s3_client = boto3.client("s3")
        if not sqs_client:
            sqs_client = boto3.client("sqs")
        if not sns_client:
            sns_client = boto3.client("sns")
        if not sfn_client:
            sfn_client = boto3.client("stepfunctions")
    except Exception as e:
        raise


def process_sqs_messages(event):
    for record in event['Records']:
        receipt_handle = record['receiptHandle']
        message_id = record['messageId']
        try:
            message_body = json.loads(record['body'])
            record = message_body['Records'][0]
            bucket_name = record['s3']['bucket']['name']
            object_key = record['s3']['object']['key']
            copy_images_to_s3(bucket_name, object_key)
            sqs_messages_to_delete.append({'Id': message_id, 'ReceiptHandle': receipt_handle})
        except Exception as e:
            logger.error(f"Failed to parse SQS message body for message ID {message_id}: ${str(e)}")
            raise


def copy_images_to_s3(source_bucket, source_image_key):
    destination_key = f"{OUTPUT_IMAGE_FOLDER_NAME}/{source_image_key}"
    try:
        s3_client.copy_object(Bucket=TARGET_BUCKET, CopySource={'Bucket': source_bucket, 'Key': source_image_key}, Key=destination_key, TaggingDirective='COPY', MetadataDirective='REPLACE', ContentType='image/jpeg')
        print(f"Image {source_image_key} copied to S3 bucket {TARGET_BUCKET} successfully.")
    except s3_client.exceptions.ClientError:
        print(f"Image copy failed for {source_image_key}.")
        raise


def delete_processed_sqs_messages():
    if sqs_messages_to_delete:
        try:
            response = sqs_client.delete_message_batch(QueueUrl=SQS_URL, Entries=sqs_messages_to_delete)
            if 'Failed' in response and response['Failed']:
                for failure in response['Failed']:
                    logger.error(f"Failed to delete SQS message ID {failure['Id']}: {failure['Message']}")
            else:
                print("Processed SQS messages deleted successfully.")
        except Exception as e:
            logger.error(f"Failed to delete processed SQS messages: {e}")


def send_alert_message(subject, message):
    sns_client.publish(
        TopicArn = ALERT_SNS_TOPIC_ARN,
        Subject = subject,
        Message = message
    )


def trigger_stepfunction():
    sfn_client.start_execution(stateMachineArn=STEPFUNCTION_ARN)


def lambda_handler(event, context):
    try:
        init()
        process_sqs_messages(event)
        delete_processed_sqs_messages()
        send_alert_message('R&R ShutterWorks - Image Copy Success', 'All uploaded images copied to gallery successfully !!')
        trigger_stepfunction()
        return {
            'statusCode': 200,
            'body': json.dumps('S3 upload completed successfully!')
        }
    except Exception as e:
        send_alert_message('R&R ShutterWorks - Image Copy Failure', str(e))
        return {
            'statusCode': 500,
            'body': json.dumps(f"Image Copy Failed with Error ${str(e)} !!")
        }