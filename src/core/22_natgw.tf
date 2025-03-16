# Creazione di un Elastic IP per il NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${local.project_name}-nat-eip"
  }
}

# Creazione del NAT Gateway e associazione dell'Elastic IP
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "${local.project_name}-nat-gw"
  }

  depends_on = [aws_internet_gateway.main]
}
