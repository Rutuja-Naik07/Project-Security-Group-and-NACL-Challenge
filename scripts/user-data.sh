#!/bin/bash
# EC2 user data: installs and starts Apache on Amazon Linux
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
