import boto3
import psycopg2
import os


def lambda_handler(event, context):
    # Dados do S3
    s3_bucket = os.getenv("S3_BUCKET")

    # Configuração do Redshift
    redshift_host = os.getenv("REDSHIFT_HOST")
    redshift_db = os.getenv("REDSHIFT_DB")
    redshift_user = os.getenv("REDSHIFT_USER")
    redshift_pass = os.getenv("REDSHIFT_PASS")

    # Conectar ao Redshift
    try:
        conn = psycopg2.connect(
            host=redshift_host,
            dbname=redshift_db,
            user=redshift_user,
            password=redshift_pass,
            port=5439
        )
        cursor = conn.cursor()

        # Comando COPY para carregar os dados do S3
        copy_command = f"""
        COPY my_table FROM 's3://{s3_bucket}/data/file.csv'
        IAM_ROLE 'arn:aws:iam::account-id:role/redshift_s3_access'
        CSV IGNOREHEADER 1;
        """

        cursor.execute(copy_command)
        conn.commit()

        return {"status": "success"}

    except Exception as e:
        print("Error:", e)
        return {"status": "error", "message": str(e)}

    finally:
        cursor.close()
        conn.close()
