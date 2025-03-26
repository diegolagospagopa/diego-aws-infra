#
# EKS Node Group
#
resource "aws_eks_node_group" "main_node" {
  cluster_name    = aws_eks_cluster.eks.name
  version         = 1.31
  node_group_name = "${local.eks_name}-nodes"
  node_role_arn   = aws_iam_role.iam_nodes.arn

  subnet_ids = data.aws_subnets.private.ids

  capacity_type  = "ON_DEMAND"
  instance_types = [local.eks_instance_type]

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
    aws_iam_role_policy_attachment.node_policies
  ]
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
