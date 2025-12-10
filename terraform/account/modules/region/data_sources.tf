data "aws_caller_identity" "current" {}

data "aws_region" "current" {
  region = var.region
}

data "aws_availability_zones" "all" {
  state  = "available"
  region = var.region
}
