variable "repo_name" {
  description = "ECR repository"
  type        = string
}

variable "scan_on_push" {
  description = "Enable image scanning"
  type        = bool
  default     = true
}

