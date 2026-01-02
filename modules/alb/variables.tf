variable "vpc_id" {}
variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_sg_id" {}
variable "target_instance_ids" {
  type = list(string)
}

variable "certificate_arn" {}

variable "project" {}
variable "environment" {}
