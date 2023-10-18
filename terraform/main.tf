module "api_healthcheck" {
  source       = "./modules/canary"
  name         = "api-healthcheck"
  file         = "../healthcheck.js"
  iam_role_arn = aws_iam_role.canary_role.arn
  s3_bucket    = module.canary_reports_bucket.s3_bucket_id
  schedule     = "rate(30 minutes)"
}

module "search_canary" {
  source       = "./modules/canary"
  name         = "search-canary"
  file         = "../search.js"
  iam_role_arn = aws_iam_role.canary_role.arn
  s3_bucket    = module.canary_reports_bucket.s3_bucket_id
  schedule     = "rate(30 minutes)"
}
