import sys
import boto3
import logging
from awsglue.transforms import ApplyMapping
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from pyspark.context import SparkContext
from pyspark.sql.utils import AnalysisException

# Configuração de logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def etl_process():
    try:
        logger.info("Iniciando ETL...")

        args = getResolvedOptions(sys.argv, ['JOB_NAME'])
        sc = SparkContext()
        glueContext = GlueContext(sc)
        spark = glueContext.spark_session

        # Leitura dos dados do S3
        try:
            datasource = glueContext.create_dynamic_frame.from_options(
                connection_type="s3",
                connection_options={"paths": ["s3://creditflow-bronze/dados/"]},
                format="parquet"
            )
            logger.info("Leitura dos dados concluída.")
        except Exception as e:
            logger.error(f"Erro ao ler do S3: {e}")
            raise

        # Transformação de dados
        try:
            transformed_data = ApplyMapping.apply(
                frame=datasource,
                mappings=[
                    ("id", "string", "id", "string"),
                    ("nome", "string", "nome", "string"),
                    ("valor_credito", "double", "valor_credito", "double")
                ]
            )
            logger.info("Transformação dos dados concluída.")
        except AnalysisException as e:
            logger.error(f"Erro de transformação: {e}")
            raise
        except Exception as e:
            logger.error(f"Erro inesperado na transformação: {e}")
            raise

        # Salvando os dados na camada Silver
        try:
            glueContext.write_dynamic_frame.from_options(
                frame=transformed_data,
                connection_type="s3",
                connection_options={"path": "s3://creditflow-silver/dados/"},
                format="parquet"
            )
            logger.info("Dados salvos na camada Silver com sucesso.")
        except Exception as e:
            logger.error(f"Erro ao escrever no S3: {e}")
            raise

        logger.info("ETL Finalizado com Sucesso!")

    except Exception as e:
        logger.error(f"Falha geral no ETL: {e}")
        sys.exit(1)  # Finaliza com erro


if __name__ == "__main__":
    etl_process()
