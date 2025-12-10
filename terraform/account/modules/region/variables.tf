variable "account" {
  type = object({
    account_id                       = string
    account_name                     = string
    account_ids_to_share_firewall_to = list(string)
  })
}

variable "region" {
  description = "Region to deploy the resources into"
  type        = string
}

variable "vpc_flow_logs_role" {
  description = "IAM Role Object for the VPC Flow Logs Role"
  type = object({
    arn = string
  })
}
