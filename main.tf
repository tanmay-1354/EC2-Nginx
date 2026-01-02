module "iam" {
  source      = "./modules/iam"
  project     = var.project
  environment = var.environment
}

module "security_groups" {
  source      = "./modules/security-groups"
  vpc_id      = var.vpc_id
  project     = var.project
  environment = var.environment
}

module "ec2" {
  source               = "./modules/ec2"
  private_subnet_ids   = var.private_subnet_ids
  instance_type        = var.instance_type
  ec2_sg_id            = module.security_groups.ec2_sg_id
  iam_instance_profile = module.iam.instance_profile
  project              = var.project
  environment          = var.environment
}

module "alb" {
  source              = "./modules/alb"
  vpc_id              = var.vpc_id
  public_subnet_ids   = var.public_subnet_ids
  alb_sg_id           = module.security_groups.alb_sg_id
  target_instance_ids = module.ec2.instance_ids
  certificate_arn     = var.certificate_arn
  project             = var.project
  environment         = var.environment
}
