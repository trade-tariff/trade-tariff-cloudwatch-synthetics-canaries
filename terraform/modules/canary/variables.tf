variable "name" {
  description = "Name of the Canary."
  type        = string
}

variable "file" {
  description = "File to use for the Canary."
  type        = string
}

variable "iam_role_arn" {
  description = "IAM role ARN to associate with the Canary."
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket to use for reports."
  type        = string
}

variable "schedule" {
  description = "`rate` or `cron` expression to give to the Canary."
  type        = string
}
