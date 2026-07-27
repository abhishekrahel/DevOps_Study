resource "aws_instance" "infra_by_pipeline" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = var.instance_type

  #This forces the use of IMDSv2, which is AWS's more secure metadata service.

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted = true
  }




  tags = {
    Name = "server_by_pipeline_testing_auto_trigger"

  }

}