variable "cidr_block" {
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

