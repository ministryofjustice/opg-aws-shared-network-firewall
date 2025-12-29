resource "aws_subnet" "firewall" {
  for_each                        = local.availability_zones_set
  assign_ipv6_address_on_creation = false
  availability_zone_id            = each.key
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 7, index(data.aws_availability_zones.all.zone_ids, each.key) + 45)
  map_public_ip_on_launch         = false
  vpc_id                          = aws_vpc.main.id
  tags                            = { Name = "firewall-${each.key}" }
  region                          = var.region
}

resource "aws_route_table" "firewall" {
  for_each = local.availability_zones_set
  vpc_id   = aws_vpc.main.id
  tags     = { Name = "firewall-route-table-${each.key}" }
  region   = var.region
}

resource "aws_route_table_association" "firewall" {
  for_each       = local.availability_zones_set
  subnet_id      = aws_subnet.firewall[each.key].id
  route_table_id = aws_route_table.firewall[each.key].id
  region         = var.region
}
