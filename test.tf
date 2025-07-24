provider "aws" {
  region     = ""
  access_key = ""
  secret_key = ""
}

# make vpc

resource "aws_vpc" "ducatvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "projectvpc"
  }
}

# make subnet in projectvpc

resource "aws_subnet" "ducatsubnet" {
  vpc_id     = aws_vpc.ducatvpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "projectsubnet"
  }
}

# make SG

resource "aws_security_group" "ducatsg" {
  name        = "ducatsecurity"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.ducatvpc.id

  tags = {
    Name = "projectsg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ducatinbound" {
  security_group_id = aws_security_group.ducatsg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "ducatoutbound" {
  security_group_id = aws_security_group.ducatsg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# make internet gateway

resource "aws_internet_gateway" "ducatigw" {
  vpc_id = aws_vpc.ducatvpc.id

  tags = {
    Name = "projectigw"
  }
}

# make route table

resource "aws_route_table" "ducatrt" {
  vpc_id = aws_vpc.ducatvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ducatigw.id
  }

  tags = {
    Name = "projectrt"
  }
}

# route table association

resource "aws_route_table_association" "ducatasso" {
  subnet_id      = aws_subnet.ducatsubnet.id
  route_table_id = aws_route_table.ducatrt.id
}

# make key pair

resource "aws_key_pair" "ducatkey" {
  key_name   = "projectkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDsZ/r47LROzBUJ91G4Qu7L/gvftb/ujtYbgD6LgfqwLGBrk9CrTuzQwcWQh9zYyLHwFt8/gdcSeqcL8R6OOI48eW3gg0L72eWVrzvYmNX0WdYZIc7kQz3nHGqEqRC+WySPjVp8/pmsXxAcxUuFhU9t3uOdXB7MuRYJ4De6N5DtU+ucG5fDn9Hn8JS6RBXPPld9jnoFcZ3bdct9AXP3M1/ZuA8UrA64UtmyeabXQ8kiyWnmjkZUQQKXVXg9uUU5wqlguvYo2y7sVotQT7dt4ofrIckQrO2C8+yvRCPJa5CXvqKLKGIXFPHs6YjMy4KQuxcApTxG6Wv4a7HxuxTYf0z1xQ9lzZNM2+8nLNB2S/tZsT/PazC51qcLMKPNJyuwgjCviFvv8xaFoc8eu4Z6X3+ySSN0X01AdYWUqNMltLs3/PAdE5tX127t7yGCLmYkY5tZGZ70D5iiU5hCjZTPDnrZmkwg2ElDrl2MEwb5rtrMa3wZ0wtVtsVaPeKOggVTZvs= root@server"
}

# make instance

resource "aws_instance" "ducatinstance" {
  ami           = "ami-0cbbe2c6a1bb2ad63"
  instance_type = "t3.micro"
  subnet_id =  aws_subnet.ducatsubnet.id
  vpc_security_group_ids = [aws_security_group.ducatsg.id]
  key_name = "projectkey"

  tags = {
    Name = "projectinstance"
  }
}

# make elastic ip

resource "aws_eip" "ducatip" {
  instance = aws_instance.ducatinstance.id
  domain   = "vpc"
}


