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
  # Organizes subnets by AZ and picks one per AZ for the Application Load Balancer
  subnets_by_az = { for s in data.aws_subnet.default : s.availability_zone => s.id... }
  alb_subnets   = [for az, ids in local.subnets_by_az : ids[0]]
}
