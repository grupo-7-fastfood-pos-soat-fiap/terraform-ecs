resource "aws_lb" "application_load_balancer" {
  name               = "${var.alb_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.application_load_balancer.id]
  subnets            = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
}

resource "aws_lb_listener" "ecs_application_load_balancer_listener" { #Entrada do ALB
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_load_balancer_target_group.arn #Encaminha para o grupo target_group (ECS)
  }
}

resource "aws_lb_target_group" "application_load_balancer_target_group" {
  name        = "${var.tg_name}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id

  health_check {
    path = "/swagger"
  }
}

output "IP" {
  value = aws_lb.application_load_balancer.dns_name
}
