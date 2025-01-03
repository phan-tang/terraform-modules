variable "handler" {
  description = "The name of the Lambda function handler"
  type        = string
  validation {
    condition     = length(var.handler) > 0 && length(var.handler) <= 255
    error_message = "The handler name must be between 1 and 255 characters long."
  }
  default = "lambda_handler"
}

variable "lambda_layer_arn" {
  description = "The arn of the Lambda layer"
  type        = string
  validation {
    condition     = length(var.lambda_layer_arn) > 0 && length(var.lambda_layer_arn) <= 255
    error_message = "The lambda layer arn must be between 1 and 255 characters long."
  }
}

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
  validation {
    condition     = length(var.function_name) > 0 && length(var.function_name) <= 255
    error_message = "The Lambda function name must be between 1 and 255 characters long."
  }
}

variable "queue_name" {
  description = "The name of the queue"
  type        = string
  validation {
    condition     = length(var.queue_name) > 0 && length(var.queue_name) <= 255
    error_message = "The queue name must be between 1 and 255 characters long."
  }
}