locals {
  allowed_domains = [
    "api.notifications.service.gov.uk",
    "api.os.uk",
    "api.yoti.com",
    "database.clamav.net",
    "ddtest.allpay.net",
    "demo.lpa-uid.api.opg.service.justice.gov.uk",
    "development.api.metrics.opg.service.justice.gov.uk",
    "development.lpa-uid.api.opg.service.justice.gov.uk",
    "identity.integration.account.gov.uk",
    "lambda.eu-west-2.amazonaws.com",
    "login.microsoftonline.com",
    "oidc.integration.account.gov.uk",
    "publicapi.payments.service.gov.uk",
    "rds.eu-west-2.amazonaws.com",
    "www.gov.uk",
    "www.ncsc.gov.uk"
  ]
  allowed_prefixed_domains = [
    ".api.opg.service.justice.gov.uk",
    ".dwpcloud.uk",
    ".homeoffice.gov.uk",
    ".lpa-store.api.opg.service.justice.gov.uk",
    ".lpa-uid.api.opg.service.justice.gov.uk",
    ".sirius.opg.service.justice.gov.uk",
    ".uk.experian.com",
    ".digideps.opg.service.justice.gov.uk",
    ".admin.digideps.opg.service.justice.gov.uk"
  ]
}

resource "aws_networkfirewall_rule_group" "rule_file" {
  capacity = 100
  name     = "main-${replace(filebase64sha256("${path.module}/network_firewall_rules.rules.tpl"), "/[^[:alnum:]]/", "")}"
  type     = "STATEFUL"
  rules = templatefile("${path.module}/network_firewall_rules.rules.tpl", {
    allowed_domains          = local.allowed_domains
    allowed_prefixed_domains = local.allowed_prefixed_domains
    }
  )
  lifecycle {
    create_before_destroy = true
  }
  region = var.region
}
