resource "aws_redshift_cluster" "creditflow" {
  cluster_identifier        = var.cluster_identifier
  database_name             = var.database_name
  master_username           = var.master_username
  master_password           = var.master_password
  node_type                 = var.node_type
  cluster_type              = var.cluster_type
  number_of_nodes           = var.cluster_type == "multi-node" ? var.number_of_nodes : null
  publicly_accessible       = false
  encrypted                 = true
  iam_roles                 = [aws_iam_role.redshift_role.arn]

  tags = {
    Name        = var.cluster_identifier
    Environment = var.environment
  }
}

resource "aws_iam_role" "redshift_role" {
  name               = "redshift_s3_access"
  assume_role_policy = data.aws_iam_policy_document.redshift_assume_role.json
}

data "aws_iam_policy_document" "redshift_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "redshift_s3_access" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
