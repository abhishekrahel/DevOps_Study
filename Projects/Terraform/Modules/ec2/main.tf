resource "aws_instance" "server" {
    count = length(var.subnet_ids)
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id     = var.subnet_ids[count.index]
    

    tags = {
        Name = "WebServer-${count.index + 1}"
    }


}
