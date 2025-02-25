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
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet.name    # verificar depois
  vpc_security_group_ids    = [aws_security_group.redshift_sg.id]               # verificar depois
  vpc_id = var.vpc_id

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

################################Permissão para Glue Catalog (se necessário)############################################
resource "aws_iam_role_policy_attachment" "redshift_glue_access" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
}

################################ Segurança e Networking VPC e Subnet Group############################################
resource "aws_redshift_subnet_group" "redshift_subnet" {
  name       = "redshift-subnet-group"
  subnet_ids = var.subnet_ids  # Lista de subnets da VPC

  tags = {
    Name = "Redshift Subnet Group"
  }
}

################################ Grupo de Segurança (Security Group - SG)##############################################
resource "aws_security_group" "redshift_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["127.0.0.1/32"]  # Ou a rede que pode acessar
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


################################ Integração com o S3 (COPY e UNLOAD)##################################################
resource "aws_iam_role_policy_attachment" "redshift_s3_full_access" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}





