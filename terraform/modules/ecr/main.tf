resource "aws_ecr_repository" "wordpress" {
  name                 = "custom-wordpress"
  image_tag_mutability = "MUTABLE"  # Allows overwriting :latest
  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repo_name" { value = aws_ecr_repository.wordpress.name }
output "ecr_repository_url" { value = aws_ecr_repository.wordpress.repository_url }
