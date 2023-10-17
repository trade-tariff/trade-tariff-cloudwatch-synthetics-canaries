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
