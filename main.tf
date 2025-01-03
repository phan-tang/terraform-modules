data "external" "api_lambda_functions_config_file" {
  program = ["python", local.lambda_functions_config_file, local.api_code_folder, local.api_file_config_name]
}

data "local_file" "api_lambda_functions_config_output" {
  filename = local.api_lambda_functions_config_output
  depends_on = [data.external.api_lambda_functions_config_file]
}

data "external" "sqs_lambda_functions_config_file" {
  program = ["python", local.lambda_functions_config_file, local.sqs_code_folder, local.sqs_file_config_name]
}

data "local_file" "sqs_lambda_functions_config_output" {
  filename = local.sqs_lambda_functions_config_output
  depends_on = [data.external.sqs_lambda_functions_config_file]
}

resource "null_resource" "lambda_layer" {
  triggers = {
    always_run   = timestamp()
    requirements = filesha1(local.lambda_layer_requirements_txt)
  }
  
  provisioner "local-exec" {
    command = <<EOT
      rm -rf ${local.lambda_module}/${var.lambda_layer_name}.zip
      rm -rf ${local.lambda_module}/python
      pip install -r ${local.lambda_layer_requirements_txt} -t ${local.lambda_module}/python
      cp -a ${local.lambda_module}/${var.lambda_layer_folder}/. ${local.lambda_module}/python/
    EOT
  }
}

data "archive_file" "lambda_layer" {
  depends_on  = [null_resource.lambda_layer]
  type        = "zip"
  source_dir  = local.lambda_module
  output_path = "${local.lambda_module}/deployed_code/${var.lambda_layer_name}.zip"
}

resource "aws_lambda_layer_version" "layer" {
  layer_name          = "lambda_layer"
  filename            = data.archive_file.lambda_layer.output_path
  source_code_hash    = data.archive_file.lambda_layer.output_base64sha256
  compatible_runtimes = [var.runtime]
}

module "dynamodb" {
    source = "./dynamodb"

    for_each = tomap(local.dynamodb_tables.data)
    table_name = each.key
    hash_key = each.value.hash_key
}

module "api_gateway" {
  depends_on = [aws_lambda_layer_version.layer]
  source = "./api_gateway"
  for_each = tomap(local.api_lambda_functions_config.data)

  function_name = each.key
  handler = each.value
  lambda_layer_arn = aws_lambda_layer_version.layer.arn
}

module "sqs" {
  depends_on = [aws_lambda_layer_version.layer]
  source = "./sqs"
  for_each = tomap(local.sqs_lambda_functions_config.data)

  function_name = each.key
  queue_name = each.key
  handler = each.value
  lambda_layer_arn = aws_lambda_layer_version.layer.arn
}

module "front_end" {
  source = "./front_end"

  bucket_name = "exam-system-server"
  code_folder_name = "exam-system"
}