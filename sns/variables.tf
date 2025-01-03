variable "topic_name" {
  description = "The name of the SNS topic"
  type        = string
  validation {
    condition     = length(var.topic_name) > 0 && length(var.topic_name) <= 255
    error_message = "The SNS topic name must be between 1 and 255 characters long."
  }
}