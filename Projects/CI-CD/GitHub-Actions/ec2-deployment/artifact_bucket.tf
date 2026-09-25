resource "aws_s3_bucket" "deployment_artifacts" {
  bucket_prefix = "devops-ec2-artifacts-"

  tags = {
    Name        = "devops-ec2-artifacts"
    Environment = "dev"
    Purpose     = "Application deployment artifacts"
  }
}

resource "aws_s3_bucket_public_access_block" "deployment_artifacts" {
  bucket = aws_s3_bucket.deployment_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "deployment_artifacts" {
  bucket = aws_s3_bucket.deployment_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "deployment_artifacts" {
  bucket = aws_s3_bucket.deployment_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.deployment_artifacts.arn
    }

    bucket_key_enabled = true
  }
}