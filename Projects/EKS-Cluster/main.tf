module "vpc" {
  source   = "../Terraform/networking/Network_Compute_Modular.Project/modules/vpc"
  vpc_cidr = var.vpc_cidr
}


module "subnet" {
  source = "../Terraform/networking/Network_Compute_Modular.Project/modules/subnet"

  vpc_id           = module.vpc.vpc_id
  pub_subnet_cidr  = var.pub_subnet_cidr
  priv_subnet_cidr = var.priv_subnet_cidr
  az               = var.availability_zone

}


module "igw" {

  source = "../Terraform/networking/Network_Compute_Modular.Project/modules/igw"

  vpc_id = module.vpc.vpc_id
}

module "eip" {

  source = "../Terraform/networking/Network_Compute_Modular.Project/modules/eip"

}

module "nat_gateway" {
  source = "../Terraform/networking/Network_Compute_Modular.Project/modules/nat_gateway"

  eip_allocation_id = module.eip.eip_id
  subnet_id         = module.subnet.public_subnet_ids
}

module "pub_route_table" {
  source = "../Terraform/networking/Network_Compute_Modular.Project/modules/pub_route_table"

  vpc_id = module.vpc.vpc_id
  igw    = module.igw.igw_id

}

module "priv_route_table" {
  source = "../Terraform/networking/Network_Compute_Modular.Project/modules/priv_route_table"

  vpc_id    = module.vpc.vpc_id
  nat_gw_id = module.nat_gateway.nat_gw_id

}

module "pub_asso_rt" {

  source                = "../Terraform/networking/Network_Compute_Modular.Project/modules/pub_asso_rt"
  public_subnet_ids     = module.subnet.public_subnet_ids
  public_route_table_id = module.pub_route_table.pub_route_table_id
}

module "priv_asso_rt" {

  source                 = "../Terraform/networking/Network_Compute_Modular.Project/modules/priv_asso_rt"
  private_subnet_ids     = module.subnet.private_subnet_ids
  private_route_table_id = module.priv_route_table.route_table_id
}

module "security_group" {

  source = "../Terraform/networking/Network_Compute_Modular.Project/modules/security_group"
  vpc_id = module.vpc.vpc_id

}


module "eks" {
  source = "../Terraform/networking/Network_Compute_Modular.Project/modules/eks_module"


  cluster_name       = var.cluster_name
  private_subnet_ids = module.subnet.private_subnet_ids

  desired_capacity = var.desired_capacity
  max_capacity     = var.max_capacity
  min_capacity     = var.min_capacity

  instance_types = var.instance_types
  capacity_type  = var.capacity_type
  disk_size      = var.disk_size

}

