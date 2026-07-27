resource "aws_route_table" "priv_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "priv-rt"
  }

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.nat_gw_id
  }
  }








