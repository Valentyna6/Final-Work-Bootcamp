variable "alb_arn_suffix" {
  type        = string
  description = "ARN suffix of the ALB (for CloudWatch metrics)"
}

variable "target_group_arn_suffix" {
  type        = string
  description = "ARN suffix of the ALB target group"
}

variable "asg_name" {
  type        = string
  description = "Name of the Auto Scaling Group"
}

variable "rds_identifier" {
  type        = string
  description = "RDS instance identifier"
}

variable "aws_region" {
  type        = string
  description = "AWS region for dashboard"
}
