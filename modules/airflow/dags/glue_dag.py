from airflow import DAG
from airflow.providers.amazon.aws.operators.glue import GlueJobOperator
from airflow.utils.dates import days_ago

# Definição dos argumentos padrão
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "start_date": days_ago(1),
    "retries": 1,
}

# Nome do DAG
dag = DAG(
    "glue_creditflow_etl",
    default_args=default_args,
    description="Executa um job AWS Glue para ETL",
    schedule_interval="0 12 * * *",  # Executa todo dia ao meio-dia
    catchup=False,
)

# Definição do operador Glue
glue_job = GlueJobOperator(
    task_id="run_glue_job",
    job_name="creditflow-etl",  # Nome do Glue Job configurado no Terraform
    script_location="s3://creditflow-bronze/scripts/etl_script.py",
    aws_conn_id="aws_default",  # Conexão AWS configurada no Airflow
    region_name="sa-east-1",  # Alterar para a região desejada
    dag=dag,
)

# Ordem de execução
glue_job
