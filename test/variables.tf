variable "region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  type    = string
  default = "boundary-ecs-worker-test"
}

variable "hcp_project" {
  type = string
}