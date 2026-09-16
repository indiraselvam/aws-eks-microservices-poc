resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "poc-igw"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = {}
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "poc-nat-1"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "poc-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "poc-private-rt"
  }
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "eks_cluster_attached" {
  name        = "poc-eks-sg"
  description = "poc-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {}
}

resource "aws_security_group" "eks_created" {
  name        = "eks-cluster-sg-poc-eks-408097404"
  description = "EKS created security group applied to ENI that is attached to EKS Control Plane master nodes, as well as any managed workloads."
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol  = "udp"
    from_port = 0
    to_port   = 65535
    self      = true
  }

  ingress {
    protocol        = "tcp"
    from_port       = 30000
    to_port         = 32767
    security_groups = ["sg-0db7f11f4d5574b41"]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 5432
    to_port         = 5432
    security_groups = ["sg-0db7f11f4d5574b41"]
  }

  ingress {
    description = "Allows EFA traffic, which is not matched by CIDR rules."
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    self        = true
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allows EFA traffic, which is not matched by CIDR rules."
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    self        = true
  }

  tags = {
    Name                            = "eks-cluster-sg-poc-eks-408097404"
    "kubernetes.io/cluster/poc-eks" = "owned"
  }

  lifecycle {
    ignore_changes = [tags, tags_all]
  }
}

resource "aws_db_subnet_group" "main" {
  name        = "poc-rds-subnet-group"
  description = "poc-rds-subnet-group"
  subnet_ids  = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
}

resource "aws_db_instance" "main" {
  identifier     = "poc-rds"
  engine         = "postgres"
  engine_version = "18.3"
  instance_class = "db.m5.4xlarge"

  db_name                = "pocdb"
  username               = "postgres"
  port                   = 5432
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.eks_cluster_attached.id, "sg-0650f65309b1a169a"]

  allocated_storage     = 200
  max_allocated_storage = 1000
  storage_type          = "gp3"
  storage_throughput    = 125
  iops                  = 3000
  storage_encrypted     = true
  kms_key_id            = "arn:aws:kms:ap-south-1:926000797128:key/cc3513f3-c913-4bf5-a8ce-ee91ea1c1d54"

  multi_az                  = false
  availability_zone         = "ap-south-1b"
  publicly_accessible       = false
  network_type              = "IPV4"
  customer_owned_ip_enabled = false

  backup_retention_period  = 7
  backup_target            = "region"
  backup_window            = "17:21-17:51"
  maintenance_window       = "sun:07:44-sun:08:14"
  copy_tags_to_snapshot    = true
  delete_automated_backups = true
  skip_final_snapshot      = true
  deletion_protection      = false

  auto_minor_version_upgrade          = true
  ca_cert_identifier                  = "rds-ca-rsa2048-g1"
  engine_lifecycle_support            = "open-source-rds-extended-support-disabled"
  license_model                       = "postgresql-license"
  option_group_name                   = "default:postgres-18"
  parameter_group_name                = "default.postgres18"
  database_insights_mode              = "standard"
  dedicated_log_volume                = false
  iam_database_authentication_enabled = false

  monitoring_interval = 60
  monitoring_role_arn = "arn:aws:iam::926000797128:role/rds-monitoring-role"

  performance_insights_enabled          = true
  performance_insights_kms_key_id       = "arn:aws:kms:ap-south-1:926000797128:key/cc3513f3-c913-4bf5-a8ce-ee91ea1c1d54"
  performance_insights_retention_period = 7

  tags = {}

  lifecycle {
    ignore_changes = [password]
  }
}

resource "aws_eks_cluster" "main" {
  name     = "poc-eks"
  role_arn = "arn:aws:iam::926000797128:role/poc-eks-cluster-role"
  version  = "1.36"

  bootstrap_self_managed_addons = false
  enabled_cluster_log_types     = ["api", "audit", "authenticator"]

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "172.20.0.0/16"

    elastic_load_balancing {
      enabled = false
    }
  }

  upgrade_policy {
    support_type = "STANDARD"
  }

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
    security_group_ids      = [aws_security_group.eks_cluster_attached.id]
    subnet_ids              = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
  }

  zonal_shift_config {
    enabled = false
  }

  tags = {}
}

resource "aws_eks_node_group" "main" {
  cluster_name    = "poc-eks"
  node_group_name = "poc-node-group"
  node_role_arn   = "arn:aws:iam::926000797128:role/poc-EKSNodeRole"
  subnet_ids      = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]

  ami_type        = "AL2023_x86_64_STANDARD"
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t3.medium"]
  disk_size       = 20
  version         = "1.36"
  release_version = "1.36.3-20260903"

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  node_repair_config {
    enabled = false
  }

  tags = {}

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size, release_version]
  }
}
