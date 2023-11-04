resource "aws_lb" "alb" {
  name               = "${var.alb_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.subnet.id, aws_subnet.subnet2.id]
}

resource "aws_lb_listener" "ecs_alb_listener" { #Entrada do ALB
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn #Encaminha para o grupo target_group_teste (ECS)
  }
}

resource "aws_lb_target_group" "target_group" {
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
  value = aws_lb.alb2.dns_name
}
