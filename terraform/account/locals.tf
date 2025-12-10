locals {
  mandatory_moj_tags = {
    application      = "opg-shared-network-firewall"
    business-unit    = "OPG"
    environment-name = terraform.workspace
    is-production    = terraform.workspace == "production" ? true : false
    owner            = "WebOps: opg-webops-community@digital.justice.gov.uk"
  }

  optional_tags = {
    infrastructure-support = "OPG Webops: opg-webops-community@digital.justice.gov.uk"
    source-code            = "https://github.com/ministryofjustice/opg-aws-terraform-shared-network-firewall"
    terraform-managed      = "Managed by Terraform"
  }

  default_tags = merge(local.mandatory_moj_tags, local.optional_tags)
}
