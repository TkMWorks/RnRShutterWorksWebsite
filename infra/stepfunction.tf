resource "aws_iam_role" "stepfunction_iam_role" {
  name                 = "${var.environment}-${local.project_code}-stepfunction-iam-role"
  assume_role_policy   = data.aws_iam_policy_document.stepfunction_assume_role_policy.json
  description          = "IAM Role for ${var.project_name} Step Function"
  max_session_duration = 3600
  tags = merge(local.common_tags, {
    Name = "${var.project_name} Step Function IAM Role"
  })
}

resource "aws_iam_role_policy" "stepfunction_iam_role_policy" {
  name   = "${var.environment}-${local.project_code}-stepfunction-iam-policy"
  policy = data.aws_iam_policy_document.stepfunction_role_policy.json
  role   = aws_iam_role.stepfunction_iam_role.name
}

resource "aws_cloudwatch_log_group" "stepfunction_cloudwatch_log_group" {
  name              = "${var.environment}-${local.project_code}-stepfunction-Logs"
  skip_destroy      = false
  retention_in_days = 90
  tags = merge(local.common_tags, {
    Name        = "${var.environment}-${local.project_code}-stepfunction-Logs"
    Description = "CloudWatch Log Group for ${var.project_name} Step Function"
  })
}

resource "aws_sfn_state_machine" "stepfunction" {
  name     = "${var.environment}-${local.project_code}-stepfunction"
  role_arn = aws_iam_role.stepfunction_iam_role.arn
  type     = "EXPRESS"
  definition = templatefile("${path.module}/stepfn.json", {
    HTMLGeneratorLambdaARN = "${aws_lambda_function.html_generator_lambda.arn}"
  })
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.stepfunction_cloudwatch_log_group.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }
  tags = merge(local.common_tags, {
    Description = "StepFunction For HTML Generator"
  })
  depends_on = [
    aws_lambda_function.html_generator_lambda,
    aws_cloudwatch_log_group.stepfunction_cloudwatch_log_group
  ]
}