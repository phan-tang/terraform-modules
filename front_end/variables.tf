variable "bucket_name" {
  description = "The name of bucket"
  type        = string
  validation {
    condition     = length(var.bucket_name) > 0 && length(var.bucket_name) <= 255
    error_message = "The bucket name must be between 1 and 255 characters long."
  }
}

variable "code_folder_name" {
  description = "The name of code folder"
  type        = string
  validation {
    condition     = length(var.code_folder_name) > 0 && length(var.code_folder_name) <= 255
    error_message = "The folder name must be between 1 and 255 characters long."
  }
}
