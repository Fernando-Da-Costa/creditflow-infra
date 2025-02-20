# Chama o módulo S3

module "s3" {
  source = "./modules/s3"

  bucket_names = [
    "creditflow-bronze",
    "creditflow-silver",
    "creditflow-gold"
  ]
  acl            = "private"
  versioning     = true
  lifecycle_rule = true
}
##########################################################################################################################

# Chama o módulo redshift
# module "redshift" {
#   source = "./modules/redshift"
#
#   cluster_identifier = var.cluster_identifier
#   database_name      = var.database_name
#   master_username    = var.master_username
#   master_password    = var.master_password
#   node_type          = var.node_type
#   cluster_type       = var.cluster_type
#   number_of_nodes    = var.number_of_nodes
#   environment        = var.environment
# }

##########################################################################################################################
# Chama o módulo Glue

module "glue" {
  source = "./modules/glue"
  s3_bucket           = var.s3_bucket
  max_capacity        = var.max_capacity
  worker_type         = var.worker_type
  number_of_workers   = var.number_of_workers
  environment         = var.environment
  glue_job_name       = var.glue_job_name
  glue_role_arn       = var.glue_role_arn
  script_location     = var.script_location
  temp_dir            = var.temp_dir
}


##########################################################################################################################
# Chama o módulo cloudwatch
module "cloudwatch" {
  source = "./modules/cloudwatch"
}

##########################################################################################################################
# Chama o módulo Athena
module "athena" {
  source = "./modules/athena"
}





