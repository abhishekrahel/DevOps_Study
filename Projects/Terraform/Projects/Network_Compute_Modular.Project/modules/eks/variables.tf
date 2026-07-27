variable "cluster_name" {}
variable "private_subnet_ids" {
    type = list(string)
}
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



