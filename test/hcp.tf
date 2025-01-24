resource "random_pet" "boundary_username" {
  length = 1
}

resource "random_password" "boundary_password" {
  length           = 16
  special          = true
  override_special = "#$%&*:?"
}


resource "hcp_boundary_cluster" "cluster" {
  cluster_id = var.name
  tier       = "Standard"
  username   = random_pet.boundary_username.id
  password   = random_password.boundary_password.result
}