resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${local.project_name}-nat-eip"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "${local.project_name}-nat-gw"
  }

  depends_on = [aws_internet_gateway.main, aws_subnet.public_1, aws_eip.nat_eip]
}
