resource "aws_lb" "alb" {
  name               = "ECS-fastfood"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "http" { #Entrada do ALB
  load_balancer_arn = aws_lb.alb.arn
  port              = "8000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alvo.arn #Encaminha para o grupo alvo (ECS)
  }
}

resource "aws_lb_target_group" "alvo" {
  name        = "ECS-fastfood"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id
}

output "IP" {
  value = aws_lb.alb.dns_name
}
