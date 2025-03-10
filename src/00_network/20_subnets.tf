resource "aws_subnet" "public_1" {
  vpc_id                    = aws_vpc.core.id
  cidr_block                = "10.10.1.0/24"
  availability_zone         = local.south_europe_az1
  map_public_ip_on_launch   = true

  tags = {
    Name = "${local.project_name}-public-1-subnet"
    "kubernetes.io/role/internal-elb"                      = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                    = aws_vpc.core.id
  cidr_block                = "10.10.2.0/24"
  availability_zone         = local.south_europe_az2
  map_public_ip_on_launch   = true

  tags = {
    Name = "${local.project_name}-public-2-subnet"
    "kubernetes.io/role/internal-elb"                      = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id                    = aws_vpc.core.id
  cidr_block                = "10.10.3.0/24"
  availability_zone         = local.south_europe_az1

  tags = {
    Name = "${local.project_name}-private-1-subnet"
    "kubernetes.io/role/internal-elb"                      = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id                    = aws_vpc.core.id
  cidr_block                = "10.10.4.0/24"
  availability_zone         = local.south_europe_az2

  tags = {
    Name = "${local.project_name}-private-2-subnet"
    "kubernetes.io/role/internal-elb"                      = "1"
    "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
  }
}

