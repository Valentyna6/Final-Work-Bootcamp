variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

#variable "my_ip_cidr" {
  #  type = string
  #}

variable "key_name" {
  type    = string
  default = "wp-bootcamp-key"
}


variable "db_name" {
  type    = string
  default = "wordpress"
}

variable "db_user" {
  type    = string
  default = "wordpress"
}

variable "db_pass" {
  type      = string
  sensitive = true
}

variable "wp_instance_type" {
  type    = string
  default = "t3.small"
}

variable "jenkins_instance_type" {
  type    = string
  default = "t3.small"
}

variable "asg_min" {
  type    = number
  default = 2
}

variable "asg_desired" {
  type    = number
  default = 2
}

variable "asg_max" {
  type    = number
  default = 4
}

variable "jenkins_allowed_cidrs" {
  description = "List of CIDR blocks allowed to access Jenkins"
  type        = list(string)
}


variable "github_webhook_cidrs" {
  description = "List of CIDR blocks to allow github webhook"
  type        = list(string)
}
