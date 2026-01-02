variable "private_subnet_ids" {
  type = list(string)
}

variable "instance_type" {}

variable "ec2_sg_id" {}

variable "iam_instance_profile" {}

variable "project" {}
variable "environment" {}
