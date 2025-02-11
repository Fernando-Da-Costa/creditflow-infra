module "s3" {
  source = "./modules/s3"

  bucket_names = [
    "creditflow-bronze",
    "creditflow-silver",
    "creditflow-gold"
  ]
  acl            = "private"
  versioning     = true
  lifecycle_rule = true
}
