output "redshift_endpoint" {
  description = "Endpoint do cluster Redshift"
  value       = aws_redshift_cluster.creditflow.endpoint
}

output "redshift_role_arn" {
  description = "ARN da role IAM para acesso ao S3"
  value       = aws_iam_role.redshift_role.arn
}
