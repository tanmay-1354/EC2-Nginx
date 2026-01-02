variable "region" {}

variable "project" {}
variable "environment" {}

variable "vpc_id" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "instance_type" {}

variable "certificate_arn" {}
