locals {
    lambda_module                       = "./lambda"
    lambda_layer_requirements_txt       = "${local.lambda_module}/requirements.txt"
    lambda_functions_config_file        = "${local.lambda_module}/config.py"
    api_code_folder                     = "api_gateway"
    sqs_code_folder                     = "sqs"
    api_file_config_name                = "api_config"
    sqs_file_config_name                = "sqs_config"
    api_lambda_functions_config_output  = "${local.lambda_module}/${local.api_file_config_name}.json"
    sqs_lambda_functions_config_output  = "${local.lambda_module}/${local.sqs_file_config_name}.json"
    api_lambda_functions_config         = jsondecode(data.local_file.api_lambda_functions_config_output.content)
    sqs_lambda_functions_config         = jsondecode(data.local_file.sqs_lambda_functions_config_output.content)
    dynamodb_module                     = "./dynamodb"
    dynamodb_tables                     = jsondecode(file("${local.dynamodb_module}/config.json"))
}