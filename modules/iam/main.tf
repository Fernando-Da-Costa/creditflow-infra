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


###################################Permissões ao AWS Glue Service Role para acessar o Glue Catalog.###################################
resource "aws_iam_policy" "glue_policy" {
  name        = "AWSGlueAccessPolicy"
  description = "Permissões para o Glue acessar Glue Catalog e S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:CreateTable",
          "glue:GetTable",
          "glue:GetTables",
          "glue:UpdateTable",
          "glue:CreatePartition",
          "glue:GetPartition",
          "glue:GetPartitions",
          "glue:BatchGetPartition"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::creditflow-bronze",
          "arn:aws:s3:::creditflow-bronze/*",
          "arn:aws:s3:::creditflow-silver",
          "arn:aws:s3:::creditflow-silver/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_policy_attach" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_policy.arn
}


#################incluir as permissões para criar grupos de trabalho no Athena e gravar no bucket S3.##################
resource "aws_iam_policy" "athena_s3_policy" {
  name        = "AthenaS3Policy"
  description = "Permissões para criar WorkGroups no Athena e acessar/gravar no bucket S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "athena:CreateWorkGroup",
          "athena:UpdateWorkGroup",
          "athena:GetWorkGroup",
          "athena:ListWorkGroups",
          "athena:ListTagsForResource"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutBucketPolicy"
        ]
        Resource = [
          "arn:aws:s3:::bucket-athena-query-results-fernando",
          "arn:aws:s3:::bucket-athena-query-results-fernando/*"
        ]
      }
    ]
  })
}

############################################## Associar a um Usuário.##################################################
resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  user       = "terraform"
  policy_arn = aws_iam_policy.athena_s3_policy.arn
}

############################################## Permissões da Lambda.###################################################
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_redshift_s3_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_redshift_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftDataFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}






