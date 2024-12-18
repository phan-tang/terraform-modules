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
  default     = "python3.12"
}

variable "timeout" {
  description = "The timeout of function"
  type        = number
  default     = 10
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
    error_message = "The function name must be between 1 and 255 characters long."
  }
}