variable "account" {
  type = object({
    account_id                       = string
    account_name                     = string
    account_ids_to_share_firewall_to = list(string)
    remote_account_cidr_ranges       = list(string)
    vpc_primary_octet                = string
    vpc_secondary_octet              = string
  })
}

variable "region" {
  description = "Region to deploy the resources into"
  type        = string
}

variable "vpc_cidr_range" {
  description = "CIDR Range for the VPC in this Region"
  type        = string
}

variable "vpc_flow_logs_role" {
  description = "IAM Role Object for the VPC Flow Logs Role"
  type = object({
    arn = string
  })
}
