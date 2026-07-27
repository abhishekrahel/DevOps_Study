resource "aws_route_table_association" "pub_asso_rt" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = var.public_route_table_id

}




