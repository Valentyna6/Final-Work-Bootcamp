resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = var.jenkins_instance_type
  vpc_security_group_ids = [var.jenkins_sg_id]
  subnet_id              = var.subnet_id

  iam_instance_profile = "Bootcamp-Instance-Profile"

  tags = { Name = "jenkins-ec2" }
}
