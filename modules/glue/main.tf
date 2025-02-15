resource "aws_glue_catalog_database" "creditflow_db" {
  name = var.database_name
}

resource "aws_glue_crawler" "creditflow_crawler" {
  name          = var.crawler_name
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.creditflow_db.name
  table_prefix  = var.table_prefix

  s3_target {
    path = "s3://${var.s3_bucket}/bronze/"
  }
}

resource "aws_glue_job" "creditflow_etl" {
  name     = var.job_name
  role_arn = aws_iam_role.glue_role.arn
  #role_arn = "arn:aws:iam::897729099134:role/GlueS3AccessRole"
  #role_arn = module.glue.glue_role_arn

  command {
    script_location = "s3://${var.s3_bucket}/scripts/etl_script.py"
    python_version  = "3"
  }

  max_retries = 2
  timeout     = 60
  glue_version = "3.0"

  default_arguments = {
    "--job-language"     = "python"
    "--TempDir"         = "s3://${var.s3_bucket}/temp/"
  }
}

resource "aws_iam_role" "glue_role" {
  name               = "GlueS3AccessRole"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
}

data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
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
