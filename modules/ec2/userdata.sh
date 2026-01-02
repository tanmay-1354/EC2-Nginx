#!/bin/bash
set -e

# Update OS
apt-get update -y

# Install Docker
apt-get install -y docker.io
systemctl enable docker
systemctl start docker

# Install NGINX
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

# Install CloudWatch Agent (CORRECT WAY for Ubuntu)
cd /tmp
wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i amazon-cloudwatch-agent.deb

# Allow ubuntu user to run docker
usermod -aG docker ubuntu
