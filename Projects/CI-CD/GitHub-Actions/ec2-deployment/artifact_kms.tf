resource "aws_kms_key" "deployment_artifacts" {
  description             = "KMS key for EC2 deployment artifacts"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  tags = {
    Name        = "devops-ec2-artifacts-kms"
    Environment = "dev"
    Purpose     = "Encrypt deployment artifacts"
  }
}

resource "aws_kms_alias" "deployment_artifacts" {
  name          = "alias/devops-ec2-artifacts"
  target_key_id = aws_kms_key.deployment_artifacts.key_id
}