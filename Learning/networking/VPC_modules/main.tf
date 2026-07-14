provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}


module "subnet" {
  source = "./modules/subnet"

  vpc_id           = module.vpc.vpc_id
  pub_subnet_cidr  = var.pub_subnet_cidr
  priv_subnet_cidr = var.priv_subnet_cidr
  az               = var.availability_zone

}


module "igw" {

  source = "./modules/igw"

  vpc_id = module.vpc.vpc_id
}

module "eip" {

  source = "./modules/eip"

}

module "nat_gateway" {
  source = "./modules/nat_gateway"

  eip_allocation_id = module.eip.eip_id
  subnet_id         = module.subnet.public_subnet_ids
}

module "pub_route_table" {
  source = "./modules/pub_route_table"

  vpc_id = module.vpc.vpc_id
  igw    = module.igw.igw_id

}

module "priv_route_table" {
  source = "./modules/priv_route_table"

  vpc_id    = module.vpc.vpc_id
  nat_gw_id = module.nat_gateway.nat_gw_id

}

module "pub_asso_rt" {

  source                = "./modules/pub_asso_rt"
  public_subnet_ids     = module.subnet.public_subnet_ids
  public_route_table_id = module.pub_route_table.pub_route_table_id
}

module "priv_asso_rt" {

  source              = "./modules/priv_asso_rt"
  private_subnet_ids  = module.subnet.private_subnet_ids
  private_route_table_id = module.priv_route_table.route_table_id
}















