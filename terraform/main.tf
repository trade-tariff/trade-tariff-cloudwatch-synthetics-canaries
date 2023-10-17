data "archive_file" "lambda_canary_zip" {
  type             = "zip"
  output_path      = local.zip
  output_file_mode = "0666"

  source {
    content  = local.file
    filename = "nodejs/node_modules/index.js"
  }
}

resource "aws_synthetics_canary" "api_health_canary" {
  name                 = "api-healthcheck"
  artifact_s3_location = "s3://${module.canary_reports_bucket.s3_bucket_id}/"
  execution_role_arn   = aws_iam_role.canary_role.arn
  handler              = "index.handler"
  runtime_version      = "syn-nodejs-puppeteer-6.0"
  start_canary         = true
  zip_file             = local.zip

  success_retention_period = 2
  failure_retention_period = 7

  schedule {
    expression          = "rate(5 minutes)"
    duration_in_seconds = 0
  }

  run_config {
    timeout_in_seconds = 30
    active_tracing     = false
  }

  depends_on = [
    data.archive_file.lambda_canary_zip
  ]
}

resource "aws_kms_key" "canary_bucket_key" {
  description             = "KMS key for canary reports bucket."
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "this" {
  name          = "alias/canary-s3-bucket-key"
  target_key_id = aws_kms_key.canary_bucket_key.key_id
}

module "canary_reports_bucket" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v3.15.1"

  bucket = "canary-reports-${local.account_id}"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.canary_bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
