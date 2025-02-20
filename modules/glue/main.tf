module "iam" {
  source = "../../modules/iam"
}

resource "aws_glue_catalog_database" "creditflow_db" {
  name = var.database_name
}

resource "aws_glue_crawler" "creditflow_crawler" {
  name          =   var.crawler_name
  role          =   module.iam.glue_role_arn
  database_name =   aws_glue_catalog_database.creditflow_db.name
  table_prefix  =   var.table_prefix

  s3_target {
    path = "s3://${var.s3_bucket}/bronze/"
  }
}

resource "aws_glue_job" "creditflow_etl" {
  name     = var.job_name
  role_arn =  module.iam.glue_role_arn

  command {
    script_location = "s3://${var.s3_bucket}/scripts/etl_script.py"
    python_version  = "3"
  }

  max_retries  = 0
  description  = "Este job realiza a extração, transformação e carga de dados para o fluxo de crédito."
  timeout      = 60
  glue_version = "4.0"

  default_arguments = {
    "--job-language"                      = "python"
    "--TempDir"                           = "s3://${var.s3_bucket}/temp/"
    "--enable-metrics"                    = "true"   # Ativa métricas do job
    "--enable-continuous-log-filter"      = "true"   # Ativa filtro contínuo de logs
    "--continuous-log-logGroup"           = "/aws-glue/jobs/output"
    "--enable-cloudwatch-log"             = "true"   # Ativa logs no CloudWatch
    "--job-bookmark-option"               = "job-bookmark-disable"  # Desativa o bookmark do job
    "--enable-glue-datacatalog"           = "true"   # Ativa o Glue Data Catalog
    "--enable-spark-ui"                   = "true"   # Ativa a Spark UI
    "--enable-observability-metrics"      = "true"   # Ativa métricas de observabilidade
    "--enable-continuous-logging"         = "true"   # Ativa logging contínuo no CloudWatch
  }
}


#2. Criar os Crawlers → Para mapear os dados do S3 e atualizar o Glue Catalog.
resource "aws_glue_crawler" "bronze_crawler" {
  name          = "creditflow_bronze_crawler"
  database_name = aws_glue_catalog_database.creditflow_db.name
  role          = module.iam.glue_role_arn

  s3_target {
    path = "s3://creditflow-bronze/"
  }

  schedule = "cron(0 * * * ? *)"  # Executa a cada hora
}

resource "aws_glue_crawler" "silver_crawler" {
  name          =   "creditflow_silver_crawler"
  database_name =   aws_glue_catalog_database.creditflow_db.name
  role          =   module.iam.glue_role_arn

  s3_target {
    path = "s3://creditflow-silver/"
  }

  schedule = "cron(0 * * * ? *)"  # Executa a cada hora
}

#3. Criar os Jobs → Para processar e transformar os dados.
resource "aws_glue_job" "bronze_to_silver" {
  name     = "bronze_to_silver"
  role_arn =  module.iam.glue_role_arn

  command {
    script_location = "s3://creditflow-scripts/bronze_to_silver.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"                = "s3://creditflow-temp/"
    "--enable-metrics"         = "true"
    "--job-bookmark-option"    = "job-bookmark-enable"
  }

  glue_version = "3.0"
  worker_type  = "G.1X"
  number_of_workers = 2
}


