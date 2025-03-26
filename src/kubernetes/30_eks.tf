resource "aws_iam_role" "eks" {
  name = "${local.project_name}-eks"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

#
# ⛴️ EKS Cluster
#
resource "aws_eks_cluster" "eks" {
  name     = local.eks_name
  version  = "1.33"
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = data.aws_subnets.private.ids
  }

  kubernetes_network_config {
    ip_family = "ipv4"
    service_ipv4_cidr = "10.100.0.0/16"
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [aws_iam_role_policy_attachment.eks]
}
