locals {
  wp_user_data = base64encode(templatefile("${path.module}/user_data_wp.sh", { 
    db_host            = var.db_host
    ecr_repository_url = var.ecr_repository_url
    secret_arn         = var.secret_arn
  }))
}

resource "aws_launch_template" "wp" {
  name_prefix   = "wp-lt-"
  image_id      = var.ami_id
  instance_type = var.wp_instance_type

  user_data = local.wp_user_data

  iam_instance_profile {
    name = "Bootcamp-Instance-Profile"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "wp-asg-node"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "wp-asg-node"
    }
  }

  network_interfaces {
    security_groups = [var.wp_sg_id]
  }
}

resource "aws_autoscaling_group" "wp" {
  name                = "wp-asg"
  min_size            = var.asg_min
  desired_capacity    = var.asg_desired
  max_size            = var.asg_max
  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.wp.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 400

  default_instance_warmup = 140


  instance_refresh {
    strategy = "Rolling"   # most common & recommended

    preferences {
      # Healthy percentage during refresh (instance maintenance policy style)
      min_healthy_percentage = 100
      max_healthy_percentage = 200

      # Warmup for instances launched during the refresh
      # (overrides default_instance_warmup if you want different behavior just for refresh)
      instance_warmup = 120   # optional — you can omit if you want to use default_instance_warmup

      # false = replace ALL instances (even ones that already match the new template)
      skip_matching = false
    }

    # Optional: trigger refresh when the launch template changes
    # (very common pattern when using $Latest)
  }

  #instance_refresh {
    #strategy = "Rolling"
    #preferences {
      #min_healthy_percentage = 90          # at least 90% must stay healthy during refresh
      #instance_warmup        = 300         # seconds new instances get to become healthy
      # skip_matching          = false     # optional: default false
      # auto_rollback          = true      # optional: rollback if too many failures
      # }
      #  triggers = ["tag", "launch_template"]  # refresh when launch template or tags change
      #}
}

resource "aws_autoscaling_policy" "wp_cpu" {
  name                   = "wp-cpu-target-70"
  autoscaling_group_name = aws_autoscaling_group.wp.name
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 120

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
    disable_scale_in = false
  }
}
