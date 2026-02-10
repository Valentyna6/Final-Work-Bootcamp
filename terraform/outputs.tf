output "alb_dns_name" { value = aws_lb.wp.dns_name }
output "rds_endpoint" { value = aws_db_instance.wp.address }
#output "rds_endpoint" { value = "wp-bootcamp-db.czazcku22xap.eu-west-1.rds.amazonaws.com"}
output "jenkins_public_ip" { value = aws_instance.jenkins.public_ip }
