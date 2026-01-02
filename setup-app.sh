#!/bin/bash
set -e

# Update system
sudo apt update -y

# Install Docker
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# Install NGINX
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Run Docker container (Namaste from Container)
sudo docker run -d \
  --restart always \
  -p 8080:8080 \
  hashicorp/http-echo \
  -listen=:8080 \
  -text="Namaste from Container"

# Create static page for instance response
sudo mkdir -p /var/www/instance
echo "<h1>Hello from Instance</h1>" | sudo tee /var/www/instance/index.html

# NGINX configuration
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80;
    server_name ec2-instance1.devops-sam.rest ec2-instance2.devops-sam.rest ec2-alb-instance.devops-sam.rest;

    root /var/www/instance;
    index index.html;
}

server {
    listen 80;
    server_name ec2-docker1.devops-sam.rest ec2-docker2.devops-sam.rest ec2-alb-docker.devops-sam.rest;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

# Reload NGINX
sudo nginx -t
sudo systemctl reload nginx
