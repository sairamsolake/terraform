provider "aws" {
 access_key = "Your Access Key"
 secret_key = "Your Secret Key"
 region = "ap-south-1"
}

resource "aws_vpc" "test_vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
   name = "test_vpc"
   }
}

#creating subnets

resource "aws_subnet" "subnet_one" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  cidr_block = "10.10.1.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    name = "subnet_one"
   }
}

resource "aws_subnet" "subnet_two" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  cidr_block = "10.10.2.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    name = "subnet_two"
  }
}

#creating Internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.test_vpc.id}"
}

#Creating Route Table

resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_route_table_association" "public_one" {
  subnet_id = "${aws_subnet.subnet_one.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table_association" "public_two" {
  subnet_id = "${aws_subnet.subnet_two.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

#launce instance

resource "aws_instance" "webserver" {
  ami = "ami-05d2d839d4f73aafb"
  instance_type = "t3.micro"
  subnet_id = "${aws_subnet.subnet_one.id}"
}
