module "vpc" {
  source              = "./modules/vpc"
  cidr_block_main_vpc = var.cidr_block_main_vpc
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
}

module "alb" {
  source     = "./modules/alb"
  vpc_id     = module.vpc.vpc_id
  # This is now a simple list of strings, exactly what the ALB wants
  subnet_ids = module.vpc.public_subnet_ids
}


module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "nat" {
  source = "./modules/nat"
  public_subnet_ids = module.vpc.public_subnet_ids
  public_subnet_tags = module.vpc.vpc_public_tags
}

module "rtb" {
  source         = "./modules/rtb"
  vpc_id         = module.vpc.vpc_id
  igw_id         = module.igw.internet-gateway-id
  nat_gateway_ids = module.nat.nat_gateway_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
}