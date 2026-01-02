# ALB
resource "aws_lb" "this" {
  name               = "${var.project}-${var.environment}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.alb_sg_id]
}

# ======================
# TARGET GROUP EC2-1
# ======================
resource "aws_lb_target_group" "ec2_1" {
  name     = "${var.project}-${var.environment}-tg-ec2-1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "ec2_1" {
  target_group_arn = aws_lb_target_group.ec2_1.arn
  target_id        = var.target_instance_ids[0]
  port             = 80
}

# ======================
# TARGET GROUP EC2-2
# ======================
resource "aws_lb_target_group" "ec2_2" {
  name     = "${var.project}-${var.environment}-tg-ec2-2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "ec2_2" {
  target_group_arn = aws_lb_target_group.ec2_2.arn
  target_id        = var.target_instance_ids[1]
  port             = 80
}

# ======================
# HTTP → HTTPS
# ======================
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# ======================
# HTTPS LISTENER
# ======================
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn  = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      status_code  = "404"
      content_type = "text/plain"
      message_body = "Invalid domain"
    }
  }
}

# ======================
# HOST-BASED ROUTING
# ======================

# EC2-1
resource "aws_lb_listener_rule" "ec2_1_instance" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10
  condition {
    host_header {
      values = ["ec2-instance1.devops-sam.rest"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_1.arn
  }
}

resource "aws_lb_listener_rule" "ec2_1_docker" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 20
  condition {
    host_header {
      values = ["ec2-docker1.devops-sam.rest"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_1.arn
  }
}

# EC2-2
resource "aws_lb_listener_rule" "ec2_2_instance" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 30
  condition {
    host_header {
      values = ["ec2-instance2.devops-sam.rest"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_2.arn
  }
}

resource "aws_lb_listener_rule" "ec2_2_docker" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 40
  condition {
    host_header {
      values = ["ec2-docker2.devops-sam.rest"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_2.arn
  }
}

# ALB entry domains
resource "aws_lb_listener_rule" "alb_instance" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 50
  condition {
    host_header {
      values = ["ec2-alb-instance.devops-sam.rest"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_1.arn
  }
}

resource "aws_lb_listener_rule" "alb_docker" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 60
  condition {
    host_header {
      values = ["ec2-alb-docker.devops-sam.rest"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_1.arn
  }
}
