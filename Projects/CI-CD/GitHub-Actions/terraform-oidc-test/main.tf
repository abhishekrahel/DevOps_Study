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

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_test" {
  bucket = aws_s3_bucket.terraform_test.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
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