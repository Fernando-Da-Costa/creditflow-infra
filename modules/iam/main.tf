resource "aws_iam_role" "glue_role" {
  name                = "GlueS3AccessRole"
  assume_role_policy  = data.aws_iam_policy_document.glue_assume_role.json
}

data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "glue_s3_access" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "aws_iam_policy_document" "glue_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "cloudwatch:PutMetricData"
    ]
    resources = ["arn:aws:logs:*:*:*", "arn:aws:cloudwatch:*:*:*"]
  }
}

resource "aws_iam_role_policy" "glue_policy_attachment" {
  name   = "GlueCloudWatchPolicy"
  role   = aws_iam_role.glue_role.id
  policy = data.aws_iam_policy_document.glue_policy.json
}
