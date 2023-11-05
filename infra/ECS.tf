# cluster do ECS = é o conjunto de máquinas gerenciadas pelo Fargate, onde o código da nossa aplicação vai ser executado.
module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name  = var.ambiente
  
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
resource "aws_ecs_task_definition" "ecs-task-definition" {
  family                   = "ecs-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  execution_role_arn = "arn:aws:iam::235145177657:role/ecsTaskExecutionRole"
  container_definitions = jsonencode(
    [
      {
        name     = var.ambiente
        image    = "235145177657.dkr.ecr.us-east-1.amazonaws.com/fastfood-api:latest"
        cpu       = 256
        memory    = 512
        essential = true
        portMappings = [
          {
            containerPort = 80
            hostPort      = 80
            protocol      = "tcp"
          }
        ]
      }
    ]
  )
}


# Service = define qual task deve ser executada dentro de qual cluster.
resource "aws_ecs_service" "ecs-svc-3" {
  name            = "ecs-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.ecs-task-definition.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.ambiente
    container_port   = 80
  }

  network_configuration {
    subnets         = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
    security_groups = [aws_security_group.load_balancer.id]
    assign_public_ip = true
  }

  force_new_deployment = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 100
  }
}

# resource "null_resource" "db_setup" {
#   provisioner "local-exec" {

#     command = "psql -h ${var.rds_db_name} -p 5432 -U \"${var.rds_username}\" -d ${var.rds_db_name} -f \"db-init.sql\""

#     environment = {
#       PGPASSWORD = "${var.rds_password}"
#     }
#   }
