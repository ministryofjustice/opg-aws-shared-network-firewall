resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_range
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "shared-network-firewall-${var.account.account_name}-vpc" }
  region               = var.region
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = ["AmazonProvidedDNS"]
  region              = var.region
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
  vpc_id          = aws_vpc.main.id
  region          = var.region
}
