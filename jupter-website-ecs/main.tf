#configure aws provider
provider "aws" {
    region    = var.region
    profile   = "terraform-user"
}
#create vpc Module

module "vpc" {
    source                                  = "../Modules/VPC" 
    region                                  = var.region
    project_name                            = var.wordpress_web
    vpc_vpc-cidr_block                      = var.vpc_cidr
    public_subnet-az1_cidr                  = var.public_subnet_az1_cidr
    public_subnet-az2_cidr                  = var.public_subnet_az2_cidr
    private_app_subnet_az1_cidr             = var.private_app_subnet_az1_cidr
    private_app_subnet_az2_cidr             = var.private_app_subnet_az2_cidr
    private_data_subnet_az1_cidr            = var.private_data_subnet_az1_cidr
    private_data_subnet_az2_cidr            = var.private_data_subnet_az2_cidr

}

#create nat gateways
module "nat_gateway" {
    source = "../modules/Nate-gateways"
    public_pulic_subnet_az1_id  = module.vpc.public_pulic_subnet_az1_id
    internet_gateway            = module.vpc.internet_gateway
    pulic_subnet_az2_id         = module.vpc.pulic_subnet_az2_id
    vpc_id                      = module.vpc.vpc_id
    private_app_subnet_az1_id   = module.vpc.private_app_subnet_az1_id
    private_data_subnet_az1_id  = module.vpc.private_data_subnet_az1_id
    private_app_subnet_az2_id   = module.vpc.private_app_subnet_az2_id
    private_data_subnet_az2_id  = module.vpc.private_data_subnet_az2_id  
    
    }

 #create secuirty module

module "secuirty group" {
    source = "../Modules/Security-Groups"
    vpc_id = module.vpc.vpc_id
}

module "ecs_tasks_execution_role" {
    source = "../Modules/ecs-tasks-excution-role"
    wordpress_web = module.vpc.wordpress_web
  
}

