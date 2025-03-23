#aws_lb
resource "aws_lb" "nginx" {
  name               = "prog8830-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_security_group.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  tags = var.resource_tags
}

#aws_lb_target_group
resource "aws_lb_target_group" "nginx_target_group" {
  name     = "nginxtargetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app.id
}

#aws_lb_listerner

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }

  tags = var.resource_tags
}

locals {
  nginx_instances = {
    nginx1 = aws_instance.nginx1.id
    nginx2 = aws_instance.nginx2.id
  }
}

resource "aws_lb_target_group_attachment" "nginx" {
  for_each = local.nginx_instances

  target_group_arn = aws_lb_target_group.nginx_target_group.arn
  target_id        = each.value
  port             = 80
}