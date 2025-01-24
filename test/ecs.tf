resource "aws_kms_key" "ecs" {
  description             = "${var.name}-cluster"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = var.name
}

resource "aws_ecs_cluster" "cluster" {
  name = var.name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.ecs.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs.name
      }
    }
  }
}

resource "aws_secretsmanager_secret" "boundary_password" {
  name_prefix             = var.name
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "boundary_password" {
  secret_id = aws_secretsmanager_secret.boundary_password.id
  secret_string = jsonencode({
    username = hcp_boundary_cluster.cluster.username
    password = hcp_boundary_cluster.cluster.password
  })
}
