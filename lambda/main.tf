resource "aws_iam_role" "lambda_role" {
  name_prefix = "Lambda-${var.function_name}-"
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
  name         = "aws_iam_policy_for_terraform_aws_lambda_role"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
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

resource "null_resource" "pip_install" {
  provisioner "local-exec" {
    command = "pip install --quiet --quiet --requirement ${local.lambda_layer_requirements_txt} --target ${local.lambda_layer_lib_root}"
  }

  triggers = {
    # Use this to force an update of pip dependencies
    #always_run   = timestamp()
    requirements = filemd5(local.lambda_layer_requirements_txt)
  }
}

data "archive_file" "lambda_layer" {
  depends_on  = [null_resource.pip_install]
  type        = "zip"
  source_dir  = local.lambda_root
  output_path = "${path.module}/lambda_layer.zip"
}

resource "aws_lambda_layer_version" "layer" {
  layer_name          = "${var.function_name}-pip-requirements"
  filename            = data.archive_file.lambda_layer.output_path
  source_code_hash    = data.archive_file.lambda_layer.output_base64sha256
  compatible_runtimes = [var.runtime]

  # Ensure the new layer version is created before the old layer version is deleted (avoids /
  # reduces function downtime). An alternative option is to set `skip_destroy = true`, but that
  # will result in unused layers which incur a cost.
  # lifecycle {
    # create_before_destroy = true
  # }
}

data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = local.lambda_function_root
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "lambda" {
  depends_on = [aws_cloudwatch_log_group.lambda, aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]

  filename         = data.archive_file.lambda_function.output_path
  function_name    = var.function_name
  timeout          = var.timeout
  runtime          = var.runtime
  handler          = var.handler
  role             = aws_iam_role.lambda_role.arn
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  layers           = [aws_lambda_layer_version.layer.arn]
}