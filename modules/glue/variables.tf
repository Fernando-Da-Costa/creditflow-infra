variable "database_name" {
  description = "Nome do database no Glue Data Catalog"
  type        = string
  default     = "creditflow_catalog"
}

variable "crawler_name" {
  description = "Nome do Crawler Glue"
  type        = string
  default     = "creditflow_crawler"
}

variable "table_prefix" {
  description = "Prefixo das tabelas criadas pelo crawler"
  type        = string
  default     = "creditflow_"
}

variable "s3_bucket" {
  description = "Bucket S3 onde os dados estão armazenados"
  type        = string
  default     = "creditflow-bronze"

}

variable "job_name" {
  description = "Nome do Job ETL do Glue"
  type        = string
  default     = "creditflow_etl_job"
}

variable "temp_dir" {
  description = "Temporary directory for Glue job"
  type        = string
}

variable "max_capacity" {
  description = "Capacidade máxima do job Glue"
  type        = number
}

variable "worker_type" {
  description = "Tipo de worker do Glue"
  type        = string
}

variable "glue_role_arn" {
  description = "ARN da Role IAM para Glue"
  type        = string
}

variable "number_of_workers" {
  description = "Número de workers do Glue"
  type        = number
}
variable "environment" {
  description = "Ambiente de implantação (dev/prod)"
  type        = string
  default     = "dev"
}

variable "glue_job_name" {
  description = "Nome do job no AWS Glue"
  type        = string
}

variable "script_location" {
  description = "Localização do script no S3"
  type        = string
}
