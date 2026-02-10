output "alb_dns_name" { value = module.alb.alb_dns_name }
output "rds_endpoint" { value = module.rds.rds_endpoint }
output "jenkins_public_ip" { value = module.jenkins.jenkins_public_ip }

output "ecr_url" {
  description = "ECR repository URL"
  value       = module.ecr.ecr_repository_url
}
