output "domain_name" {
  description = "The custom domain name"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name, "")
}

output "target_domain_name" {
  description = "Target domain name for DNS"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name, "")
}

output "hosted_zone_id" {
  description = "Hosted zone ID of the domain"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id, "")
}
