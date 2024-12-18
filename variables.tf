variable "hash_key" {
  description = "The primary key for the table"
  type        = string
  validation {
    condition     = length(var.hash_key) > 0 && length(var.hash_key) <= 255
    error_message = "The hash key must be between 1 and 255 characters long."
  }
}

variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  validation {
    condition     = length(var.table_name) > 0 && length(var.table_name) <= 255
    error_message = "The table name must be between 1 and 255 characters long."
  }
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