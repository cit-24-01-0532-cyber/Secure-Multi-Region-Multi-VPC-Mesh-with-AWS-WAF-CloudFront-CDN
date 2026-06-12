variable "requester_vpc_id" {
  description = "VPC ID of the requester (source) VPC"
  type        = string
}

variable "accepter_vpc_id" {
  description = "VPC ID of the accepter (destination) VPC"
  type        = string
}

variable "requester_name" {
  description = "Name/label for the requester VPC (used in tags)"
  type        = string
}

variable "accepter_name" {
  description = "Name/label for the accepter VPC (used in tags)"
  type        = string
}

variable "requester_cidr_block" {
  description = "CIDR block of the requester VPC"
  type        = string
}

variable "accepter_cidr_block" {
  description = "CIDR block of the accepter VPC"
  type        = string
}

variable "requester_route_table_ids" {
  description = "List of route table IDs in the requester VPC to add peering routes"
  type        = list(string)
}

variable "accepter_route_table_ids" {
  description = "List of route table IDs in the accepter VPC to add peering routes"
  type        = list(string)
}

variable "auto_accept" {
  description = "Whether to auto-accept the peering connection (must be same account/region)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
