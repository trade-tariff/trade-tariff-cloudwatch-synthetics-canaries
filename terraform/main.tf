locals {
  file = file("index.js")
  zip  = "lambda-canary-${sha256(local.file)}.zip"
}

data "archive_file" "lambda_canary_zip" {
  type             = "zip"
  output_path      = local.zip
  output_file_mode = "0666"

  source {
    content  = local.file
    filename = "nodejs/node_modules/canary.js"
  }
}

resource "aws_synthetics_canary" "main" {
  name            = "api-healthcheck"
  handler         = "exports.handler"
  runtime_version = "syn-nodejs-puppeteer-6.0"
  start_canary    = true
  zip_file        = local.zip

  success_retention_period = 2
  failure_retention_period = 7

  schedule {
    expression          = "cron(0 * * * *)" # on the hour, every hour
    duration_in_seconds = 0                 # run once
  }

  run_config {
    timeout_in_seconds = 5
    active_tracing     = false
  }

  depends_on = [
    data.archive_file.lambda_canary_zip
  ]
}
