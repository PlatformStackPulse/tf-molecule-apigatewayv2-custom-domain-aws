# Molecule: API Gateway V2 (WebSocket/HTTP) Custom Domain + Mapping + Route53

resource "aws_apigatewayv2_domain_name" "this" {
  count = module.this.enabled ? 1 : 0

  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = var.endpoint_type
    security_policy = var.security_policy
  }

  tags = module.this.tags
}

resource "aws_apigatewayv2_api_mapping" "this" {
  count = module.this.enabled ? 1 : 0

  api_id      = var.api_id
  domain_name = aws_apigatewayv2_domain_name.this[0].id
  stage       = var.stage_name
}

resource "aws_route53_record" "this" {
  count = module.this.enabled ? 1 : 0

  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = true
  }
}
