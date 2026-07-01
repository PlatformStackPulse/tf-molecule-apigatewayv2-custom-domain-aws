# Unit Tests — tf-molecule-apigatewayv2-custom-domain-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:      terraform test -test-directory=tests/unit
# Run verbose:   terraform test -test-directory=tests/unit -verbose
#
# Assertions target plan-KNOWN values only (input pass-throughs, resource
# counts, tf-label id). Computed attributes (target_domain_name, hosted_zone_id)
# are unknown under a mock provider and are therefore NOT asserted on.

mock_provider "aws" {}

variables {
  # tf-label identity
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module-required inputs (valid-looking sample values)
  domain_name     = "ws-test-app.example.com"
  certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/11111111-2222-3333-4444-555555555555"
  api_id          = "abc123def4"
  stage_name      = "$default"
  zone_id         = "Z1234567890ABCDEFGHIJ"
}

# ---------------------------------------------------------------------------
# Enabled (default): the domain name, mapping and Route53 record are planned.
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = length(aws_apigatewayv2_domain_name.this) == 1
    error_message = "Expected exactly one aws_apigatewayv2_domain_name when enabled."
  }

  assert {
    condition     = length(aws_apigatewayv2_api_mapping.this) == 1
    error_message = "Expected exactly one aws_apigatewayv2_api_mapping when enabled."
  }

  assert {
    condition     = length(aws_route53_record.this) == 1
    error_message = "Expected exactly one aws_route53_record when enabled."
  }

  assert {
    condition     = output.domain_name == "ws-test-app.example.com"
    error_message = "domain_name output should pass through the configured domain_name."
  }

  assert {
    condition     = aws_apigatewayv2_api_mapping.this[0].stage == "$default"
    error_message = "api_mapping stage should equal the configured stage_name."
  }
}

# ---------------------------------------------------------------------------
# Disabled: no resources are planned and outputs fall back to empty strings.
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_apigatewayv2_domain_name.this) == 0
    error_message = "Expected no aws_apigatewayv2_domain_name when disabled."
  }

  assert {
    condition     = length(aws_route53_record.this) == 0
    error_message = "Expected no aws_route53_record when disabled."
  }

  assert {
    condition     = output.domain_name == ""
    error_message = "domain_name output should be empty when disabled."
  }
}
