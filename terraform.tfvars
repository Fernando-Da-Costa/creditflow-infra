cluster_identifier = "example-cluster"
database_name      = "exampledb"
master_username    = "admin"
master_password    = "Password123"
node_type          = "dc2.large"
cluster_type       = "multi-node"
number_of_nodes    = 2

############################################################################################################################

glue_job_name    = "creditflow-etl"
glue_role_arn    = "arn:aws:iam::123456789012:role/AWSGlueServiceRole"
script_location  = "s3://creditflow-bronze/scripts/etl_script.py"
temp_dir         = "s3://creditflow-bronze/temp/"
max_capacity     = 2
worker_type      = "G.1X"
number_of_workers = 5
environment      = "production"

