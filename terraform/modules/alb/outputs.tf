output "alb_dns_name" { value = aws_lb.wp.dns_name }
output "target_group_arn" { value = aws_lb_target_group.wp.arn }
output "alb_arn_suffix" { value = aws_lb.wp.arn_suffix }
output "target_group_arn_suffix" { value = aws_lb_target_group.wp.arn_suffix }
