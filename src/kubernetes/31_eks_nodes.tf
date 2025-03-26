resource "aws_iam_role" "nodes" {
  name = "${local.project_name}-eks-nodes"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
POLICY
}

# This policy now includes AssumeRoleForPodIdentity for the Pod Identity Agent
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

# Add AutoScaling policy attachment
resource "aws_iam_role_policy_attachment" "amazon_eks_autoscaling" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.nodes.name
}

resource "aws_eks_node_group" "main_node" {
  cluster_name    = aws_eks_cluster.core.name
  version         = 1.31
  node_group_name = "${local.eks_name}-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = data.aws_subnets.private.ids

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Add the Cilium security group
  launch_template {
    version = "$Latest"
    name = aws_launch_template.main_nodes.name
  }

  labels = {
    role = "core_node"
    lifecycle = "OnDemand"
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size,
      scaling_config[0].max_size,
      scaling_config[0].min_size
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
    aws_iam_role_policy_attachment.amazon_eks_autoscaling,
  ]
}

# Launch template for the node group
resource "aws_launch_template" "main_nodes" {
  name_prefix   = "${local.eks_name}-node-"
  instance_type = "t3.medium"

  vpc_security_group_ids = [aws_security_group.cilium_overlay.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.eks_name}-node"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# CPU-based autoscaling policy
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "${local.project_name}-cpu-scaling"
  autoscaling_group_name = aws_eks_node_group.main_node.resources[0].autoscaling_groups[0].name
  policy_type           = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 75.0  # Scale when CPU utilization reaches 75%
  }
}
