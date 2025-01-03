variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^us-(east|west)-[1-2]$", var.region)) || can(regex("^eu-(central|west)-1$", var.region)) || can(regex("^ap-(south|northeast)-1$", var.region))
    error_message = "The region must be a valid AWS region, such as us-east-1, us-west-2, eu-central-1, ap-northeast-1."
  }
}

variable "runtime" {
  description = "The Python runtime used to run functions"
  type        = string
  default     = "python3.10"
}

variable "lambda_layer_folder" {
  description = "The name of folder used to store code Lambda layer"
  type        = string
  validation {
    condition     = length(var.lambda_layer_folder) > 0 && length(var.lambda_layer_folder) <= 255
    error_message = "The layer folder must be between 1 and 255 characters long."
  }
  default = "layer"
}

variable "lambda_layer_name" {
  description = "The name of Lambda layer"
  type        = string
  validation {
    condition     = length(var.lambda_layer_name) > 0 && length(var.lambda_layer_name) <= 255
    error_message = "The layer name must be between 1 and 255 characters long."
  }
  default = "lambda_layer"
}

variable "lambda_functions_folder" {
  description = "The name of folder used to store Lambda functions"
  type        = string
  validation {
    condition     = length(var.lambda_functions_folder) > 0 && length(var.lambda_functions_folder) <= 255
    error_message = "The functions folder must be between 1 and 255 characters long."
  }
  default = "functions"
}