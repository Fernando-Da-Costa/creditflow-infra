import boto3

def test_redshift_cluster():
    redshift = boto3.client('redshift')
    cluster_id = "creditflow-cluster"

    response = redshift.describe_clusters(ClusterIdentifier=cluster_id)
    cluster_status = response["Clusters"][0]["ClusterStatus"]

    assert cluster_status == "available", f"Cluster {cluster_id} não está disponível!"
