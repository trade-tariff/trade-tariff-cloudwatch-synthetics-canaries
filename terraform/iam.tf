resource "aws_iam_role" "canary_role" {
  name               = "cloudwatch-canary-role"
  assume_role_policy = data.aws_iam_policy_document.canary_assume_role_policy.json
}

resource "aws_iam_policy" "canary_policy" {
  name   = "cloudwatch-canary-policy"
  policy = data.aws_iam_policy_document.canary_role_policy.json
}

resource "aws_iam_role_policy_attachment" "canary_policy_attachment" {
  role       = aws_iam_role.canary_role.name
  policy_arn = aws_iam_policy.canary_policy.arn
}
