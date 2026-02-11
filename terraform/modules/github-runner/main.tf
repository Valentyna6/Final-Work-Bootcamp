locals {
  runner_user_data = base64encode(templatefile("${path.module}/user_data_github_runner.sh", {
    github_token = var.github_token
    github_repo  = var.github_repo
    runner_name  = var.runner_name
  }))
}

resource "aws_instance" "github_runner" {
  ami                    = var.ami_id
  instance_type          = var.runner_instance_type
  vpc_security_group_ids = [var.runner_sg_id]
  subnet_id              = var.subnet_id
  user_data              = local.runner_user_data
  user_data_replace_on_change = true

  iam_instance_profile = "Bootcamp-Instance-Profile"

  tags = { Name = "github-runner-ec2" }
}
