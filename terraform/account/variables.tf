locals {
  account = var.accounts[terraform.workspace]
}

variable "accounts" {
  type = map(
    object({
      account_id                       = string
      account_name                     = string
      account_ids_to_share_firewall_to = list(string)
    })
  )
}
