data "aws_caller_identity" "current" {}

data "aws_region" "current_region" {}

# Data for Image Upload SNS Topic
data "aws_iam_policy_document" "image_upload_sns_topic_policy" {
  statement {
    sid    = "AllowS3ToPublishToSNSTopic"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.image_upload_topic.arn]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:s3:::${var.environment}-${local.project_code}-image-lz"]
    }
  }
  statement {
    sid    = "AllowAccountToManageTopic"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "sns:Publish",
      "sns:Subscribe",
      "sns:Receive",
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "sns:DeleteTopic",
      "sns:ListSubscriptionsByTopic"
    ]
    resources = [aws_sns_topic.image_upload_topic.arn]
  }
}

# Data for Alert SNS Topic
data "aws_iam_policy_document" "alert_sns_topic_policy" {
  statement {
    sid    = "AllowS3ToPublishToSNSTopic"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.alert_topic.arn]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:s3:::${var.environment}-${local.project_code}-image-gallery"]
    }
  }
  statement {
    sid    = "AllowLambdaToPublishToSNSTopic"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.alert_topic.arn]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:lambda:${data.aws_region.current_region.region}:${data.aws_caller_identity.current.account_id}:function:${var.environment}-${local.project_code}-html-generator",
        "arn:aws:lambda:${data.aws_region.current_region.region}:${data.aws_caller_identity.current.account_id}:function:${var.environment}-${local.project_code}-image-copier"
      ]
    }
  }
  statement {
    sid    = "AllowAccountToManageTopic"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "sns:Publish",
      "sns:Subscribe",
      "sns:Receive",
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "sns:DeleteTopic",
      "sns:ListSubscriptionsByTopic"
    ]
    resources = [aws_sns_topic.alert_topic.arn]
  }
}

# Data for Gallery S3 Bucket Access Policy from CloudFront
data "aws_iam_policy_document" "gallery_s3_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontReadOnly"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.environment}-${local.project_code}-image-gallery/*"]
  }
  statement {
    sid    = "AllowLambdaReadWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion",
      "s3:PutObjectAcl",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging"
    ]
    resources = [
      "arn:aws:s3:::${var.environment}-${local.project_code}-image-gallery",
      "arn:aws:s3:::${var.environment}-${local.project_code}-image-gallery/*"
    ]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:lambda:${data.aws_region.current_region.region}:${data.aws_caller_identity.current.account_id}:function:${var.environment}-${local.project_code}-html-generator",
        "arn:aws:lambda:${data.aws_region.current_region.region}:${data.aws_caller_identity.current.account_id}:function:${var.environment}-${local.project_code}-image-copier"
      ]
    }
  }
  statement {
    sid    = "AllowUserAdminAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${var.environment}-${local.project_code}-image-gallery/*"]
  }
}

# Data for SQS Queue Access Policy
data "aws_iam_policy_document" "image_processing_sqs_queue_policy" {
  statement {
    sid    = "AllowSNSPublish"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:${data.aws_region.current_region.region}:${data.aws_caller_identity.current.account_id}:${var.environment}-${local.project_code}-image-processing-queue"]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.image_upload_topic.arn]
    }
  }
  statement {
    sid    = "AllowLambdaReceiveDelete"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl"
    ]
    resources = [aws_sqs_queue.image_processing_queue.arn]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:lambda:${data.aws_region.current_region.region}:${data.aws_caller_identity.current.account_id}:function:${var.environment}-${local.project_code}-image-copier"]
    }
  }
  statement {
    sid    = "AllowAccountFullAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["sqs:*"]
    resources = [aws_sqs_queue.image_processing_queue.arn]
  }
}

# Lambda Assume Role Policy
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Data for HTML Processor Lambda Role Policy
data "aws_iam_policy_document" "html_processor_lambda_role_policy" {
  statement {
    sid    = "AllowLambdaAccessToCloudFront"
    effect = "Allow"
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations",
      "cloudfront:GetDistribution",
      "cloudfront:ListDistributions"
    ]
    resources = [aws_cloudfront_distribution.image_gallery_distribution.arn]
  }
  statement {
    sid    = "AllowLambdaAccessToS3"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion",
      "s3:PutObjectAcl",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging"
    ]
    resources = [
      "arn:aws:s3:::${var.environment}-${local.project_code}-image-gallery",
      "arn:aws:s3:::${var.environment}-${local.project_code}-image-gallery/*",
      "arn:aws:s3:::${var.environment}-${local.project_code}-image-gallery/Images/*",
      "arn:aws:s3:::${var.environment}-${local.project_code}-image-gallery/Images"
    ]
  }
  statement {
    sid       = "AllowLambdaToPublishAlertsToSNS"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.alert_topic.arn]
  }
}

# Data for Image Copier Lambda Role Policy
data "aws_iam_policy_document" "image_copier_lambda_role_policy" {
  statement {
    sid    = "AllowLambdaToAccessSQS"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl"
    ]
    resources = ["arn:aws:sqs:${data.aws_region.current_region.region}:${data.aws_caller_identity.current.account_id}:${var.environment}-${local.project_code}-image-processing-queue"]
  }
  statement {
    sid    = "AllowLambdaToAccessS3Bucket"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:GetObjectVersion",
      "s3:PutObjectAcl",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging"
    ]
    resources = [
      "arn:aws:s3:::${var.environment}-${local.project_code}-image-lz",
      "arn:aws:s3:::${var.environment}-${local.project_code}-image-lz/*",
      "arn:aws:s3:::${var.environment}-${local.project_code}-image-gallery",
      "arn:aws:s3:::${var.environment}-${local.project_code}-image-gallery/*"
    ]
  }
  statement {
    sid       = "AllowLambdaToPublishAlertsToSNS"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.alert_topic.arn]
  }
  statement {
    sid       = "AllowLambdaToInvokeStepFunction"
    effect    = "Allow"
    actions   = ["states:StartExecution"]
    resources = ["arn:aws:states:${data.aws_region.current_region.region}:${data.aws_caller_identity.current.account_id}:stateMachine:${var.environment}-${local.project_code}-stepfunction"]
  }
}

# Data for StepFunction Assume Role Policy
data "aws_iam_policy_document" "stepfunction_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Data for StepFunction Execute Policy
data "aws_iam_policy_document" "stepfunction_role_policy" {
  statement {
    sid    = "AllowCloudwatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowXRayTracing"
    effect = "Allow"
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowLambdaExecute"
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = ["arn:aws:lambda:${data.aws_region.current_region.region}:${data.aws_caller_identity.current.account_id}:function:${var.environment}-${local.project_code}-html-generator"]
  }
}

data "aws_acm_certificate" "custom_domain_ssl_certificate" {
  domain      = "*.${var.custom_domain_name}"
  statuses    = ["ISSUED"]
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}