variable "vpc_cidr" {
  type = string
}

variable "availability_zone" {
  type = list(string)
}

variable "pub_subnet_cidr" {
  type = list(string)
}

variable "priv_subnet_cidr" {
  type = list(string)
}



variable "cluster_name" {}
variable "desired_capacity" {
  type = number
}
variable "max_capacity" {
  type = number
}
variable "min_capacity" {
  type = number
}
variable "instance_types" {
  type = list(string)
}

variable "capacity_type" {}
variable "disk_size" {
  type = number
}





