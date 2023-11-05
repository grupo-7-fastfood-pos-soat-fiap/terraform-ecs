resource "aws_security_group" "alb" { #rede publica
  name        = "ecs-security-group"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "tcp_alb" { 
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #Recebe de qualquer lugar
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "saida_alb" {
  type              = "egress"
  from_port         = 0 # Reponde a qlqr porta
  to_port           = 0
  protocol          = "-1" #qlqr protocolo
  cidr_blocks       = ["0.0.0.0/0"] #0.0.0.0 - 255.255.255.255
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group" "privado" {
  name        = "privado_ECS"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "alb_ingress" {
  description = "ALB Ingress"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.alb.id # recebe requisicoes apenas da rede publica (do application load balancer)
  security_group_id = aws_security_group.privado.id
}

resource "aws_security_group_rule" "postgres_saida" {
  description = "Postgres Egress"
  type              = "egress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #0.0.0.0 - 255.255.255.255
  security_group_id = aws_security_group.privado.id
}
