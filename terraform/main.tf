###############################################################################
# Main Configuration
# Uses shared modules to deploy the full-mesh VPC topology without duplicating
# resource blocks. Each environment VPC is created via a single module call
# driven by the vpc_configs variable map.
###############################################################################

locals {
  # Generate all peering pairs for full-mesh topology from the VPC config keys.
  # This eliminates the need to manually define each peering connection.
  env_keys = keys(var.vpc_configs)
  peering_pairs = [
    for pair in setproduct(local.env_keys, local.env_keys) :
    pair if pair[0] < pair[1]
  ]
}

###############################################################################
# VPCs - One module call per environment (no duplicated VPC resource blocks)
###############################################################################

module "vpc" {
  source   = "../modules/vpc"
  for_each = var.vpc_configs

  environment          = each.key
  cidr_block           = each.value.cidr_block
  public_subnet_cidrs  = each.value.public_subnet_cidrs
  private_subnet_cidrs = each.value.private_subnet_cidrs
  availability_zones   = var.availability_zones
  enable_nat_gateway   = each.value.enable_nat_gateway

  tags = {
    Project = var.project_name
  }
}

###############################################################################
# VPC Full-Mesh Peering - Dynamically creates all peering pairs
###############################################################################

module "vpc_peering" {
  source   = "../modules/vpc-peering"
  for_each = { for pair in local.peering_pairs : "${pair[0]}-${pair[1]}" => pair }

  requester_vpc_id     = module.vpc[each.value[0]].vpc_id
  accepter_vpc_id      = module.vpc[each.value[1]].vpc_id
  requester_name       = each.value[0]
  accepter_name        = each.value[1]
  requester_cidr_block = var.vpc_configs[each.value[0]].cidr_block
  accepter_cidr_block  = var.vpc_configs[each.value[1]].cidr_block

  requester_route_table_ids = [
    module.vpc[each.value[0]].public_route_table_id,
    module.vpc[each.value[0]].private_route_table_id,
  ]
  accepter_route_table_ids = [
    module.vpc[each.value[1]].public_route_table_id,
    module.vpc[each.value[1]].private_route_table_id,
  ]

  tags = {
    Project = var.project_name
  }
}

###############################################################################
# WAF - Deployed in us-east-1 for CloudFront (CLOUDFRONT scope)
###############################################################################

module "waf" {
  source = "../modules/waf"
  providers = {
    aws = aws.us_east_1
  }

  name                = "${var.project_name}-cloudfront-waf"
  description         = "WAF for CloudFront distributions - OWASP Top 10 protection"
  scope               = "CLOUDFRONT"
  default_action      = "allow"
  managed_rule_groups = var.waf_managed_rules
  rate_limit_rules    = var.waf_rate_limit_rules

  tags = {
    Project = var.project_name
  }
}

###############################################################################
# CloudFront - Production CDN with WAF association
###############################################################################

module "cloudfront" {
  source = "../modules/cloudfront"

  name        = "${var.project_name}-prod-cdn"
  comment     = "Production CDN for ${var.project_name}"
  web_acl_arn = module.waf.web_acl_arn
  price_class = "PriceClass_200"

  origins = [
    {
      domain_name = "prod-origin.example.com"
      origin_id   = "prod-alb"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  ]

  default_cache_behavior = {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "prod-alb"
    forward_query_string   = false
    forward_cookies        = "none"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  tags = {
    Project     = var.project_name
    Environment = "prod"
  }
}
