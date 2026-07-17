resource "aws_instance" "server" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = var.subnet_id
    iam_instance_profile = var.instance_profile_name
    vpc_security_group_ids = [var.security_group_id]

    # associate_public_ip_address = true

    tags = {
        Name = "Hello-server"
    }


}
