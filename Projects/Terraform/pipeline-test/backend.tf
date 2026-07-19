terraform {
    backend "s3"{
        bucket = "arahel-tfstate-2026"
        key = "arahel-tfstate-2026/terraform.tfstate"
        encrypt = true
        region = "us-east-1"
        dynamodb_table = "terraform-locks"
    }
}


# resource "aws_s3_bucket" "terraform_backend" {
#     bucket = "arahel-tfstate-2026"

#     tags = {
#        Name = "Project"
# }
# }

# resource "aws_s3_bucket_versioning" "terraform_backend_versioning" {
#   bucket = aws_s3_bucket.terraform_backend.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_dynamodb_table" "terraform_lock" {
#   name         = "terraform-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }