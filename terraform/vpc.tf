# Configuration of AWS

provider "aws" {
  profile = "cloudformation"
  region = "us-east-2"
}

variable "VpcCIDR" {
  default = "10.0.0.0/16"
  description = "VPC CIDR value is used to allocate private ip cidr to VPC"
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

variable "PublicSubnetCIDR" {
  default = "10.0.0.0/28"
  description = "Public subnet ip cidr"
}

variable "PriSubnetCIDR" {
  default = "10.0.0.17/28"
  description = "Private subnet ip cidr"
}

# aws vpc resource configuration https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "appVpc" {
  cidr_block  = "${var.VpcCIDR}"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"
  tags = {
    Name = "ecosoftlk"
    Resource = "VPC"
  }
}

resource "aws_subnet" "appPrivateSubnet" {
  cidr_block = "${var.PriSubnetCIDR}"
  vpc_id = "${aws_vpc.appVpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "ecosoftlk"
    Resource = "private_subnet"
  }
}

resource "aws_subnet" "appPublicSubnet" {
  cidr_block = "${var.PublicSubnetCIDR}"
  vpc_id = "${aws_vpc.appVpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "ecosoftlk"
    Resource = "public_subnet"
  }
}

resource "aws_internet_gateway" "appInternetGateway" {
  vpc_id = "${aws_vpc.appVpc.id}"
  tags = {
    Name = "ecosoftlk"
    Resource = "internet_gateway"
  }
}

resource "aws_eip" "appElasticIp" {
  vpc = true
  depends_on = ["aws_internet_gateway.appInternetGateway"]
}

resource "aws_nat_gateway" "appNatGateway" {
  allocation_id = "${aws_eip.appElasticIp.id}"
  subnet_id = "${aws_subnet.appPublicSubnet.id}"
  tags = {
    Name = "ecosoftlk"
    Resource = "nat_gateway"
  }
}

resource "aws_route_table" "appPrivateRouteTable" {
  vpc_id = "${aws_vpc.appVpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.appNatGateway.id}"
  }
  tags = {
    Name = "ecosoftlk"
    Resource = "private_route_table"
  }
}

resource "aws_route_table" "appPublicRouteTable" {
  vpc_id = "${aws_vpc.appVpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.appInternetGateway.id}"
  }
  tags = {
    Name = "ecosoftlk"
    Resource = "public_route_table"
  }
}

resource "aws_route_table_association" "appPubSubnetTableAssociation" {
  subnet_id = "${aws_subnet.appPublicSubnet.id}"
  route_table_id = "${aws_route_table.appPublicRouteTable.id}"
}

resource "aws_route_table_association" "appPriSubnetTableAssociation" {
  subnet_id = "${aws_subnet.appPrivateSubnet.id}"
  route_table_id = "${aws_route_table.appPrivateRouteTable.id}"
}

resource "aws_security_group" "appSshSecurityGroup" {
  name = "allow-ssh"
  description = "Allowing only ssh to bastion instance"
  vpc_id = "${aws_vpc.appVpc.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ecosoftlk"
    Resource = "security_group"
  }
}

output "VPC" {
  value = "${aws_vpc.appVpc.id}"
  description = "Reference of the created VPC"
}

output "PublicSubnet" {
  value = "${aws_subnet.appPublicSubnet.id}"
  description = "Reference of the Public subnet"
}

