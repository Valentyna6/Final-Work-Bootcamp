resource "aws_ecr_repository" "wordpress" {
  name                 = "custom-wordpress"
  image_tag_mutability = "MUTABLE"  # Allows overwriting :latest
  image_scanning_configuration {
    scan_on_push = true
  }
}


