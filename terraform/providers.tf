###############################################################################
# Provider Configuration
# Multi-provider setup with aliasing for cross-region resource orchestration.
# - ap-southeast-1 (Singapore): VPCs and networking resources
# - us-east-1 (N. Virginia): Global WAF scope (required for CloudFront WAF)
###############################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"

  default_tags {
    tags = {
      Project   = "secure-multi-region-mesh"
      ManagedBy = "terraform"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "secure-multi-region-mesh"
      ManagedBy = "terraform"
    }
  }
}
