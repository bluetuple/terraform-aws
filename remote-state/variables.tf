
# variable for default region
variable "sbx_region" {
  type        = string
  default     = "<default-region>"
  description = "your default region"
}

variable "sbx_bucket_rstate" {
  type        = string
  description = "unique name of the S3 bucket for state"
}

variable "sbx_dynamodb" {
  type        = string
  description = "Name of key-value-store"
}