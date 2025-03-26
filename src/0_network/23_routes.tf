resource "aws_route_table" "public" {
  vpc_id = aws_vpc.core.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${local.project_name}-public-rt"
  }

  depends_on = [aws_vpc.core, aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.core.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${local.project_name}-private-rt"
  }

  depends_on = [aws_vpc.core, aws_nat_gateway.nat_gw]
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id

  depends_on = [aws_subnet.public_1, aws_route_table.public]
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id

  depends_on = [aws_subnet.public_2, aws_route_table.public]
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id

  depends_on = [aws_subnet.private_1, aws_route_table.private]
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id

  depends_on = [aws_subnet.private_2, aws_route_table.private]
}
