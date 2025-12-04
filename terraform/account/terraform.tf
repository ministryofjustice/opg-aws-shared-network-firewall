terraform {
  backend "s3" {
    bucket       = "opg.terraform.state"
    key          = "opg-terraform-aws-shared-network-firewall/terraform.tfstate"
    encrypt      = true
    region       = "eu-west-1"
    use_lockfile = true
    assume_role = {
      role_arn = "arn:aws:iam::311462405659:role/oidc-opg-shared-network-firewall-management"
    }
  }
}

variable "default_role" {
  default = "oidc-opg-shared-network-firewall-development"
  type    = string
}

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::${local.account.account_id}:role/${var.default_role}"
    session_name = "terraform-session"
  }

  default_tags {
    tags = local.default_tags
  }
}
