resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "false"
  tags = {
    Name = "MainVPCTF"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id

  # Subnetを作成するAZ
  availability_zone = "us-east-1a"

  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "PublicTF"
  }
}

resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.main.id

  # Subnetを作成するAZ
  availability_zone = "us-east-1c"

  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "PublicTF2"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id

  availability_zone = "us-east-1a"
  cidr_block        = "10.0.10.0/24"

  tags = {
    Name = "PrivateTF"
  }
}

resource "aws_subnet" "private2" {
  vpc_id = aws_vpc.main.id

  availability_zone = "us-east-1c"
  cidr_block        = "10.0.11.0/24"

  tags = {
    Name = "PrivateTF2"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "GWTF"
  }
}
# Elastic IP
# https://www.terraform.io/docs/providers/aws/r/eip.html
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "EIPTF"
  }
}

# Elastic IP
# https://www.terraform.io/docs/providers/aws/r/eip.html
resource "aws_eip" "nat2" {
  vpc = true

  tags = {
    Name = "EIPTF2"
  }
}

# NAT Gateway
# https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public.id # NAT Gatewayを配置するSubnetを指定
  allocation_id = aws_eip.nat.id       # 紐付けるElasti IP

  tags = {
    Name = "NATTF"
  }
}

# NAT Gateway
# https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
resource "aws_nat_gateway" "nat2" {
  subnet_id     = aws_subnet.public2.id # NAT Gatewayを配置するSubnetを指定
  allocation_id = aws_eip.nat2.id       # 紐付けるElasti IP

  tags = {
    Name = "NATTF2"
  }
}

# Route Table
# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PublicRTBTF"
  }
}

# Route
# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
}

# Association
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Route Table
# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "public2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PublicRTBTF2"
  }
}

# Route
# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "public2" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public2.id
  gateway_id             = aws_internet_gateway.main.id
}

# Association
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public2.id
}

# Route Table (Private)
# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PrivateRTBTF"
  }
}

# Route (Private)
# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "private" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Association (Private)
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Route Table (Private)
# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PrivateRTBTF"
  }
}

# Route (Private)
# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "private2" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private2.id
  nat_gateway_id         = aws_nat_gateway.nat2.id
}

# Association (Private)
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

# SecurityGroup
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "alb" {
  name        = "albTF"
  description = "albTF"
  vpc_id      = aws_vpc.main.id

  # セキュリティグループ内のリソースからインターネットへのアクセスを許可する
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "albTF"
  }
}

# SecurityGroup Rule
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  # セキュリティグループ内のリソースへインターネットからのアクセスを許可する
  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# SecurityGroup Rule
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group_rule" "alb_ssh" {
  security_group_id = aws_security_group.alb.id

  # セキュリティグループ内のリソースへインターネットからのアクセスを許可する(SSH)
  type = "ingress"

  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# ALB
# https://www.terraform.io/docs/providers/aws/d/lb.html
resource "aws_lb" "main" {
  load_balancer_type = "application"
  name               = "LBTF"

  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.public.id, aws_subnet.public2.id]
}

# Listener
# https://www.terraform.io/docs/providers/aws/r/lb_listener.html
resource "aws_lb_listener" "main" {
  # HTTPでのアクセスを受け付ける
  port     = "80"
  protocol = "HTTP"

  # ALBのarnを指定します。
  #XXX: arnはAmazon Resource Names の略で、その名の通りリソースを特定するための一意な名前(id)です。
  load_balancer_arn = aws_lb.main.arn

  # "ok" という固定レスポンスを設定する
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
}

# 絶対どっかに移したほうがいいやつ
# aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2/gpu/recommended これで
data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/gpu/recommended/image_id"
}

resource "aws_instance" "UnityEC2" {
  //resource "aws_spot_instance_request" "UnityEC2" {
  ami                    = data.aws_ssm_parameter.amzn2_ami.value
  vpc_security_group_ids = [aws_security_group.alb.id]
  subnet_id              = aws_subnet.public.id
  instance_type          = "g4dn.xlarge"
  tags = {
    Name = "ec2TF"
  }
}

# resource "aws_instance" "UnityEC2_2" {
#   //resource "aws_spot_instance_request" "UnityEC2_2" {
#   ami                    = data.aws_ssm_parameter.amzn2_ami.value
#   vpc_security_group_ids = [aws_security_group.alb.id]
#   subnet_id              = aws_subnet.public2.id
#   instance_type          = "g4dn.xlarge"
#   tags = {
#     Name = "ec2TF2"
#   }
# }

resource "aws_eip" "lb" {
  instance = aws_instance.UnityEC2.id
  //instance = aws_spot_instance_request.UnityEC2.spot_instance_id
  vpc = true
}

# resource "aws_eip" "lb2" {
#   instance = aws_instance.UnityEC2_2.id
#   //instance = aws_spot_instance_request.UnityEC2_2.spot_instance_id
#   vpc      = true
# }
