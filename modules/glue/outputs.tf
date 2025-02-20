output "glue_database" {
  description = "Nome do database no Glue Data Catalog"
  value       = aws_glue_catalog_database.creditflow_db.name
}

output "glue_crawler_name" {
  description = "Nome do Glue Crawler"
  value       = aws_glue_crawler.creditflow_crawler.name
}

output "glue_job_name" {
  description = "Nome do Glue Job ETL"
  value       = aws_glue_job.creditflow_etl.name
}

output "glue_role_arn" {
  value   = module.iam.glue_role_arn
}



