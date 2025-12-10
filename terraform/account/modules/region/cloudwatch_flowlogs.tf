resource "aws_flow_log" "vpc" {
  log_destination_type     = "cloud-watch-logs"
  log_destination          = aws_cloudwatch_log_group.flow_log.arn
  iam_role_arn             = var.vpc_flow_logs_role.arn
  traffic_type             = "ALL"
  vpc_id                   = aws_vpc.main.id
  max_aggregation_interval = 600
  region                   = var.region
}

resource "aws_cloudwatch_log_group" "flow_log" {
  name              = "/aws/vpc-flow-log/${aws_vpc.main.id}"
  retention_in_days = 400
  kms_key_id        = aws_kms_key.cloudwatch_logs.arn
  region            = var.region
}
