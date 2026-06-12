###############################################################################
# Root Variables
# Centralized configuration that drives the shared modules. Environment-
# specific values are defined in terraform.tfvars or as defaults here.
###############################################################################

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "secure-mesh"
}

variable "vpc_configs" {
  description = "Map of VPC configurations per environment (eliminates repetitive VPC definitions)"
  type = map(object({
    cidr_block           = string
    public_subnet_cidrs  = list(string)
    private_subnet_cidrs = list(string)
    enable_nat_gateway   = bool
  }))
  default = {
    dev = {
      cidr_block           = "10.0.0.0/16"
      public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
      private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
      enable_nat_gateway   = false
    }
    staging = {
      cidr_block           = "10.1.0.0/16"
      public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
      private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24"]
      enable_nat_gateway   = true
    }
    prod = {
      cidr_block           = "10.2.0.0/16"
      public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24"]
      private_subnet_cidrs = ["10.2.10.0/24", "10.2.11.0/24"]
      enable_nat_gateway   = true
    }
  }
}

variable "availability_zones" {
  description = "Availability zones for subnet placement"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "waf_managed_rules" {
  description = "WAF managed rule groups configuration (shared across distributions)"
  type = list(object({
    name                    = string
    priority                = number
    managed_rule_group_name = string
    vendor_name             = string
    override_action         = string
    excluded_rules          = optional(list(string), [])
  }))
  default = [
    {
      name                    = "aws-common-rules"
      priority                = 1
      managed_rule_group_name = "AWSManagedRulesCommonRuleSet"
      vendor_name             = "AWS"
      override_action         = "none"
      excluded_rules          = []
    },
    {
      name                    = "aws-sqli-rules"
      priority                = 2
      managed_rule_group_name = "AWSManagedRulesSQLiRuleSet"
      vendor_name             = "AWS"
      override_action         = "none"
      excluded_rules          = []
    },
    {
      name                    = "aws-xss-rules"
      priority                = 3
      managed_rule_group_name = "AWSManagedRulesKnownBadInputsRuleSet"
      vendor_name             = "AWS"
      override_action         = "none"
      excluded_rules          = []
    }
  ]
}

variable "waf_rate_limit_rules" {
  description = "Rate limiting rules for WAF"
  type = list(object({
    name               = string
    priority           = number
    limit              = number
    aggregate_key_type = string
  }))
  default = [
    {
      name               = "rate-limit-global"
      priority           = 10
      limit              = 2000
      aggregate_key_type = "IP"
    }
  ]
}
