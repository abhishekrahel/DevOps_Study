resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = var.private_route_table_id
}

