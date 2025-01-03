variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
  validation {
    condition     = can(regex("^us-(east|west)-[1-2]$", var.region)) || can(regex("^eu-(central|west)-1$", var.region)) || can(regex("^ap-(south|northeast)-1$", var.region))
    error_message = "The region must be a valid AWS region, such as us-east-1, us-west-2, eu-central-1, ap-northeast-1."
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
 
variable "billing_mode" {
  description = "The billing mode for the table (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
  validation {
    condition     = var.billing_mode == "PROVISIONED" || var.billing_mode == "PAY_PER_REQUEST"
    error_message = "The billing mode must be either 'PROVISIONED' or 'PAY_PER_REQUEST'."
  }
}
 
variable "hash_key" {
  description = "The primary key for the table"
  type        = string
  validation {
    condition     = length(var.hash_key) > 0 && length(var.hash_key) <= 255
    error_message = "The hash key must be between 1 and 255 characters long."
  }
}
 
variable "hash_key_type" {
  description = "The type of the primary key (S or N)"
  type        = string
  default     = "S"
  validation {
    condition     = var.hash_key_type == "S" || var.hash_key_type == "N"
    error_message = "The hash key type must be either 'S' (string) or 'N' (number)."
  }
}
 
variable "environment" {
  description = "The deployment environment"
  type        = string
  default     = "development"
  validation {
    condition     = var.environment == "development" || var.environment == "staging" || var.environment == "production"
    error_message = "The environment must be either 'development', 'staging' or 'production'."
  }
}

variable "test_user" {
  description = "The test user for the user table, username is admin123, password is Admin@123"
  type        = any
  default     = {
    "user_id": "f02865f7-dd07-4fec-ac52-0617487de00b",
    "first_name": "Admin",
    "last_name": "System",
    "username": "admin123",
    "email": "admin123@email.com",
    "password": "$2b$12$Aq9lVRCQXoqWBO6acBtZ1O1mcRBffpW5nxXtnoCthfALoOslqqTCS",
    "user_type": "A",
    "user_status": "A"
  }
}
 