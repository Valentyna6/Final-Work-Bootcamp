output "alb_sg_id" { value = aws_security_group.alb_sg.id }
output "wp_sg_id" { value = aws_security_group.wp_sg.id }
output "rds_sg_id" { value = aws_security_group.rds_sg.id }
output "runner_sg_id" { value = aws_security_group.github_runner_sg.id }
