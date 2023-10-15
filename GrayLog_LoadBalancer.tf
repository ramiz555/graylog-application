# Create an Application Load Balancer
resource "aws_lb" "Graylog_alb" {
  name                       = local.alb_name
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = aws_subnet.public_subnets[*].id
  security_groups            = [aws_security_group.graylog_albsecurity_group.id]
  enable_deletion_protection = false
}

# Create alb security group
resource "aws_security_group" "graylog_albsecurity_group" {
  name        = local.alb_sg_name
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc.id

  # Ingress rule to allow all traffic from 10.1.0.0/16
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Egress rule
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a Target Group
resource "aws_lb_target_group" "graylog_target_group" {
  name        = local.alb_tg
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
}

# Create a Listener and connect it to the Target Group
resource "aws_lb_listener" "Graylog_listener" {
  load_balancer_arn = aws_lb.Graylog_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.graylog_target_group.arn
  }
}