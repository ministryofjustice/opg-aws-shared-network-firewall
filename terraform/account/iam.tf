resource "aws_iam_role" "vpc_flow_logs_cloudwatch" {
  name               = "vpc-flow-log-role-shared-network-firewall-${local.account.account_name}"
  assume_role_policy = data.aws_iam_policy_document.flow_log_cloudwatch_assume_role.json
}

data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    effect = "Allow"

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_logs_cloudwatch" {
  role       = aws_iam_role.vpc_flow_logs_cloudwatch.name
  policy_arn = aws_iam_policy.vpc_flow_logs_cloudwatch.arn
}

resource "aws_iam_policy" "vpc_flow_logs_cloudwatch" {
  name   = "vpc-flow-log-to-cloudwatch-shared-network-firewall${local.account.account_name}"
  policy = data.aws_iam_policy_document.vpc_flow_logs_cloudwatch.json
}

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "vpc_flow_logs_cloudwatch" {
  statement {
    sid = "AWSVPCFlowLogsPushToCloudWatch"

    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}
