import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from pyspark.context import SparkContext

# Função ETL
def etl_process():
    try:
        print("ETL process started...")
        # Adicione seu código de ETL aqui
        print("ETL process completed.")
    except Exception as e:
        print(f"Error during ETL process: {e}")

if __name__ == "__main__":
    etl_process()

    args = getResolvedOptions(sys.argv, ['JOB_NAME'])
    sc = SparkContext()
    glueContext = GlueContext(sc)
    spark = glueContext.spark_session

    # Leitura dos dados do S3
    datasource = glueContext.create_dynamic_frame.from_options(
        connection_type="s3",
        connection_options={"paths": ["s3://creditflow-bronze/dados/"]},
        format="parquet"
    )

    # Transformação de dados
    transformed_data = ApplyMapping.apply(
        frame=datasource,
        mappings=[
            ("id", "string", "id", "string"),
            ("nome", "string", "nome", "string"),
            ("valor_credito", "double", "valor_credito", "double")
        ]
    )

    # Salvando os dados na camada Silver
    glueContext.write_dynamic_frame.from_options(
        frame=transformed_data,
        connection_type="s3",
        connection_options={"path": "s3://creditflow-silver/dados/"},
        format="parquet"
    )

    printss("ETL Finalizado com Sucesso!")
