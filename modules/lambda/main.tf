# Chama o módulo iam
module "iam" {
  source = "../../modules/iam"
}

# # Chama o módulo redshift
# module "redshift" {
#   source                = "../../modules/redshift"
#   # REDSHIFT_DB           = var.database_name
#   # REDSHIFT_USER         = var.master_username
#   # REDSHIFT_PASS         = var.master_password
#     master_passwo#     vpc_id                = var.vpc_id
##     subnet_ids            = var.subnet_idsrd       = var.master_password

# }

resource "aws_lambda_function" "creditflow_lambda" {
  function_name    = "creditflow_lambda"
  role             = module.iam.glue_role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  filename         = "lambda_package.zip"  # Arquivo ZIP contendo o código
  source_code_hash = filebase64sha256("lambda_package.zip")

  environment {
    variables = {
     # REDSHIFT_HOST     = aws_redshift_cluster.creditflow.endpoint
      #REDSHIFT_DB       = module.redshift.REDSHIFT_DB
     # REDSHIFT_USER     = module.redshift.REDSHIFT_USER
      REDSHIFT_PASS     = module.redshift.master_password
      S3_BUCKET         = "bucket-creditflow"
    }
  }
}
