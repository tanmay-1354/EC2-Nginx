# Fetch latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "this" {
  count = length(var.private_subnet_ids)

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.ec2_sg_id]

  iam_instance_profile = var.iam_instance_profile

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name        = "${var.project}-${var.environment}-ec2-${count.index + 1}"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
