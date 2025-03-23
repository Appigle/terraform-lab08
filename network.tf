# List of supported availability zones in your region
data "aws_availability_zones" "available" {
  state = "available"
}

# NETWORKING
resource "aws_vpc" "app" {
  cidr_block           = local.cidr_block_vpc
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.app.id

  tags = var.resource_tags
}

locals {
  public_subnet_configs = {
    subnet1 = {
      az_index = 0
      cidr_index = 0
    }
    subnet2 = {
      az_index = 1
      cidr_index = 1
    }
  }

  security_groups = {
    public = {
      name        = "public_security_group"
      description = "Security group for public subnets"
      ingress_rules = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
      ]
    }
    load_balancer = {
      name        = "load_balancer_security_group"
      description = "Security group for load balancer"
      ingress_rules = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
      ]
    }
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnet_configs

  vpc_id                  = aws_vpc.app.id
  availability_zone       = data.aws_availability_zones.available.names[each.value.az_index]
  cidr_block              = var.public_subnet_cidr_blocks[each.value.cidr_index]
  map_public_ip_on_launch = local.map_public_ip_on_launch
  tags                    = var.resource_tags
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = var.resource_tags
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "groups" {
  for_each = local.security_groups

  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.app.id

  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.resource_tags
}
