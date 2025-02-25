variable "cluster_identifier" {
  description = "Identificador do cluster Redshift"
  type        = string
  default     = "creditflow-cluster"
}

variable "database_name" {
  description = "Nome do banco de dados principal"
  type        = string
  default     = "creditflowdb"
}

variable "master_username" {
  description = "Usuário master do Redshift"
  type        = string
  default     = "admin"
}

variable "master_password" {
  description = "Senha do usuário master"
  type        = string
  sensitive   = false
}

variable "node_type" {
  description = "Tipo de nó do Redshift"
  type        = string
  default     = "dc2.large"
}

variable "cluster_type" {
  description = "Tipo de cluster (single/multi-node)"
  type        = string
  default     = "multi-node"
}

variable "number_of_nodes" {
  description = "Número de nós se o cluster for multi-node"
  type        = number
  default     = 2
}

variable "environment" {
  description = "Ambiente de implantação (dev/prod)"
  type        = string
  default     = "dev"
}


###################################### Subnets#########################################################################
variable "subnet_ids" {
  description = "Lista de subnets da VPC"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}
