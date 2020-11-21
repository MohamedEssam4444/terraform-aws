resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id
  tags = {
    "Terraform" : "true"
  }
}
resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
  "Terraform" : "true"
  }
}

resource "aws_elb" "this" {
  name               = "terraform-elb"
  subnets            = var.subnets
  security_groups    = var.security_groups
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
    
}


resource "aws_launch_template" "this" {
  name_prefix   = "launch-template"
  image_id      = var.web_image_id
  instance_type = var.web_instance_type
  vpc_security_group_ids    = var.security_groups
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }

  user_data = filebase64("${path.module}/install_apache.sh")

   monitoring {
    enabled = true
  }
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = "autoscaling-gp"
  max_size                  = var.web_max_size
  min_size                  = var.web_min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.web_desired_capacity
  force_delete              = true
  vpc_zone_identifier       = var.subnets
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}
resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  elb                    = aws_elb.this.id
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "terraform-test"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.id
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  tags = {
    "Terraform" : "true"
  }
}

