variable "bucket_names" {
  description = "Lista de nomes dos buckets"
  type        = list(string)
}

variable "acl" {
  description = "Tipo de permissão ACL do bucket"
  type        = string
  default     = "private"
}

variable "versioning" {
  description = "Habilitar versionamento do bucket"
  type        = bool
}

variable "lifecycle_rule" {
  description = "Habilitar regras de ciclo de vida"
  type        = bool
}

variable "environment" {
  description = "Ambiente de implantação (dev/prod)"
  type        = string
  default     = "dev"
}
