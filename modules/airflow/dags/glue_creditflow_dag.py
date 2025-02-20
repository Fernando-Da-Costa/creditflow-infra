from airflow import DAG
from airflow.providers.amazon.aws.operators.glue import GlueJobOperator
from airflow.providers.slack.operators.slack_webhook import SlackWebhookOperator
from airflow.utils.dates import days_ago
from datetime import timedelta

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "start_date": days_ago(1),
    "retries": 3,
    "retry_delay": timedelta(minutes=5),
}

dag = DAG(
    "glue_creditflow_etl",
    default_args=default_args,
    description="Executa um job AWS Glue para ETL",
    schedule_interval="0 12 * * *",
    catchup=False,
)

glue_job = GlueJobOperator(
    task_id="run_glue_job",
    job_name="creditflow_etl_job",
    script_location="s3://creditflow-bronze/scripts/etl_script.py",
    aws_conn_id="aws_default",
    region_name="sa-east-1",
    dag=dag,
)

slack_alert = SlackWebhookOperator(
    task_id="slack_alert",
    slack_webhook_conn_id="slack_conn",
    message="🚨 *ALERTA DE FALHA NO GLUE JOB* 🚨\n\n"
            "⚠️ *Job:* `creditflow_etl_job`\n"
            "🔍 *Erro:* Verifique os logs no Airflow e no AWS CloudWatch.\n"
            "📅 *Data:* {{ ds }}\n"
            "⏰ *Horário:* {{ execution_date }}\n",
    channel="#alerts",
    trigger_rule="one_failed",
    dag=dag,
)

glue_job >> slack_alert
