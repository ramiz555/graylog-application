# Terraform Variables

# Local Values
locals {
  vpc_name                    = "Graylog-VPC"
  internet_gateway_name       = "Graylog-internet-gateway"
  public_subnet_name          = "Graylog-public-subnet"
  private_subnet_name         = "Graylog-private-subnet"
  public_route_table_name     = "Graylog-public-route-table"
  private_route_table-1__name = "Graylog-private-route-table-1"
  private_route_table-2__name = "Graylog-private-route-table-2"
  private_route_table-3_name  = "Graylog-private-route-table-3"
  nat_elastic_ip-1_name       = "Graylog-nat-elastic-ip-1"
  nat_elastic_ip-2_name       = "Graylog-nat-elastic-ip-2"
  nat_elastic_ip-3_name       = "Graylog-nat-elastic-ip-3"
  nat_gateway-1_name          = "Graylog-nat-gateway-1"
  nat_gateway-2_name          = "Graylog-nat-gateway-2"
  nat_gateway-3_name          = "Graylog-nat-gateway-3"
  asg_name                    = "Graylog-AutoScaling-Group"
  instance_role               = "Graylog-Role"
  instance_profile            = "Graylog-Instance-Profile"
  asg_security_group_name     = "Graylog-asg-security-group"
  launch_template_name        = "Graylog-launch-template"
  alb_name                    = "Graylog-external-alb"
  alb_tg                      = "Graylog-Target-Group"
  alb_sg_name                 = "Graylog-alb-security-group"
}
# VPC Variables

variable "vpc_cidr" {
  description = "VPC cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_names" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "public_subnet_cidr" {
  description = "Public Subnet cidr values"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidr" {
  description = "Private Subnet cidr values"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

# Launch Template and ASG Variables

variable "ami" {
  description = "ami id"
  type        = string
  default     = "ami-065ab11fbd3d0323d"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  default     = 3
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  default     = 9
}

variable "desired_capacity" {
  description = "The desired number of EC2 Instances in the ASG"
  type        = number
  default     = 3
}