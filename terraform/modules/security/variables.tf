variable "vpc_id" { type = string }
#variable "my_ip_cidr" { type = string }

variable "jenkins_allowed_cidrs" {
  description = "List of CIDR blocks allowed to access Jenkins (8080)"
  type        = list(string)
}
