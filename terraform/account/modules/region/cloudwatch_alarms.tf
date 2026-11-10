resource "aws_cloudwatch_metric_alarm" "dropped_packets_anomaly_detection" {
  for_each                  = aws_networkfirewall_firewall.main
  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.cloudwatch_to_pagerduty.arn]
  alarm_description         = "Anomalies detected for dropped request packets on ${var.account.account_name}-${each.key} network firewall"
  alarm_name                = "${var.account.account_name}-${each.key} Network Firewall dropped requests anomaly"
  comparison_operator       = "GreaterThanUpperThreshold"
  datapoints_to_alarm       = 1
  evaluation_periods        = 1
  insufficient_data_actions = [aws_sns_topic.cloudwatch_to_pagerduty.arn]
  ok_actions                = [aws_sns_topic.cloudwatch_to_pagerduty.arn]
  metric_query {
    account_id  = null
    expression  = "ANOMALY_DETECTION_BAND(m1, 4)"
    id          = "ad1"
    label       = "DroppedPackets (expected)"
    period      = 0
    return_data = true
  }
  metric_query {
    account_id  = null
    expression  = null
    id          = "m1"
    label       = null
    period      = 0
    return_data = true
    metric {
      dimensions = {
        AvailabilityZone = tolist(each.value.firewall_status[0].sync_states)[0].availability_zone
        Engine           = "Stateful"
        FirewallName     = each.value.name
      }
      metric_name = "DroppedPackets"
      namespace   = "AWS/NetworkFirewall"
      period      = 3600
      stat        = "Average"
      unit        = null
    }
  }
  region = var.region
}
