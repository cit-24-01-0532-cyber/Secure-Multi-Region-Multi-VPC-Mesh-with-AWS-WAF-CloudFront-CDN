variable "name" {
  description = "Name tag for the CloudFront distribution"
  type        = string
}

variable "comment" {
  description = "Comment/description for the distribution"
  type        = string
  default     = ""
}

variable "default_root_object" {
  description = "Default root object (e.g., index.html)"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_All"
}

variable "web_acl_arn" {
  description = "ARN of the WAF Web ACL to associate (optional)"
  type        = string
  default     = null
}

variable "origins" {
  description = "List of origin configurations"
  type = list(object({
    domain_name = string
    origin_id   = string
    custom_origin_config = optional(object({
      http_port              = number
      https_port             = number
      origin_protocol_policy = string
      origin_ssl_protocols   = list(string)
    }))
    s3_origin_config = optional(object({
      origin_access_identity = string
    }))
  }))
}

variable "default_cache_behavior" {
  description = "Default cache behavior configuration"
  type = object({
    allowed_methods        = list(string)
    cached_methods         = list(string)
    target_origin_id       = string
    forward_query_string   = bool
    forward_cookies        = string
    viewer_protocol_policy = string
    min_ttl                = number
    default_ttl            = number
    max_ttl                = number
    compress               = bool
  })
  default = {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "default"
    forward_query_string   = false
    forward_cookies        = "none"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }
}

variable "ordered_cache_behaviors" {
  description = "Additional ordered cache behaviors"
  type = list(object({
    path_pattern           = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    target_origin_id       = string
    forward_query_string   = bool
    forward_cookies        = string
    viewer_protocol_policy = string
    min_ttl                = number
    default_ttl            = number
    max_ttl                = number
    compress               = bool
  }))
  default = []
}

variable "geo_restriction_type" {
  description = "Geo restriction type (none, whitelist, blacklist)"
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "List of country codes for geo restriction"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for custom domain (optional)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
