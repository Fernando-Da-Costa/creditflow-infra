resource "aws_s3_bucket" "buckets" {
  for_each = toset(var.bucket_names)
  bucket   = each.value

  tags = {
    Name        = each.value
    Environment = var.environment
  }
}

resource "aws_s3_bucket_logging" "logging" {
  for_each = toset(var.bucket_names)
  bucket = aws_s3_bucket.buckets[each.key].id
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
  for_each = toset(var.bucket_names)
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
