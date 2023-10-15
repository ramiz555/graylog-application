#!/bin/bash
yum install httpd -y
yum update -y
sudo yum install ec2-instance-connect -y
sudo systemctl status amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
echo "Hello Graylog!" > /var/www/html/index.html
systemctl enable httpd
systemctl start httpd