variable "pagerduty_token" {
  type        = string
  description = "The Pagerduty API token"
}

locals {
  account = var.accounts[terraform.workspace]
}

variable "accounts" {
  type = map(
    object({
      account_id                       = string
      account_name                     = string
      account_ids_to_share_firewall_to = list(string)
      pagerduty_service_name           = string
      remote_account_cidr_ranges       = list(string)
      vpc_primary_octet                = string
      vpc_secondary_octet              = string
    })
  )
}
