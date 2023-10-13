data "aws_caller_identity" "current" {}

locals {
  file = file("../index.js")
  zip  = "lambda-canary-${sha256(local.file)}.zip"

  account_id = data.aws_caller_identity.current.account_id
}
