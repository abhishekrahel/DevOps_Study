resource "aws_key_pair" "access" {
    key_name = "project_keys"
    public_key = file ("C:/Users/admin/.ssh/id_rsa.pub")
}

