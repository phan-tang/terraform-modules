module "sns" {
  source = "../sns"

  topic_name = var.function_name
}

module "lambda" {
  depends_on = [module.sns]
  source = "../lambda"

  function_name = var.function_name
  handler = var.handler
  functions_folder = "sqs"
  lambda_layer_arn = var.lambda_layer_arn
  env_variables = {
    TOPIC_ARN = "${module.sns.topic_arn}"
  }
}

resource "aws_sqs_queue" "queue" {
  name                      = "${var.queue_name}"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  batch_size        = 1
  event_source_arn  = "${aws_sqs_queue.queue.arn}"
  enabled           = true
  function_name     = "${module.lambda.lambda_function_arn}"
}
