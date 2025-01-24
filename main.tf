resource "aws_efs_file_system" "worker" {
  creation_token = var.name
}

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
      command = [
        "worker",
        "config",
        "--hcp-cluster-id=${local.boundary_cluster_id}",
        "--public-addr=10.0.0.1",
        "--tags=\"type=ecs,upstream\"",
        "--output=/boundary/efs/worker.hcl"
      ],
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
          name  = "BOUNDARY_SCOPE_ID"
          value = var.boundary_scope_id
        },
      ],
      mountPoints = [
        {
          sourceVolume  = "boundary-worker-config"
          containerPath = "/boundary/efs"
          readOnly      = false
        }
      ]

    }
  ])

  volume {
    name = "boundary-worker-config"
    efs_volume_configuration {
      file_system_id = ""
      root_directory = "/boundary/efs"
      authorization_config {
        access_point_id = ""
        iam             = "ENABLED"
      }
    }
  }
}
