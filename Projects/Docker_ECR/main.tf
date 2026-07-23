provider "aws" {
    region = "us-east-1"
}

module "ecr" {
    source = "./Terraform/networking/Network_Compute_Modular_Project/modules/ecr"
    repo_name = "${var.environment}-nginx-repo"
    scan_on_push = true
}


