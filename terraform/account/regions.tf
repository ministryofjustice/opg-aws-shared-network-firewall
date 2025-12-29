locals {
  regions = [
    "eu-west-1",
    "eu-west-2"
  ]
}

module "region" {
  for_each = toset(local.regions)
  source   = "./modules/region"

  account            = local.account
  region             = each.key
  vpc_cidr_range     = "${local.account.vpc_primary_octet}.${tonumber(local.account.vpc_secondary_octet) + index(local.regions, each.key)}.0.0/16"
  vpc_flow_logs_role = aws_iam_role.vpc_flow_logs_cloudwatch
}
