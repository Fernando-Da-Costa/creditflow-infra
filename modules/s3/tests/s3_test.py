import boto3

def test_s3_buckets_exist():
    s3 = boto3.client('s3')
    expected_buckets = ["creditflow-bronze", "creditflow-silver", "creditflow-gold", "creditflow-logs"]

    existing_buckets = [bucket["Name"] for bucket in s3.list_buckets()["Buckets"]]

    for bucket in expected_buckets:
        assert bucket in existing_buckets, f"Bucket {bucket} não foi criado corretamente!"
