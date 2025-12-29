locals {
  account = var.accounts[terraform.workspace]
}

variable "accounts" {
  type = map(
    object({
      account_id                       = string
      account_name                     = string
      account_ids_to_share_firewall_to = list(string)
      remote_account_cidr_ranges       = list(string)
      vpc_primary_octet                = string
      vpc_secondary_octet              = string
    })
  )
}
