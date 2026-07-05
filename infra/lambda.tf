resource "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../src/processor"
  output_path = "${path.module}/lambda_package.zip"
}

resource "aws_iam_role" "html_generator_lambda_iam_role" {
  name                 = "${var.environment}-${local.project_code}-htmlgen-lambda-iam-role"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
  description          = "IAM Role for ${var.project_name} HTML Generator Lambda"
  max_session_duration = 3600
  tags = merge(local.common_tags, {
    Name = "${var.project_name} HTML Generator Lambda IAM Role"
  })
  depends_on = [
    aws_cloudfront_distribution.image_gallery_distribution,
    aws_sns_topic.alert_topic
  ]
}

resource "aws_iam_role_policy" "html_generator_lambda_iam_role_policy" {
  name   = "${var.environment}-${local.project_code}-htmlgen-lambda-iam-policy"
  policy = data.aws_iam_policy_document.html_processor_lambda_role_policy.json
  role   = aws_iam_role.html_generator_lambda_iam_role.name
}

resource "aws_iam_role" "image_copier_lambda_iam_role" {
  name                 = "${var.environment}-${local.project_code}-imagecopy-lambda-iam-role"
  assume_role_policy   = data.aws_iam_policy_document.lambda_assume_role_policy.json
  description          = "IAM Role for ${var.project_name} Image Copier Lambda"
  max_session_duration = 3600
  tags = merge(local.common_tags, {
    Name = "${var.project_name} Image Copier Lambda IAM Role"
  })
  depends_on = [aws_sns_topic.alert_topic]
}

resource "aws_iam_role_policy" "image_copier_lambda_iam_role_policy" {
  name   = "${var.environment}-${local.project_code}-imagecopy-lambda-iam-policy"
  policy = data.aws_iam_policy_document.image_copier_lambda_role_policy.json
  role   = aws_iam_role.image_copier_lambda_iam_role.name
}

resource "aws_iam_role_policy_attachment" "html_generator_iam_role_lambda_policy_attach" {
  role       = aws_iam_role.html_generator_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "image_copier_iam_role_lambda_policy_attach" {
  role       = aws_iam_role.image_copier_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "image_copier_iam_role_sqs_policy_attach" {
  role       = aws_iam_role.image_copier_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_lambda_function" "image_copier_lambda" {
  function_name = "${var.environment}-${local.project_code}-image-copier"
  role          = aws_iam_role.image_copier_lambda_iam_role.arn
  architectures = ["x86_64"]
  description   = "${var.project_name} Image Copier Lambda"
  memory_size   = 512
  environment {
    variables = local.image_copier_lambda_env_vars
  }
  filename         = archive_file.lambda_zip.output_path
  handler          = "image_copier.lambda_handler"
  runtime          = "python3.13"
  source_code_hash = archive_file.lambda_zip.output_base64sha256
  timeout          = 30
  tags = merge(local.common_tags, {
    Name        = "${var.environment}-${local.project_code}-image-copier"
    Description = "Lambda Function to Copy Images to Gallery"
  })
}

resource "aws_lambda_function" "html_generator_lambda" {
  function_name = "${var.environment}-${local.project_code}-html-generator"
  role          = aws_iam_role.html_generator_lambda_iam_role.arn
  architectures = ["x86_64"]
  description   = "${var.project_name} HTML Generator Lambda"
  memory_size   = 512
  environment {
    variables = local.html_generator_lambda_env_vars
  }
  filename         = archive_file.lambda_zip.output_path
  handler          = "html_generator.lambda_handler"
  runtime          = "python3.13"
  source_code_hash = archive_file.lambda_zip.output_base64sha256
  timeout          = 30
  tags = merge(local.common_tags, {
    Name        = "${var.environment}-${local.project_code}-html-generator"
    Description = "Lambda Function to Generate Gallery HTML"
  })
}

resource "aws_lambda_event_source_mapping" "image_copier_lambda_sqs_trigger" {
  function_name                      = aws_lambda_function.image_copier_lambda.arn
  event_source_arn                   = aws_sqs_queue.image_processing_queue.arn
  batch_size                         = 100
  maximum_batching_window_in_seconds = 120
  enabled                            = true
  tags = merge(local.common_tags, {
    Name        = "${var.environment}-${local.project_code}-image-copier-sqs-trigger"
    Description = "SQS Trigger for Image Copier Lambda"
  })
  depends_on = [
    aws_lambda_function.image_copier_lambda,
    aws_sqs_queue.image_processing_queue
  ]
}