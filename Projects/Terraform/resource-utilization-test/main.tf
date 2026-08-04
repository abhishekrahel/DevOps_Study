resource "aws_instance" "resource_utilization_1" {
  ami           = var.ami_id
  instance_type = var.instance_type_1

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name        = "resource-utilization-1"
    Environment = "dev"
    Purpose     = "AI-Resource-Utilization"
  }
}

resource "aws_instance" "resource_utilization_2" {
  ami           = var.ami_id
  instance_type = var.instance_type_2

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name        = "resource-utilization-2"
    Environment = "dev"
    Purpose     = "AI-Resource-Utilization"
  }
}