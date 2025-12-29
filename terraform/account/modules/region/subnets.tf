resource "aws_subnet" "firewall" {
  count                           = local.availability_zones_count
  assign_ipv6_address_on_creation = false
  availability_zone_id            = local.sorted_availability_zones[count.index]
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 7, count.index + 45)
  map_public_ip_on_launch         = false
  vpc_id                          = aws_vpc.main.id
  tags                            = { Name = "firewall-${local.sorted_availability_zones[count.index]}" }
  region                          = var.region
}

resource "aws_route_table" "firewall" {
  count  = local.availability_zones_count
  vpc_id = aws_vpc.main.id
  tags   = { Name = "firewall-route-table" }
  region = var.region
}

resource "aws_route_table_association" "firewall" {
  count          = local.availability_zones_count
  subnet_id      = aws_subnet.firewall[count.index].id
  route_table_id = aws_route_table.firewall[count.index].id
  region         = var.region
}
