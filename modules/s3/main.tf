resource "aws_s3_bucket" "buckets" {
  for_each = toset(var.bucket_names)
  bucket   = each.value

  tags = {
    Name        = each.value
    Environment = var.environment
  }
}

resource "aws_s3_object" "create_folder" {
  bucket  = aws_s3_bucket.buckets["creditflow-bronze"].id
  key     = "scripts/"
  content = ""
}

resource "aws_s3_object" "etl_script" {
  bucket = aws_s3_bucket.buckets["creditflow-bronze"].id
  key    = "scripts/etl_script.py"
  source = "C:/Projetos/creditflow-infra/modules/glue/scripts/etl_script.py"
}


resource "aws_s3_bucket_logging" "logging" {
  for_each      = toset(var.bucket_names)
  bucket        = aws_s3_bucket.buckets[each.key].id
  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "${each.value}/logs/"
}



resource "aws_s3_bucket_versioning" "versioning" {
  for_each = toset(var.bucket_names)
  bucket = aws_s3_bucket.buckets[each.key].id

  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  #for_each = toset(var.bucket_names)
  for_each = toset([for name in var.bucket_names : name if name != "bucket-athena-query-results-fernando"])
  bucket = aws_s3_bucket.buckets[each.key].id

  rule {
    id     = "LifecycleRule"
    status = var.lifecycle_rule ? "Enabled" : "Disabled"

    expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "creditflow-logs"
}

resource "null_resource" "delete_s3_folder" {
  provisioner "local-exec" {
    command = "aws s3 rm s3://bucket-athena-query-results-fernando/teste --recursive"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "aws_s3_object" "create_folder_athena" {
  bucket  = aws_s3_bucket.buckets["bucket-athena-query-results-fernando"].id
  key     = "result_consulta_athena/"
  content = ""
}

resource "aws_s3_object" "create_folder_bronze" {
  bucket  = aws_s3_bucket.buckets["bucket-athena-query-results-fernando"].id
  key     = "bronze/"
  content = ""
}


