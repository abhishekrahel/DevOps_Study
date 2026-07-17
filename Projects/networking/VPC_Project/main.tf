provider "aws" {
  region = "us-east-1"

}

resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "custom-vpc"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "custom-public-subnet-${count.index + 1}"
    Environment = "dev"
  }

}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name        = "custom-private-subnet-${count.index + 1}"
    Environment = "dev"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {

    Name = "custom-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "public-rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "private-rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table_association" "private_rt_association" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "nat-eip"
  }
}


resource "aws_nat_gateway" "nat_gw" {
  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = "nat-gw"
  }
}

