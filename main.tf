



resource "aws_ecs_task_definition" "worker" {
  family = "boundary-worker"
  container_definitions = jsonencode([
    {
      name         = "boundary-helper"
      image        = "rosemarywang/boundary-helper:latest"
      cpu          = 10
      memory       = 512
      essential    = true
      portMappings = []
      command      = [],
      secrets = [
        {
          name      = "BOUNDARY_USERNAME"
          valueFrom = "${var.boundary_login_secret_arn}:username::"
        },
        {
          name      = "BOUNDARY_PASSWORD"
          valueFrom = "${var.boundary_login_secret_arn}:password::"
        }
      ]
      environment = [
        {
          name  = "BOUNDARY_ADDR"
          value = var.boundary_addr
        },
        {
          name  = "BOUNDARY_AUTH_METHOD_ID"
          value = var.boundary_auth_method_id
        },
        {
          name  = "BOUNDARY_USERNAME"
          value = var.boundary_username
        },
        {
          name  = "BOUNDARY_PASSWORD"
          value = var.boundary_password
        },
        {
          name  = "BOUNDARY_SCOPE_ID"
          value = var.boundary_scope_id
        },
      ]

    },
    {
      name      = "second"
      image     = "service-second"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
    }
  ])
}
