variable "private_subnet_ids" {
  description = "List of private subnet IDs to associate with the private route table"
  type        = list(string)
}

variable "private_route_table_id" {
  description = "The ID of the private route table to associate with the private subnets"
  type        = string
}
