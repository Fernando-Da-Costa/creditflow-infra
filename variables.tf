variable "cluster_identifier" {
  description = "Identifier for the Redshift cluster"
  type        = string
}

variable "database_name" {
  description = "Name of the initial database to be created"
  type        = string
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
}

variable "master_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "node_type" {
  description = "The node type to be provisioned"
  type        = string
  default     = "dc2.large"
}

variable "cluster_type" {
  description = "Type of the cluster"
  type        = string
  default     = "multi-node"
}

variable "number_of_nodes" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 2
}
variable "environment" {
  description = "Ambiente de implantação (dev/prod)"
  type        = string
  default     = "dev"
}


########################################################################################################################

variable "glue_job_name" {
  description = "Nome do job no AWS Glue"
  type        = string
}

variable "glue_role_arn" {
  description = "ARN da Role IAM para Glue"
  type        = string
}

variable "script_location" {
  description = "Localização do script no S3"
  type        = string
}

variable "temp_dir" {
  description = "Diretório temporário para o Glue"
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

variable "number_of_workers" {
  description = "Número de workers do Glue"
  type        = number
}

variable "s3_bucket" {
  description = "Bucket S3 onde os dados estão armazenados"
  type        = string
  default     = "creditflow-bronze"

}

# variable "environment" {
#   description = "Ambiente de deploy"
#   type        = string
# }
