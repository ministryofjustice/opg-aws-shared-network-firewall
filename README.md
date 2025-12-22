# opg-terraform-shared-network-firewall
Service for a Centralised Shared Network Firewall: Managed by opg-org-infra &amp; Terraform


# Adding your Service
Add the accounts that you'd like to use the shared firewall in by adding the account ID & VPC CIDR Range to the lists for the relevant shared account  in `terraform/account/terraform.tfvars.json`.

Ensure the locals (found in: `terraform/account/modules/region/network_firewall_rules.tf`) that define the domains that you want to allow external connectivity to have been updated.  There are are two locals, one for domain prefixes (allowing anything on that domain) and one for fully qualified domain names.

That will make the Shared Firewall available to your accounts.  You can then use the [Firewalled Network Module](https://github.com/ministryofjustice/opg-terraform-aws-firewalled-network) to wire it into your service.
