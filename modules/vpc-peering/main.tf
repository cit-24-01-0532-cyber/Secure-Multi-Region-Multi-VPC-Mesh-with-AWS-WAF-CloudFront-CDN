###############################################################################
# Shared VPC Peering Module
# Reusable module that creates a VPC peering connection between two VPCs and
# sets up routing in both directions. Eliminates duplication across the 3
# peering pairs (dev-staging, dev-prod, staging-prod) in a full-mesh topology.
###############################################################################

resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id
  auto_accept = var.auto_accept

  tags = merge(var.tags, {
    Name = "${var.requester_name}-to-${var.accepter_name}-peering"
    Side = "requester"
  })
}

resource "aws_route" "requester_to_accepter" {
  count = length(var.requester_route_table_ids)

  route_table_id            = var.requester_route_table_ids[count.index]
  destination_cidr_block    = var.accepter_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

resource "aws_route" "accepter_to_requester" {
  count = length(var.accepter_route_table_ids)

  route_table_id            = var.accepter_route_table_ids[count.index]
  destination_cidr_block    = var.requester_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
