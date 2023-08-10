
#Step:01 : Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block                        =var.vpc-cidr_block
  enable_dns_hostnames              = true
  instance_tenancy                  = "default"
  assign_generated_ipv6_cidr_block  = true
  tags = {
    Name = "${var.wordpress_web}-vpc"
  }  
}

# create internet gateway and attach it to vpc

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name= "${var.wordpress_web}-igw"
  }
}

#use data source to get all availabity zone in region
data "aws_availability_zones" "available_zones" {}


#Step:02 create a public subnets az1 

resource "aws_subnet" "public_subnet_az1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zones.name[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "public subnet az1" 
  }
}
resource "aws_subnet" "public_subnet_az2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_az2_cidr
  availability_zone =data.aws_availability_zones.available_zones.name[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "public subnet az2"
  }
}

#Create private  app subnet for  az1
#1.create private app subnet availablity zone 1 a

resource "aws_subnet" "private_app_subnet_az1"{
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_app_subnet_az1_cidr
  availability_zone =data.aws_availability_zones.available_zones.name[0]
  
  tags = {
    Name = "private app subnet az1"
  }
}
#1.create private app subnet availablity zone2 a

resource "aws_subnet" "private_app_subnet_az2"{
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_app_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zones.name[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "private app subnet az2"
  }
}


#Create private data subnet az1

resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block =var.private_data_subnet_az1_cidr 
  availability_zone =data.aws_availability_zones.available_zones.name[0]
  tags = {
    Name = "private data subnet_az1"
  }
}

#Create private data subnet az2

resource "aws_subnet" "data_subnet_az2" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_data_subnet_az2_cidr
  availability_zone =data.aws_availability_zones.available_zones.name[1]
  tags = {
    Name = "private data subnet az2"
  }
}

# create route table 
  resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    
  }
  tags       = {
    Name     = "public route table"
  }
}

#associate public subnet az1 to public route table
resource "aws_route_table_association" "public_subnet_az1_route-table-association" {
 subnet_id            =  aws_subnet.public_subnet_az1.id
 route_table_id       =  aws_route_table.public_route_table.id
}

#associate public subnet az2 to public route table
resource "aws_route_table_association" "public_subnet_az2_route-table-association" {
 subnet_id            =  aws_subnet.public_subnet_az2.id
 route_table_id       =  aws_route_table.public_route_table.id
}
