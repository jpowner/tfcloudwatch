

resource "aws_cloudwatch_metric_alarm" "elb_unhealthyhosts" {
  alarm_name          = var.alarm_name
  alarm_description   = var.alarm_description
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  actions_enabled     = var.actions_enabled
  alarm_actions       = [aws_sns_topic.elb_alert_topic.arn]
  ok_actions          = [aws_sns_topic.elb_alert_topic.arn]
  dimensions          = {
    LoadBalancerName = module.elb.elb_name
  }
}

resource "aws_sns_topic" "elb_alert_topic" {
  name              = var.topic_name
 # kms_master_key_id = "alias/aws/sns" Server-side encryption is available
}

resource "aws_sns_topic_subscription" "elb_alert_subscription" {
  topic_arn = aws_sns_topic.elb_alert_topic.arn
  protocol  = var.protocol
  endpoint  = var.endpoint
}
