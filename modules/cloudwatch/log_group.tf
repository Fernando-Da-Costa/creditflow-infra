resource "aws_cloudwatch_log_group" "glue_job_log_group" {
  name              = "/aws-glue/jobs/output"
  retention_in_days = 1
}
