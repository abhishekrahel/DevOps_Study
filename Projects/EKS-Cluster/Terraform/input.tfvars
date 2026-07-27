vpc_cidr          = "10.0.0.0/16"
availability_zone = ["us-east-1a", "us-east-1b"]
pub_subnet_cidr   = ["10.0.1.0/24", "10.0.2.0/24"]
priv_subnet_cidr  = ["10.0.3.0/24", "10.0.4.0/24"]






environment = "dev"
#cluster_name = "rahel-eks-cluster"

desired_capacity = 2
min_capacity     = 1
max_capacity     = 4

instance_types = ["t3.small"]

capacity_type = "ON_DEMAND"

disk_size = 20


#environment = "prod"

