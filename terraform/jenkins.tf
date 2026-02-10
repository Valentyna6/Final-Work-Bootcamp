resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.jenkins_instance_type
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  subnet_id              = element(local.alb_subnets, 0)

  iam_instance_profile = "Bootcamp-Instance-Profile"

  tags = { Name = "jenkins-ec2" }
}
