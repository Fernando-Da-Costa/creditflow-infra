output "bucket_ids" {
  description = "IDs dos buckets criados"
  value       = [for bucket in aws_s3_bucket.buckets : bucket.id]
}
