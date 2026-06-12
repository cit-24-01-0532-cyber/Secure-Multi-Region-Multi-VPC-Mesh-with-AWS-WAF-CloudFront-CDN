variable "name" {
  description = "Name of the WAF Web ACL"
  type        = string
}

variable "description" {
  description = "Description of the WAF Web ACL"
  type        = string
  default     = "Managed by Terraform"
}

variable "scope" {
  description = "Scope of the WAF Web ACL (CLOUDFRONT or REGIONAL)"
  type        = string
  default     = "CLOUDFRONT"

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "Scope must be CLOUDFRONT or REGIONAL."
  }
}

variable "default_action" {
  description = "Default action for the WAF (allow or block)"
  type        = string
  default     = "allow"

  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "Default action must be 'allow' or 'block'."
  }
}

variable "managed_rule_groups" {
  description = "List of AWS managed rule groups to attach"
  type = list(object({
    name                    = string
    priority                = number
    managed_rule_group_name = string
    vendor_name             = string
    override_action         = string
    excluded_rules          = optional(list(string), [])
  }))
  default = []
}

variable "rate_limit_rules" {
  description = "List of rate-limiting rules"
  type = list(object({
    name               = string
    priority           = number
    limit              = number
    aggregate_key_type = string
  }))
  default = []
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
