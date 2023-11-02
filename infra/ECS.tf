# cluster do ECS = é o conjunto de máquinas gerenciadas pelo Fargate, onde o código da nossa aplicação vai ser executado.
module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name               = var.ambiente
  
    fargate_capacity_providers = {
        FARGATE = {
         default_capacity_provider_strategy = {
         weight = 100
         }
        }
    }
  cluster_settings = {
    "name": "containerInsights",
    "value": "enabled"
  }
}

# Tasks: colocam a apliacao nas instâncias que vão ser gerenciadas pelo Fargate, dentro desse Clusters.
resource "aws_ecs_task_definition" "Fastfood-API" {
  family                   = "Fastfood-API"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.cargo.arn
  container_definitions = jsonencode(
    [
      {
        "name"      = var.ambiente
        "image"     = "265391989599.dkr.ecr.us-east-1.amazonaws.com/prod:v1"
        "cpu"       = 256
        "memory"    = 512
        "essential" = true
        "portMappings" = [
          {
            "containerPort" = 8000
            "hostPort"      = 8000
          }
        ]
      }
    ]
  )
}


# Service = define qual task deve ser executada dentro de qual cluster.
resource "aws_ecs_service" "Fastfood-API" {
  name            = "Fastfood-API"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.Fastfood-API.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.alvo.arn
    container_name   = var.ambiente
    container_port   = 8000
  }

  network_configuration {
      subnets = module.vpc.private_subnets
      security_groups = [aws_security_group.privado.id]
  }

  capacity_provider_strategy {
      capacity_provider = "FARGATE"
      weight = 1 #100/100
  }
}
