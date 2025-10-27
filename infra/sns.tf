resource "aws_sns_topic" "image_upload_topic" {
  name         = "${var.environment}-${var.project_code}-image-upload-topic"
  display_name = "Image Upload SNS Topic for ${var.project_name}"
  tags = merge(local.common_tags, {
    Name        = "${var.environment}-${var.project_code}-image-upload-topic"
    Description = "Image Upload SNS Topic for ${var.project_name}"
  })
}

resource "aws_sns_topic_policy" "image_upload_topic_policy" {
  arn    = aws_sns_topic.image_upload_topic.arn
  policy = data.aws_iam_policy_document.image_upload_sns_topic_policy.json
}

resource "aws_sns_topic" "alert_topic" {
  name         = "${var.environment}-${var.project_code}-alert-topic"
  display_name = "Alert SNS Topic for ${var.project_name}"
  tags = merge(local.common_tags, {
    Name        = "${var.environment}-${var.project_code}-alert-topic"
    Description = "Alert SNS Topic for ${var.project_name}"
  })
}

resource "aws_sns_topic_policy" "alert_topic_policy" {
  arn    = aws_sns_topic.alert_topic.arn
  policy = data.aws_iam_policy_document.alert_sns_topic_policy.json
}

resource "aws_sns_topic_subscription" "alert_email_subscription" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}