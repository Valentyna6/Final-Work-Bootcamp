variable "ami_id" { 
  type        = string
  description = "AMI ID for the GitHub runner instance"
}

variable "runner_instance_type" { 
  type        = string
  description = "Instance type for GitHub runner"
}

variable "runner_sg_id" { 
  type        = string
  description = "Security group ID for GitHub runner"
}

variable "subnet_id" { 
  type        = string
  description = "Subnet ID where the runner will be launched"
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
