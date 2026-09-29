data "aws_caller_identity" "current" {}

data "aws_region" "current" {
  region = var.region
}

data "aws_availability_zones" "all" {
  state            = "available"
  exclude_zone_ids = var.excluded_zone_ids
  region           = var.region

}

locals {
  availability_zones_set = toset(data.aws_availability_zones.all.zone_ids)
}
