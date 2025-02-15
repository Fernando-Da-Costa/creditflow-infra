import boto3

def test_glue_crawler():
    glue = boto3.client('glue')
    crawler_name = "creditflow_crawler"

    response = glue.get_crawler(Name=crawler_name)
    assert response["Crawler"]["State"] in ["READY", "RUNNING"], "Crawler não está ativo!"

def test_glue_job():
    glue = boto3.client('glue')
    job_name = "creditflow_etl_job"

    response = glue.get_job(JobName=job_name)
    assert response["Job"]["Name"] == job_name, "Job ETL não encontrado!"
