locals {
  regions = toset([
    "eu-west-1",
    "eu-west-2"
  ])
}

module "region" {
  for_each = local.regions
  source   = "./modules/region"

  account            = local.account
  region             = each.key
  vpc_flow_logs_role = aws_iam_role.vpc_flow_logs_cloudwatch
}
