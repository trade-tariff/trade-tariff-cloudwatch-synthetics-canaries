locals {
  file = file("../index.js")
  zip  = "lambda-canary-${sha256(local.file)}.zip"

  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}
