output "alb_dns_name" { value = module.alb.alb_dns_name }
output "rds_endpoint" { value = module.rds.rds_endpoint }

output "ecr_url" {
  description = "ECR repository URL"
  value       = module.ecr.ecr_repository_url
}

output "github_runner_instance_id" { value = module.github_runner.runner_instance_id }
output "github_runner_private_ip" { value = module.github_runner.runner_private_ip }
