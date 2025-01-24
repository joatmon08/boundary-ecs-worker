output "boundary_addr" {
  value = hcp_boundary_cluster.cluster.cluster_url
}

output "boundary_username" {
  value = hcp_boundary_cluster.cluster.username
}

output "boundary_password" {
  value     = hcp_boundary_cluster.cluster.password
  sensitive = true
}

output "boundary_password_secret_arn" {
  value = aws_secretsmanager_secret.boundary_password.arn
}

output "ecs_cluster" {
  value = aws_ecs_cluster.cluster.name
}