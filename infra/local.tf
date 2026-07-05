locals {
  html_generator_lambda_env_vars = {
    "TEMPLATE_FILE_NAME" : "index_template.txt"
    "OUTPUT_FILE_NAME" : "index.html"
    "GALLERY_IMAGE_FOLDER_NAME" : "Images"
    "CLOUDFRONT_ID" : "${aws_cloudfront_distribution.image_gallery_distribution.id}"
    "GALLERY_BUCKET" : "${var.environment}-${local.project_code}-image-gallery"
    "ALERT_SNS_TOPIC_ARN" : "${aws_sns_topic.alert_topic.arn}"
  }

  image_copier_lambda_env_vars = {
    "SQS_URL" : "https://sqs.${data.aws_region.current_region.region}.amazonaws.com/${data.aws_caller_identity.current.account_id}/${var.environment}-${local.project_code}-image-processing-queue"
    "TARGET_BUCKET" : "${var.environment}-${local.project_code}-image-gallery"
    "OUTPUT_IMAGE_FOLDER_NAME" : "Images"
    "ALERT_SNS_TOPIC_ARN" : "${aws_sns_topic.alert_topic.arn}"
    "STEPFUNCTION_ARN" : "arn:aws:states:${data.aws_region.current_region.region}:${data.aws_caller_identity.current.account_id}:stateMachine:${var.environment}-${local.project_code}-stepfunction"
  }

  common_tags = {
    CreatedBy    = "${var.project_owner}"
    CreatedOn    = formatdate("DD-MM-YYYY", timeadd(timestamp(), "5h30m"))
    CreationMode = "IaC"
    Project      = "${var.project_name}"
  }

  project_code = lower(var.project_name)
}