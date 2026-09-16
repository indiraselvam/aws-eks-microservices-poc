# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "poc-eks:external-dns"
resource "aws_eks_addon" "external_dns" {
  addon_name                  = "external-dns"
  addon_version               = "v0.21.0-eksbuild.9"
  cluster_name                = "poc-eks"
  preserve                    = null
  resolve_conflicts_on_create = null
  resolve_conflicts_on_update = null
  service_account_role_arn    = null
  tags                        = {}
  tags_all                    = {}
}

# __generated__ by Terraform from "poc-eks:vpc-cni"
resource "aws_eks_addon" "vpc_cni" {
  addon_name                  = "vpc-cni"
  addon_version               = "v1.22.4-eksbuild.3"
  cluster_name                = "poc-eks"
  preserve                    = null
  resolve_conflicts_on_create = null
  resolve_conflicts_on_update = null
  service_account_role_arn    = null
  tags                        = {}
  tags_all                    = {}
}

# __generated__ by Terraform from "poc-eks:metrics-server"
resource "aws_eks_addon" "metrics_server" {
  addon_name                  = "metrics-server"
  addon_version               = "v0.9.0-eksbuild.10"
  cluster_name                = "poc-eks"
  preserve                    = null
  resolve_conflicts_on_create = null
  resolve_conflicts_on_update = null
  service_account_role_arn    = null
  tags                        = {}
  tags_all                    = {}
}

# __generated__ by Terraform from "poc-eks:eks-pod-identity-agent"
resource "aws_eks_addon" "pod_identity_agent" {
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = "v1.3.10-eksbuild.3"
  cluster_name                = "poc-eks"
  preserve                    = null
  resolve_conflicts_on_create = null
  resolve_conflicts_on_update = null
  service_account_role_arn    = null
  tags                        = {}
  tags_all                    = {}
}

# __generated__ by Terraform from "poc-eks:kube-proxy"
resource "aws_eks_addon" "kube_proxy" {
  addon_name                  = "kube-proxy"
  addon_version               = "v1.36.0-eksbuild.21"
  cluster_name                = "poc-eks"
  preserve                    = null
  resolve_conflicts_on_create = null
  resolve_conflicts_on_update = null
  service_account_role_arn    = null
  tags                        = {}
  tags_all                    = {}
}

# __generated__ by Terraform from "poc-eks:coredns"
resource "aws_eks_addon" "coredns" {
  addon_name                  = "coredns"
  addon_version               = "v1.14.3-eksbuild.16"
  cluster_name                = "poc-eks"
  preserve                    = null
  resolve_conflicts_on_create = null
  resolve_conflicts_on_update = null
  service_account_role_arn    = null
  tags                        = {}
  tags_all                    = {}
}

# __generated__ by Terraform from "poc-eks-cluster-role/arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
resource "aws_iam_role_policy_attachment" "cluster_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "poc-eks-cluster-role"
}

# __generated__ by Terraform from "poc-eks-cluster-role/arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
resource "aws_iam_role_policy_attachment" "cluster_load_balancing" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
  role       = "poc-eks-cluster-role"
}

# __generated__ by Terraform from "poc-eks-cluster-role/arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
resource "aws_iam_role_policy_attachment" "cluster_networking" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  role       = "poc-eks-cluster-role"
}

# __generated__ by Terraform from "poc-eks:eks-node-monitoring-agent"
resource "aws_eks_addon" "node_monitoring_agent" {
  addon_name                  = "eks-node-monitoring-agent"
  addon_version               = "v1.7.1-eksbuild.1"
  cluster_name                = "poc-eks"
  preserve                    = null
  resolve_conflicts_on_create = null
  resolve_conflicts_on_update = null
  service_account_role_arn    = null
  tags                        = {}
  tags_all                    = {}
}

# __generated__ by Terraform from "rds-monitoring-role/arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
resource "aws_iam_role_policy_attachment" "rds_monitoring_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role       = "rds-monitoring-role"
}

# __generated__ by Terraform from "poc-eks-cluster-role/arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicyV2"
resource "aws_iam_role_policy_attachment" "cluster_block_storage" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicyV2"
  role       = "poc-eks-cluster-role"
}

# __generated__ by Terraform from "poc-EKSNodeRole/arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
resource "aws_iam_role_policy_attachment" "node_worker_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "poc-EKSNodeRole"
}

# __generated__ by Terraform from "poc-EKSNodeRole/arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
resource "aws_iam_role_policy_attachment" "node_cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "poc-EKSNodeRole"
}

# __generated__ by Terraform from "poc-EKSNodeRole/arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly"
resource "aws_iam_role_policy_attachment" "node_ecr_public_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly"
  role       = "poc-EKSNodeRole"
}

# __generated__ by Terraform from "poc-eks-cluster-role/arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
resource "aws_iam_role_policy_attachment" "cluster_compute" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
  role       = "poc-eks-cluster-role"
}

# __generated__ by Terraform from "poc-EKSNodeRole/arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
resource "aws_iam_role_policy_attachment" "node_ecr_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "poc-EKSNodeRole"
}

# __generated__ by Terraform from "rds-monitoring-role"
resource "aws_iam_role" "rds_monitoring" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
  description           = null
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "rds-monitoring-role"
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}
}

# __generated__ by Terraform from "poc-eks-cluster-role"
resource "aws_iam_role" "cluster" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = ["sts:AssumeRole", "sts:TagSession"]
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  description           = "Allows the cluster Kubernetes control plane to manage AWS resources on your behalf."
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "poc-eks-cluster-role"
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}
}

# __generated__ by Terraform from "poc-EKSNodeRole"
resource "aws_iam_role" "node" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  description           = null
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "poc-EKSNodeRole"
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}
}
