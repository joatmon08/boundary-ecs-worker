variable "boundary_login_secret_arn" {
  type        = string
  description = "AWS Secrets Manager ARN for Boundary login credentials"
}

variable "boundary_addr" {
  type        = string
  description = "Boundary address"
}

variable "boundary_auth_method_id" {
  type        = string
  description = "Boundary auth method ID for password authentication"
}

variable "boundary_scope_id" {
  type        = string
  description = "Boundary scope ID"
}

locals {
  boundary_cluster_id = one(split(".", trimprefix(var.boundary_addr, "http://")))
}