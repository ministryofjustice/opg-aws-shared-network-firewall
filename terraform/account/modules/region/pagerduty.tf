data "pagerduty_service" "pagerduty" {
  name = var.account.pagerduty_service_name
}

data "pagerduty_vendor" "cloudwatch" {
  name = "Cloudwatch"
}

resource "pagerduty_service_integration" "cloudwatch_integration" {
  name    = "${data.pagerduty_vendor.cloudwatch.name} ${var.account.account_name} Account"
  service = data.pagerduty_service.pagerduty.id
  vendor  = data.pagerduty_vendor.cloudwatch.id
}

resource "aws_sns_topic" "cloudwatch_to_pagerduty" {
  name   = "CloudWatch-to-PagerDuty-${var.account.account_name}"
  region = var.region
}

resource "aws_sns_topic_subscription" "cloudwatch_sns_subscription" {
  topic_arn              = aws_sns_topic.cloudwatch_to_pagerduty.arn
  protocol               = "https"
  endpoint_auto_confirms = true
  endpoint               = "https://events.pagerduty.com/integration/${pagerduty_service_integration.cloudwatch_integration.integration_key}/enqueue"
}
