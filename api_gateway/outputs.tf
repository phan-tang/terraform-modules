output "rest_api_invoke_url" {
  value = "${aws_api_gateway_deployment.exam_system.invoke_url}${var.stage_name}/${local.api_resource}"
}