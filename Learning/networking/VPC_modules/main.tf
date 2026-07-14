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


