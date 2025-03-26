resource "aws_security_group" "cilium_overlay" {
  name        = "${local.eks_name}-cilium-overlay"
  description = "Security Group for Cilium overlay network"
  vpc_id      = data.aws_vpc.core.id

  ingress {
    description = "Allow pod-to-pod traffic via overlay (VXLAN/Cilium)"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Cilium Overlay"
  }
}
