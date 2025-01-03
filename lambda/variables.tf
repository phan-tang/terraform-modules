variable "runtime" {
  description = "The Python runtime used to run functions"
  type        = string
  default     = "python3.10"
}

variable "timeout" {
  description = "The timeout of function"
  type        = number
  default     = 30
}

variable "layer_folder" {
  description = "The name of folder used to store code Lambda layer"
  type        = string
  validation {
    condition     = length(var.layer_folder) > 0 && length(var.layer_folder) <= 255
    error_message = "The layer folder must be between 1 and 255 characters long."
  }
  default = "layer"
}

variable "layer_name" {
  description = "The name of Lambda layer"
  type        = string
  validation {
    condition     = length(var.layer_name) > 0 && length(var.layer_name) <= 255
    error_message = "The layer name must be between 1 and 255 characters long."
  }
  default = "lambda_layer"
}

variable "lambda_layer_arn" {
  description = "The arn of the Lambda layer"
  type        = string
  validation {
    condition     = length(var.lambda_layer_arn) > 0 && length(var.lambda_layer_arn) <= 255
    error_message = "The lambda layer arn must be between 1 and 255 characters long."
  }
}

variable "functions_folder" {
  description = "The name of folder used to store Lambda functions"
  type        = string
  validation {
    condition     = length(var.functions_folder) > 0 && length(var.functions_folder) <= 255
    error_message = "The functions folder must be between 1 and 255 characters long."
  }
  default = "functions"
}

variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
  validation {
    condition     = length(var.function_name) > 0 && length(var.function_name) <= 255
    error_message = "The function name must be between 1 and 255 characters long."
  }
}

variable "handler" {
  description = "The name of the Lambda function handler"
  type        = string
  validation {
    condition     = length(var.handler) > 0 && length(var.handler) <= 255
    error_message = "The handler name must be between 1 and 255 characters long."
  }
  default = "lambda_handler"
}

variable "env_variables" {
  description = "The environment variables of Lambda functions"
  type        = map
}