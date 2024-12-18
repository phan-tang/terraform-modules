locals {
    lambda_root                   = "${path.module}"
    lambda_layer_requirements_txt = "${local.lambda_root}/requirements.txt"
    lambda_layer_lib_root         = "${local.lambda_root}/python"
    lambda_function_root          = "${local.lambda_root}/functions"
}