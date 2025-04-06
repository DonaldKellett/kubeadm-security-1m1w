resource "aws_vpc" "kubeadm-security-1m1w-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "kubeadm-security-1m1w-vpc"
  }
}

resource "aws_internet_gateway" "kubeadm-security-1m1w-igw" {
  vpc_id = aws_vpc.kubeadm-security-1m1w-vpc.id
  tags = {
    Name = "kubeadm-security-1m1w-igw"
  }
}

resource "aws_subnet" "kubeadm-security-1m1w-subnet" {
  vpc_id     = aws_vpc.kubeadm-security-1m1w-vpc.id
  cidr_block = var.subnet_cidr
}

resource "aws_route_table" "kubeadm-security-1m1w-subnet-rtb" {
  vpc_id = aws_vpc.kubeadm-security-1m1w-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kubeadm-security-1m1w-igw.id
  }

  tags = {
    Name = "kubeadm-security-1m1w-subnet-rtb"
  }
}

resource "aws_route_table_association" "kubeadm-security-1m1w-subnet-rtb-assoc" {
  subnet_id      = aws_subnet.kubeadm-security-1m1w-subnet.id
  route_table_id = aws_route_table.kubeadm-security-1m1w-subnet-rtb.id
}

resource "aws_security_group" "kubeadm-security-1m1w-masters-sg" {
  name        = "kubeadm-security-1m1w-masters-sg"
  description = "Security group for kubeadm master nodes"
  vpc_id      = aws_vpc.kubeadm-security-1m1w-vpc.id

  tags = {
    Name = "kubeadm-security-1m1w-masters-sg"
  }
}

resource "aws_security_group_rule" "kubeadm-security-1m1w-masters-sg-allow-trusted-ssh-ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.kubeadm-security-1m1w-masters-sg.id
  cidr_blocks       = var.trusted_cidr_blocks
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "kubeadm-security-1m1w-masters-sg-allow-masters-all-ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.kubeadm-security-1m1w-masters-sg.id
  source_security_group_id = aws_security_group.kubeadm-security-1m1w-masters-sg.id
  from_port                = 0
  protocol                 = "-1"
  to_port                  = 0
}

resource "aws_security_group_rule" "kubeadm-security-1m1w-masters-sg-allow-workers-all-ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.kubeadm-security-1m1w-masters-sg.id
  source_security_group_id = aws_security_group.kubeadm-security-1m1w-workers-sg.id
  from_port                = 0
  protocol                 = "-1"
  to_port                  = 0
}

resource "aws_security_group_rule" "kubeadm-security-1m1w-masters-sg-allow-all-egress" {
  type              = "egress"
  security_group_id = aws_security_group.kubeadm-security-1m1w-masters-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
}

resource "aws_security_group" "kubeadm-security-1m1w-workers-sg" {
  name        = "kubeadm-security-1m1w-workers-sg"
  description = "Security group for kubeadm master nodes"
  vpc_id      = aws_vpc.kubeadm-security-1m1w-vpc.id

  tags = {
    Name = "kubeadm-security-1m1w-workers-sg"
  }
}

resource "aws_security_group_rule" "kubeadm-security-1m1w-workers-sg-allow-trusted-ssh-ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.kubeadm-security-1m1w-workers-sg.id
  cidr_blocks       = var.trusted_cidr_blocks
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
}

resource "aws_security_group_rule" "kubeadm-security-1m1w-workers-sg-allow-all-egress" {
  type              = "egress"
  security_group_id = aws_security_group.kubeadm-security-1m1w-workers-sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
}

resource "aws_security_group_rule" "kubeadm-security-1m1w-workers-sg-allow-masters-all-ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.kubeadm-security-1m1w-workers-sg.id
  source_security_group_id = aws_security_group.kubeadm-security-1m1w-masters-sg.id
  from_port                = 0
  protocol                 = "-1"
  to_port                  = 0
}

resource "aws_security_group_rule" "kubeadm-security-1m1w-workers-sg-allow-workers-all-ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.kubeadm-security-1m1w-workers-sg.id
  source_security_group_id = aws_security_group.kubeadm-security-1m1w-workers-sg.id
  from_port                = 0
  protocol                 = "-1"
  to_port                  = 0
}
