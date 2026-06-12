###############################################################################
# Root Outputs
###############################################################################

output "vpc_ids" {
  description = "Map of environment name to VPC ID"
  value       = { for k, v in module.vpc : k => v.vpc_id }
}

output "vpc_cidr_blocks" {
  description = "Map of environment name to VPC CIDR block"
  value       = { for k, v in module.vpc : k => v.vpc_cidr_block }
}

output "peering_connection_ids" {
  description = "Map of peering pair to peering connection ID"
  value       = { for k, v in module.vpc_peering : k => v.peering_connection_id }
}

output "waf_web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = module.waf.web_acl_arn
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.distribution_domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cloudfront.distribution_id
}
