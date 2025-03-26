resource "aws_security_group" "cilium_overlay" {
  name_prefix = "cilium-overlay-"
  description = "Security group for Cilium overlay networking"
  vpc_id      = data.aws_vpc.core.id

  ingress {
    description = "VXLAN overlay"
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    self        = true
  }

  ingress {
    description = "Health checks"
    from_port   = 4240
    to_port     = 4240
    protocol    = "tcp"
    self        = true
  }

  tags = {
    Name = "${local.project_name}-cilium-overlay"
  }
}
