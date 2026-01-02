region = "ap-south-1"

project     = "EC2-Nginx"
environment = "prod"

vpc_id = "ID-VPC"

private_subnet_ids = [
  "ID-Subnet"
]

public_subnet_ids = [
  "ID-Subnet"
]

instance_type = "t3.micro"

certificate_arn = "ARN-OF-ACM-Certificate"
