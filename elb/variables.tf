#ALL VARIABLES FOR CLOUDWATCH METRIC ALARM

variable "create_metric_alarm" {
  description = "Whether to create the Cloudwatch metric alarm"
  type        = bool
  default     = true
}

variable "alarm_name" {
  description = "The descriptive name for the alarm. This name must be unique within the user's AWS account."
  type        = string
  default     = "ELB Unhealthy Host Alarm"
}

variable "alarm_description" {
  description = "The description for the alarm."
  type        = string
  default     = "Number of unhealthy nodes in Target Group"
}

variable "comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  type        = string
  default     = "GreaterThanThreshold"
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  type        = number
  default     = "1"
}

variable "threshold" {
  description = "The value against which the specified statistic is compared."
  type        = number
  default     = "0"
}

variable "unit" {
  description = "The unit for the alarm's associated metric."
  type        = string
  default     = null
}

variable "metric_name" {
  description = "The name for the alarm's associated metric. See docs for supported metrics."
  type        = string
  default     = "UnHealthyHostCount"
}

variable "namespace" {
  description = "The namespace for the alarm's associated metric. See docs for the list of namespaces. See docs for supported metrics."
  type        = string
  default     = "AWS/ELB"
}

variable "period" {
  description = "The period in seconds over which the specified statistic is applied."
  type        = string
  default     = "60"
}

variable "statistic" {
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  type        = string
  default     = "Maximum"
}

variable "actions_enabled" {
  description = "Indicates whether or not actions should be executed during any changes to the alarm's state. Defaults to true."
  type        = bool
  default     = true
}

variable "datapoints_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm."
  type        = number
  default     = null
}

variable "dimensions" {
  description = "The dimensions for the alarm's associated metric."
  type        = any
  default     = null
}

variable "alarm_actions" {
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN)."
  type        = list(string)
  default     = null
}

variable "insufficient_data_actions" {
  description = "The list of actions to execute when this alarm transitions into an INSUFFICIENT_DATA state from any other state. Each action is specified as an Amazon Resource Name (ARN)."
  type        = list(string)
  default     = null
}

variable "ok_actions" {
  description = "The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Name (ARN)."
  type        = list(string)
  default     = null
}

variable "extended_statistic" {
  description = "The percentile statistic for the metric associated with the alarm. Specify a value between p0.0 and p100."
  type        = string
  default     = null
}

variable "treat_missing_data" {
  description = "Sets how this alarm is to handle missing data points. The following values are supported: missing, ignore, breaching and notBreaching."
  type        = string
  default     = "missing"
}

variable "evaluate_low_sample_count_percentiles" {
  description = "Used only for alarms based on percentiles. If you specify ignore, the alarm state will not change during periods with too few data points to be statistically significant. If you specify evaluate or omit this parameter, the alarm will always be evaluated and possibly change state no matter how many data points are available. The following values are supported: ignore, and evaluate."
  type        = string
  default     = null
}

variable "metric_query" {
  description = "Enables you to create an alarm based on a metric math expression. You may specify at most 20."
  type        = any
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

# NO VARIABLE REQUIRED FOR SNS TOPIC

variable "topic_name"{
  description = "The name of the topic. Topic names must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 256 characters long. For a FIFO (first-in-first-out) topic, the name must end with the .fifo suffix. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix"
  type        = string
  default     = "ELB_Alert_Topic"
}

# ALL REQUIRED VARIABLES FOR SNS TOPIC SUBSCRIPTION

variable "endpoint" {
  description = "Endpoint to send data to. The contents vary with the protocol." #for email it is an email address
  type        = string
  default     = "john.powner.jr@gmail.com"
}

variable "protocol" {
  description = "Protocol to use. Valid values are: sqs, sms, lambda, firehose, and application. Protocols email, email-json, http and https are also valid but partially supported."
  type        = string
  default     = "email"
}

variable "subscription_role_arn" {
  description = "(Required if protocol is firehose) ARN of the IAM role to publish to Kinesis Data Firehose delivery stream. Refer to SNS docs."
  type        = string
  default     = null
}

variable "topic_arn" {
  description = "ARN of the SNS topic to subscribe to."
  type        = string
  default     = null
}


