locals {
  jenkins_user_data = base64encode(templatefile("${path.module}/user_data_jenkins.sh",{}))
}


resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = var.jenkins_instance_type
  vpc_security_group_ids = [var.jenkins_sg_id]
  subnet_id              = var.subnet_id
  user_data = local.jenkins_user_data

  #iam_instance_profile = "Bootcamp-Instance-Profile"

  iam_instance_profile = "Bootcamp-Instance-Profile"

  tags = { Name = "jenkins-ec2" }
}
