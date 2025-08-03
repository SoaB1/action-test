resource "aws_vpc" "mnvpc_01" {
  cidr_block = var.aws_vpc_cidr
  tags = {
    Name = "mnvpc-01"
  }
  tags_all = {
    Name = "mnvpc-01"
  }
}

resource "aws_internet_gateway" "mnigw_01" {
  tags = {
    Name = "mnigw-01"
  }
  tags_all = {
    Name = "mnigw-01"
  }
  vpc_id = aws_vpc.mnvpc_01.id
}

resource "aws_route_table" "mnrt_01" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mnigw_01.id
  }
  tags = {
    Name = "mnrt-01"
  }
  tags_all = {
    Name = "mnrt-01"
  }
  vpc_id = aws_vpc.mnvpc_01.id
}

resource "aws_security_group" "mnsg_01" {
  description = "mnsg-01"
  egress {
    cidr_blocks      = ["172.18.1.0/26"]
    description      = "Outbound - Allow all traffic to subnet-001"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
  ingress {
    cidr_blocks      = ["172.18.1.0/26"]
    description      = "Inbound - Allow all traffic from subnet-001"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
  name   = "mnsg-01"
  vpc_id = aws_vpc.mnvpc_01.id
}

resource "aws_subnet" "subnet_001" {
  cidr_block              = var.aws_vpc_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-001"
  }
  tags_all = {
    Name = "subnet-001"
  }
  vpc_id = aws_vpc.mnvpc_01.id
}

resource "aws_route_table_association" "mnrta_01" {
  subnet_id      = aws_subnet.subnet_001.id
  route_table_id = aws_route_table.mnrt_01.id
}
