output "runner_instance_id" { 
  value       = aws_instance.github_runner.id
  description = "Instance ID of the GitHub runner"
}

output "runner_private_ip" {
  value       = aws_instance.github_runner.private_ip
  description = "Private IP of the GitHub runner"
}
