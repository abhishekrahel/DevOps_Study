module "vpc" {
    source = "Terraform/networking/VPC_modules/modules/vpc"
}



module "eks" {
    source = "Terraform/eks_module"
    
    
    cluster_name       = var.cluster_name
    subnet_ids = var.subnet_ids

    desired_capacity = var.desired_capacity
    max_capacity     = var.max_capacity
    min_capacity     = var.min_capacity

    instance_types = var.instance_types
    capacity_type  = var.capacity_type
    disk_size      = var.disk_size

}

