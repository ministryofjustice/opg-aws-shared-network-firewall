# opg-terraform-shared-network-firewall
Service for a Centralised Shared Network Firewall: Managed by opg-org-infra &amp; Terraform


# Adding your Service
Add the accounts that you'd like to use the shared firewall in by adding the account ID & VPC CIDR Range to the lists for the relevant shared account  in `terraform/account/terraform.tfvars.json`.

Ensure the rule files are updated with any requirements for access to external services, there are two files, one for Development & one for Production, they are found in the locations below.

#### Development
`terraform/account/modules/region/network_firewall_rules.rules.development`

#### Production
`terraform/account/modules/region/network_firewall_rules.rules.development`


That will make the Shared Firewall available to your accounts.  You can then use the [Firewalled Network Module](https://github.com/ministryofjustice/opg-terraform-aws-firewalled-network) to wire it into your service.
