# Create an Auto Scaling Group
resource "aws_autoscaling_group" "Graylog_asg" {
  name                = local.asg_name
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = [aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id, aws_subnet.private_subnets[2].id]
  launch_template {
    id      = aws_launch_template.Graylog_launch_template.id
    version = "1"
  }
  target_group_arns = [aws_lb_target_group.graylog_target_group.arn]
}

# IAM Role
resource "aws_iam_role" "Graylog_Role" {
  name = local.instance_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "ssm_policy" {
  name       = "SSMPolicyAttachment"
  roles      = [aws_iam_role.Graylog_Role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "s3_policy" {
  name       = "S3PolicyAttachment"
  roles      = [aws_iam_role.Graylog_Role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "ec2_policy" {
  name       = "Ec2PolicyAttachment"
  roles      = [aws_iam_role.Graylog_Role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "ec2service_policy" {
  name       = "Ec2ServicePolicyAttachment"
  roles      = [aws_iam_role.Graylog_Role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

#Create Instance Profile
resource "aws_iam_instance_profile" "Graylog_Instance_Profile" {
  name = local.instance_profile
  role = aws_iam_role.Graylog_Role.name
}

# Create a Launch Template
resource "aws_launch_template" "Graylog_launch_template" {
  name                   = local.launch_template_name
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.Graylog_Security_Group.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.Graylog_Instance_Profile.name
  }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
    }
  }
  user_data = filebase64("script.sh")
}
# Create ec2 security group
resource "aws_security_group" "Graylog_Security_Group" {
  name        = local.asg_security_group_name
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc.id

  # Ingress rule to allow all traffic from 10.1.0.0/16
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  # Egress rule
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}