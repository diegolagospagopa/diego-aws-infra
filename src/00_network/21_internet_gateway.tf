resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.core.id

  tags = {
    Name = "${local.project_name}-igw"
  }
}
