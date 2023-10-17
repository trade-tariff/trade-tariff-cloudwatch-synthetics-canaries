locals {
  file      = file(var.file)
  file_name = basename(var.file)
  function  = split(".", local.file_name)[0]
  zip       = "lambda-canary-${sha256(local.file_name)}.zip"
}

data "archive_file" "zip" {
  type             = "zip"
  output_path      = local.zip
  output_file_mode = "0666"

  source {
    content  = local.file
    filename = "nodejs/node_modules/${local.file_name}"
  }
}

resource "aws_synthetics_canary" "this" {
  name                 = var.name
  artifact_s3_location = "s3://${var.s3_bucket}/"
  execution_role_arn   = var.iam_role_arn
  handler              = "${local.function}.handler"
  runtime_version      = "syn-nodejs-puppeteer-6.0"
  start_canary         = true
  zip_file             = local.zip

  success_retention_period = 2
  failure_retention_period = 7

  schedule {
    expression          = var.schedule
    duration_in_seconds = 0
  }

  run_config {
    timeout_in_seconds = 30
    active_tracing     = false
  }

  depends_on = [
    data.archive_file.zip
  ]
}

# TODO: add CloudWatch alarm
