resource "aws_iam_role" "lambda_role" {
  name_prefix = "lambda-${var.function_name}-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name         = "aws_iam_policy_for_${var.function_name}_aws_lambda_role"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "logs:*",
          "dynamodb:*",
          "sqs:*",
          "sns:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
}

data "archive_file" "lambda_functions" {
  type        = "zip"
  source_file  = "${path.module}/${var.functions_folder}/${var.function_name}.py"
  output_path = "${path.module}/deployed_code/${var.functions_folder}_${var.function_name}.zip"
}

resource "aws_lambda_function" "lambda" {
  depends_on       = [aws_cloudwatch_log_group.lambda, aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]

  filename         = data.archive_file.lambda_functions.output_path
  function_name    = "${var.function_name}_lambda_handler"
  timeout          = var.timeout
  runtime          = var.runtime
  handler          = "${var.function_name}.${var.handler}"
  role             = aws_iam_role.lambda_role.arn
  source_code_hash = data.archive_file.lambda_functions.output_base64sha256
  layers           = [var.lambda_layer_arn]

  environment {
    variables = var.env_variables
  }
}