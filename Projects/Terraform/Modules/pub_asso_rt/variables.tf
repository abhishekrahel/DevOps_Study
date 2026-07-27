variable "public_subnet_ids" {
  description = "List of public subnet IDs to associate with the public route table"
  type        = list(string)
}

variable "public_route_table_id" {
  description = "The ID of the public route table to associate with the public subnets"
  type        = string
}

