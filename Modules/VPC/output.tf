output "region" {
    value = var.region  
}

output "wordpress_web" {
    value = var.wordpress_web.id
}

output "vpc_id" {
    value = aws_vpc.my_vpc.id
}

output "public_subnet_az1.id" {
    value = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2.id" {
    value = aws_subnet.public_subnet_az2.id
}

output "private_app_subnet_az1_id" {
    value = aws_subnet.private_app_subnet_az1.id
}

output "private_app_subnet_az2_id" {
    value = aws_subnet.private_app_subnet_az2.id
}

output "private_data_subnet_az1.id" {
    value = aws_subnet.private_data_subnet_az1.id
}

output "private_data_subnet_az2.id" {
    value = aws_subnet.data_subnet_az2.id
}

output "igw" {
    value =aws_internet_gateway.igw
}