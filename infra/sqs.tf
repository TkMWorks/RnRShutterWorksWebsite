resource "aws_sqs_queue" "image_processing_queue_dlq" {
  name                       = "${var.environment}-${var.project_code}-image-processing-queue-dlq"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 1209600
  delay_seconds              = 0
  tags = merge(local.common_tags, {
    Name        = "${var.environment}-${var.project_code}-image-processing-queue-dlq"
    Description = "${var.project_name} Image Processing DLQ"
  })
}

resource "aws_sqs_queue" "image_processing_queue" {
  name                       = "${var.environment}-${var.project_code}-image-processing-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400
  delay_seconds              = 0
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.image_processing_queue_dlq.arn
    maxReceiveCount     = 5
  })
  tags = merge(local.common_tags, {
    Name        = "${var.environment}-${var.project_code}-image-processing-queue"
    Description = "${var.project_name} Image Processing SQS Queue"
  })
}

resource "aws_sqs_queue_policy" "image_processing_queue_policy" {
  queue_url = aws_sqs_queue.image_processing_queue.id
  policy    = data.aws_iam_policy_document.image_processing_sqs_queue_policy.json
}

resource "aws_sns_topic_subscription" "image_processing_queue_subscription" {
  topic_arn            = aws_sns_topic.image_upload_topic.arn
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.image_processing_queue.arn
  raw_message_delivery = true
  depends_on = [
    aws_sns_topic.image_upload_topic,
    aws_sqs_queue_policy.image_processing_queue_policy
  ]
}