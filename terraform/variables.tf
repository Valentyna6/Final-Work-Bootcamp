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

variable "wp_instance_type" {
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

variable "db_name" {
  type        = string
  description = "WordPress database name"
}

variable "db_user" {
  type        = string
  description = "WordPress database username"
}

variable "db_pass" {
  type        = string
  sensitive   = true
  description = "WordPress database password"
}




variable "runner_instance_type" {
  type    = string
  default = "t3.small"
}

variable "github_token" {
  type        = string
  sensitive   = true
  description = "GitHub Personal Access Token for runner registration"
}

variable "github_repo" {
  type        = string
  description = "GitHub repository in format owner/repo"
}

variable "runner_name" {
  type        = string
  default     = "aws-ec2-runner"
  description = "Name for the GitHub Actions runner"
}
