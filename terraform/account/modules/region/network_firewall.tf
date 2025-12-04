resource "aws_networkfirewall_firewall" "main" {
  count               = 3
  name                = "shared-network-firewall-${var.account.account_name}-${data.aws_availability_zones.all.names[count.index]}"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.main.arn
  vpc_id              = aws_vpc.main.id
  subnet_mapping {
    subnet_id = aws_subnet.firewall[count.index].id
  }
  region = var.region
}

resource "aws_networkfirewall_firewall_policy" "main" {
  name = "main"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_engine_options {
      rule_order              = "DEFAULT_ACTION_ORDER"
      stream_exception_policy = "DROP"
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.rule_file.arn
    }
  }
  region = var.region
}

locals {
  firewall_rules_file = "${path.module}/network_firewall_rules.rules.${var.account.account_name}"
}

resource "aws_networkfirewall_rule_group" "rule_file" {
  capacity = 100
  name     = "main-${replace(filebase64sha256(local.firewall_rules_file), "/[^[:alnum:]]/", "")}"
  type     = "STATEFUL"
  rules    = file(local.firewall_rules_file)
  lifecycle {
    create_before_destroy = true
  }
  region = var.region
}
