resource "aws_subnet" "firewall" {
  count                           = 3
  assign_ipv6_address_on_creation = false
  availability_zone               = data.aws_availability_zones.all.names[count.index]
  cidr_block                      = cidrsubnet(aws_vpc.main.cidr_block, 7, count.index + 45)
  map_public_ip_on_launch         = false
  vpc_id                          = aws_vpc.main.id
  tags                            = { Name = "firewall-${data.aws_availability_zones.all.names[count.index]}" }
  region                          = var.region
}

resource "aws_route_table" "firewall" {
  count  = 3
  vpc_id = aws_vpc.main.id
  tags   = { Name = "firewall-route-table" }
  region = var.region
}

resource "aws_route_table_association" "firewall" {
  count          = 3
  subnet_id      = aws_subnet.firewall[count.index].id
  route_table_id = aws_route_table.firewall[count.index].id
  region         = var.region
}
