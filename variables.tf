variable "domain_name" {
  description = "Custom domain name (e.g., ws-dev-app.xpeeddating.com)"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN"
  type        = string
}

variable "api_id" {
  description = "API Gateway V2 API ID (WebSocket or HTTP)"
  type        = string
}

variable "stage_name" {
  description = "Stage name to map"
  type        = string
}

variable "zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "endpoint_type" {
  description = "Endpoint type"
  type        = string
  default     = "REGIONAL"
}

variable "security_policy" {
  description = "TLS security policy"
  type        = string
  default     = "TLS_1_2"
}
