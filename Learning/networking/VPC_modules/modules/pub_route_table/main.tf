resource "aws_route_table" "pub_route_table" {
    vpc_id = var.vpc_id
    
    tags = {
       Name = "pub-rt"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.igw
    }
}

