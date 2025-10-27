import boto3
import json
import os
import logging
import time
import shutil

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

# --- Global clients and configuration ---

TEMPLATE_FILE_NAME = None
OUTPUT_FILE_NAME = None
TEMPLATE_CONTENT = None
GALLERY_IMAGE_FOLDER_NAME = None
CLOUDFRONT_ID = None
GALLERY_BUCKET = None
ALERT_SNS_TOPIC_ARN = None
s3_client = None
cloudfront_client = None
sns_client = None
list_of_image_parameters = []

def init():
    global TEMPLATE_FILE_NAME, OUTPUT_FILE_NAME, TEMPLATE_CONTENT, GALLERY_BUCKET, ALERT_SNS_TOPIC_ARN, GALLERY_IMAGE_FOLDER_NAME, CLOUDFRONT_ID, s3_client, cloudfront_client, sns_client, list_of_image_parameters

    TEMPLATE_FILE_NAME = os.environ.get("TEMPLATE_FILE_NAME", "index_template.txt")
    OUTPUT_FILE_NAME = os.environ.get("OUTPUT_FILE_NAME", "index.html")
    GALLERY_IMAGE_FOLDER_NAME = os.environ.get("GALLERY_IMAGE_FOLDER_NAME", "Images")
    CLOUDFRONT_ID = os.environ.get("CLOUDFRONT_ID")
    GALLERY_BUCKET = os.environ.get("GALLERY_BUCKET")
    ALERT_SNS_TOPIC_ARN = os.environ.get("ALERT_SNS_TOPIC_ARN")

    shutil.copy("./index_template.txt", "/tmp/index_template.txt")
    print("Template File copied to /tmp successfully!")

    if not s3_client:
        s3_client = boto3.client("s3")
    if not cloudfront_client:
        cloudfront_client = boto3.client("cloudfront")
    if not sns_client:
        sns_client = boto3.client("sns")
    if not TEMPLATE_CONTENT:
        with open(f"/tmp/{TEMPLATE_FILE_NAME}", "r", encoding="utf-8") as template_file:
            TEMPLATE_CONTENT = template_file.read()


def generate_html():
    final_string = ""
    if not list_of_image_parameters:
        print("No images found in the bucket.")
    for item in list_of_image_parameters:
        final_string += f'<div class="box" style="background-image: url(\'./{item["image_path"]}\');" onclick="showModalPopup(\'./{item["image_path"]}\', \'{item["caption"]}\')"></div>\n\t\t'
    final_string = final_string.strip()
    print(final_string)
    output_file = open(f"/tmp/{OUTPUT_FILE_NAME}", "w", encoding="utf-8")
    output_file.write(TEMPLATE_CONTENT.replace("{div_content}", final_string))
    output_file.close()
    print("HTML file generated successfully.")


def copy_html_to_s3():
    with open(f"/tmp/{OUTPUT_FILE_NAME}", "rb") as file_data:
        s3_client.put_object(Bucket=GALLERY_BUCKET, Key=f"{OUTPUT_FILE_NAME}", Body=file_data, ContentType='text/html')
    print(f"HTML file {OUTPUT_FILE_NAME} copied to S3 bucket {GALLERY_BUCKET} successfully.")


def get_all_images():
    paginator = s3_client.get_paginator('list_objects_v2')
    for page in paginator.paginate(Bucket=GALLERY_BUCKET, Prefix=f"{GALLERY_IMAGE_FOLDER_NAME}/"):
        for obj in page.get('Contents', []):
            image_file_name = obj['Key']
            try:
                tag_response = s3_client.get_object_tagging(Bucket=GALLERY_BUCKET, Key=image_file_name)
                tags = {t['Key']: t['Value'] for t in tag_response.get('TagSet', [])}
                tag_value = tags.get('Caption', None)
                list_of_image_parameters.append({'image_path': image_file_name, 'caption': tag_value})
                print(f"Image File Name: {image_file_name} --> Caption: {tag_value}")
            except Exception as e:
                print(f"Error retrieving tags for {image_file_name}: {e}")
    print(list_of_image_parameters)
    if not page:
        print('No Paginator Output')


def invalidate_cloudfront_cache():
    paths = ["/*"]
    caller_reference = f"invalidation-{int(time.time())}"
    print(f"Creating CloudFront invalidation for {paths}")
    response = cloudfront_client.create_invalidation(
        DistributionId=CLOUDFRONT_ID,
        InvalidationBatch={
            "Paths": {
                "Quantity": len(paths),
                "Items": paths
            },
            "CallerReference": caller_reference
        }
    )
    invalidation_id = response["Invalidation"]["Id"]
    status = response["Invalidation"]["Status"]
    print(f"Invalidation {invalidation_id} created. Status: {status}")


def send_alert_message(subject, message):
    sns_client.publish(
        TopicArn = ALERT_SNS_TOPIC_ARN,
        Subject = subject,
        Message = message
    )


def lambda_handler(event, context):
    try:
        init()
        get_all_images()
        generate_html()
        copy_html_to_s3()
        invalidate_cloudfront_cache()
        send_alert_message('R&R ShutterWorks - HTML Generation Success', 'Updated HTML Generated Successfully !!')
        return {
            'statusCode': 200,
            'body': json.dumps('HTML generation completed successfully!')
        }
    except Exception as e:
        send_alert_message('R&R ShutterWorks - HTML Generation Failure', str(e))
        return {
            'statusCode': 500,
            'body': json.dumps(f"HTML generation failed with Error ${str(e)}!")
        }