resource "aws_instance" "infra_by_pipeline" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = var.instance_type

  tags = {
    Name = "server_by_pipeline"

  }

}