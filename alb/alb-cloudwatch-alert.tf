

resource "aws_cloudwatch_metric_alarm" "alb_unhealthyhosts" {
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
  alarm_actions       = [aws_sns_topic.alb_alert_topic.arn]
  ok_actions          = [aws_sns_topic.alb_alert_topic.arn]
  dimensions          = {
    TargetGroup  = module.alb.target_group_arn_suffixes[0] # without indexing this returns a tuple when a string is expected
    LoadBalancer = module.alb.lb_arn_suffix
  }
}

resource "aws_sns_topic" "alb_alert_topic" {
  name              = var.topic_name
 # kms_master_key_id = "alias/aws/sns" Server-side encryption is available
}

resource "aws_sns_topic_subscription" "alb_alert_subscription" {
  topic_arn = aws_sns_topic.alb_alert_topic.arn
  protocol  = var.protocol
  endpoint  = var.endpoint
}