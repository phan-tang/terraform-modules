module "lambda" {
  source = "../lambda"

  function_name = var.function_name
  handler = var.handler
  lambda_layer_arn = var.lambda_layer_arn
  functions_folder = "api_gateway"
  env_variables = {
    JWT_SECRET = local.envs["JWT_SECRET"],
    JWT_ALGORITHM = local.envs["JWT_ALGORITHM"]
  }
}

resource "aws_api_gateway_rest_api" "exam_system" {
  name        = "serverless_exam_system_${local.api_resource}"
  description = "Serverless Exam System"
}

resource "aws_api_gateway_resource" "api_resource" {
  depends_on = [aws_api_gateway_rest_api.exam_system]
  rest_api_id = "${aws_api_gateway_rest_api.exam_system.id}"
  parent_id   = "${aws_api_gateway_rest_api.exam_system.root_resource_id}"
  path_part   = "${local.api_resource}"
}

resource "aws_api_gateway_method" "api_resource" {
  rest_api_id   = "${aws_api_gateway_rest_api.exam_system.id}"
  resource_id   = "${aws_api_gateway_resource.api_resource.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "api_resource_root" {
  rest_api_id   = aws_api_gateway_rest_api.exam_system.id
  resource_id   = aws_api_gateway_rest_api.exam_system.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.exam_system.id}"
  resource_id = "${aws_api_gateway_method.api_resource.resource_id}"
  http_method = "${aws_api_gateway_method.api_resource.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${module.lambda.lambda_function_invoke_arn}"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.exam_system.id}"
  resource_id = "${aws_api_gateway_method.api_resource_root.resource_id}"
  http_method = "${aws_api_gateway_method.api_resource_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${module.lambda.lambda_function_invoke_arn}"
}

resource "aws_api_gateway_deployment" "exam_system" {
  depends_on = [
    "aws_api_gateway_integration.lambda",
    "aws_api_gateway_integration.lambda_root",
  ]
  rest_api_id = "${aws_api_gateway_rest_api.exam_system.id}"
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.exam_system.id
  rest_api_id   = "${aws_api_gateway_rest_api.exam_system.id}"
  stage_name    = var.stage_name
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${module.lambda.lambda_function_name}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.exam_system.execution_arn}/*/*"
}
