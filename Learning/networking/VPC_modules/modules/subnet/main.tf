resource "aws_subnet" "public" {
    count = length(var.pub_subnet_cidr)
    cidr_block = var.pub_subnet_cidr[count.index]
    vpc_id = var.vpc_id
    availability_zone = var.az[count.index]

    tags = {
      Name = "custom-pub-subnet"
}
}
resource "aws_subnet" "private" {
    count = length(var.pub_subnet_cidr)
    cidr_block = var.priv_subnet_cidr[count.index]
    vpc_id = var.vpc_id
    availability_zone = var.az[count.index]

    tags = {
      Name = "custom-priv-subnet"
}
}


