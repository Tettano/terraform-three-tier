module "vpc" {
  source              = "./modules/vpc"
  cidr_block_main_vpc = var.cidr_block_main_vpc
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id

}

module "igw" {
  source     = "./modules/igw"
  vpc_id     = module.vpc.vpc_id
  depends_on = [module.nat, module.alb, module.ec2-asg]
}

module "nat" {
  source             = "./modules/nat"
  public_subnet_ids  = module.vpc.public_subnet_ids
  public_subnet_tags = module.vpc.vpc_public_tags
  depends_on         = [module.igw]

}

module "rtb" {
  source             = "./modules/rtb"
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.igw.internet-gateway-id
  nat_gateway_ids    = module.nat.nat_gateway_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

}

module "alb" {
  source     = "./modules/alb"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id  = module.sg.alb_sg_id
  depends_on = [module.igw]

}

module "ec2-asg" {
  source     = "./modules/ec2-asg"
  subnet_ids = module.vpc.private_subnet_ids
}

module "rds" {
  source                 = "./modules/rds"
  vpc_security_group_ids = [module.sg.rds_sg_id]
  private_subnet_ids     = module.vpc.private_subnet_ids
  db_credentials         = var.db_credentials
}