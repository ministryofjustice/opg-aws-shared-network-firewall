data "aws_caller_identity" "current" {}

data "aws_region" "current" {
  region = var.region
}

data "aws_availability_zones" "all" {
  state  = "available"
  region = var.region
}

locals {
  availability_zones_count  = length(local.sorted_availability_zones)
  sorted_availability_zones = sort(data.aws_availability_zones.all.zone_ids)
}
