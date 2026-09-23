terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "terraform_test" {
  bucket_prefix = "devops-terraform-security-test-"


}

resource "aws_kms_key" "terraform_test" {
  description         = "KMS key for Terraform S3 security test"
  enable_key_rotation = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_test" {
  bucket = aws_s3_bucket.terraform_test.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      # kms_master_key_id = aws_kms_key.terraform_test.arn
    }
  }
}

resource "aws_s3_bucket_versioning" "terraform_test" {
  bucket = aws_s3_bucket.terraform_test.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_test" {
  bucket = aws_s3_bucket.terraform_test.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_arn" {
  value = data.aws_caller_identity.current.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_test.id
}