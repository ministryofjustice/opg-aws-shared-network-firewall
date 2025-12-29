resource "aws_cloudwatch_log_group" "network_firewall" {
  name              = "/aws/vendedlogs/network-firewall-flow-log/${aws_vpc.main.id}"
  retention_in_days = 400
  kms_key_id        = aws_kms_key.cloudwatch_logs.arn
  region            = var.region
}

data "aws_iam_policy_document" "network_firewall_log_publishing" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = [aws_cloudwatch_log_group.network_firewall.arn]

    principals {
      identifiers = [data.aws_caller_identity.current.account_id]
      type        = "AWS"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "network_firewall_log_publishing" {
  policy_document = data.aws_iam_policy_document.network_firewall_log_publishing.json
  policy_name     = "network-firewall-log-publishing-policy"
  region          = var.region
}

resource "aws_networkfirewall_logging_configuration" "main" {
  count        = local.availability_zones_count
  firewall_arn = aws_networkfirewall_firewall.main[count.index].arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.network_firewall.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.network_firewall.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.network_firewall.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "TLS"
    }
  }
  region = var.region
}

resource "aws_cloudwatch_query_definition" "network_firewall_logs" {
  name = "Network Firewall Queries/Network Firewall Logs"
  log_group_names = [
    aws_cloudwatch_log_group.network_firewall.name
  ]

  query_string = <<EOF
FIELDS @timestamp AS Time, event.event_type AS Event, event.alert.action AS Action, coalesce(event.http.hostname,event.tls.sni) AS Domain, event.alert.signature AS Message, availability_zone AS AvailabiltyZone, event.proto AS Protocol
| FILTER ispresent(event.alert.action)
| SORT @timestamp DESC
| LIMIT 1000
EOF
  region       = var.region
}

resource "aws_cloudwatch_query_definition" "network_firewall_logs_aggregated" {
  name = "Network Firewall Queries/Network Firewall Logs Aggregated"
  log_group_names = [
    aws_cloudwatch_log_group.network_firewall.name
  ]

  query_string = <<EOF
FIELDS event.event_type AS Event, event.alert.action AS Action, coalesce(event.http.hostname,event.tls.sni) AS Domain, event.alert.signature AS Message, availability_zone AS AvailabiltyZone, event.proto AS Protocol
| FILTER ispresent(event.alert.action)
| STATS COUNT(*) AS NumberOfRequests by Event, Action, Domain, Message, AvailabiltyZone, Protocol
| SORT NumberOfRequests DESC
EOF
  region       = var.region
}
