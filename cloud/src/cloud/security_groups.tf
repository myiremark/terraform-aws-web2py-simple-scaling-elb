data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "allow_all_outbound" {
  name        = "allow_all_outbound"
  description = "Allow all outbound traffic to anywhere"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_outbound"
  }
}

resource "aws_security_group" "allow_all_http" {
  name        = "allow_all_http"
  description = "Allow all http inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow inbound HTTP from *"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_http"
  }
}

resource "aws_security_group" "allow_local_http" {
  name        = "allow_local_http"
  description = "Allow http inbound traffic from local subnets"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from vpc cidr block"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name = "allow_local_http"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic from anywhere"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "allow inbound ssh from *"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
