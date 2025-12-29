resource "aws_ram_resource_share" "firewall" {
  name                      = "shared-network-firewall-${var.account.account_name}-${data.aws_region.current.region}"
  allow_external_principals = false
  permission_arns = [
    "arn:aws:ram::aws:permission/AWSRAMPermissionNetworkFirewallFirewall"
  ]
  region = var.region
}

resource "aws_ram_resource_association" "firewall" {
  count              = local.availability_zones_count
  resource_arn       = aws_networkfirewall_firewall.main[count.index].arn
  resource_share_arn = aws_ram_resource_share.firewall.arn
  region             = var.region
}

resource "aws_ram_principal_association" "example" {
  for_each           = toset(var.account.account_ids_to_share_firewall_to)
  principal          = each.key
  resource_share_arn = aws_ram_resource_share.firewall.arn
  region             = var.region
}
