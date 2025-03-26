resource "aws_iam_role" "iam_nodes" {
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

resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  ])

  policy_arn = each.value
  role       = aws_iam_role.iam_nodes.name
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


