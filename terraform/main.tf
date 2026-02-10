# Data sources and locals (shared)
data "aws_vpc" "default" { default = true }

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "default" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

locals {
  subnets_by_az = { for s in data.aws_subnet.default : s.availability_zone => s.id... }
  alb_subnets   = [for az, ids in local.subnets_by_az : ids[0]]
}

# Modules
module "security" {
  source = "./modules/security"

  vpc_id     = data.aws_vpc.default.id
  #my_ip_cidr = var.my_ip_cidr

  jenkins_allowed_cidrs = var.jenkins_allowed_cidrs
}

module "alb" {
  source = "./modules/alb"

  vpc_id     = data.aws_vpc.default.id
  subnets    = local.alb_subnets
  alb_sg_id  = module.security.alb_sg_id
}

module "rds" {
  source = "./modules/rds"

  db_name    = var.db_name
  db_user    = var.db_user
  db_pass    = var.db_pass
  subnets    = local.alb_subnets
  rds_sg_id  = module.security.rds_sg_id
}

module "asg" {
  source = "./modules/asg"

  ami_id            = data.aws_ami.ubuntu.id
  wp_instance_type  = var.wp_instance_type
  asg_min           = var.asg_min
  asg_desired       = var.asg_desired
  asg_max           = var.asg_max
  subnets           = local.alb_subnets
  wp_sg_id          = module.security.wp_sg_id
  target_group_arn  = module.alb.target_group_arn
  db_host           = module.rds.rds_endpoint
  db_user           = var.db_user
  db_pass           = var.db_pass
  db_name           = var.db_name
  ecr_repository_url = module.ecr.ecr_repository_url

}

module "ecr" {
  source = "./modules/ecr"
}


module "jenkins" {
  source = "./modules/jenkins"

  ami_id                 = data.aws_ami.ubuntu.id
  jenkins_instance_type  = var.jenkins_instance_type
  jenkins_sg_id          = module.security.jenkins_sg_id
  subnet_id              = element(local.alb_subnets, 0)
  #ecr_repo_name = module.ecr.ecr_repo_name
}
