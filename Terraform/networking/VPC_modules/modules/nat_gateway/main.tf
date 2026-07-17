resource "aws_nat_gateway" "nat" {
    allocation_id = var.eip_allocation_id
    subnet_id = var.subnet_id [0]

tags = {
   Name = "nat-gateway"
}
 
}


