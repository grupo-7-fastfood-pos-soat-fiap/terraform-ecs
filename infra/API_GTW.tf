resource "aws_apigatewayv2_api" "example" {
  name        = "example-api-gtw"
  description = "Exemplo de API Gateway"
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = false
    allow_headers = []
    allow_methods = [
        "GET",
        "HEAD",
        "OPTIONS",
        "POST"
    ]
    allow_origins = ["*"]
    expose_headers = []
    max_age = 0
  }
}

resource "aws_apigatewayv2_vpc_link" "example" {
  name               = "example"
  security_group_ids = [aws_security_group.alb.id]
  subnet_ids         = [
    aws_security_group_rule.alb_ingress.id,
    aws_security_group_rule.tcp_alb.id
  ]

  tags = {
    Usage = "example"
  }
}

resource "aws_apigatewayv2_integration" "example_alb_integration" {
    api_id = aws_lb.alb.id
    credentials_arn  = aws_iam_role.cargo.arn
    description      = "Example with a load balancer"
    integration_type = "HTTP_PROXY"
    integration_uri  = aws_lb_listener.ecs_alb_listener.arn

    integration_method = "ANY"
    connection_type    = "VPC_LINK"
    connection_id      = aws_apigatewayv2_vpc_link.example.id

    request_parameters = {
        "append:header.authforintegration" = "$context.authorizer.authorizerResponse"
        "overwrite:path"                   = "staticValueForIntegration"
  }
}

resource "aws_apitgatewayv2_stage" "example" {
  api_id = aws_apigatewayv2_api.example.id
  stage_name = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_router" "any_route" {
  api_id = aws_apigatewayv2_api.example.id
  route_key = "$default"
}
