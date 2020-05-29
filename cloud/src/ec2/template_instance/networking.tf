data "aws_subnet" "app_subnet_1a_private" {
  filter {
    name   = "tag:Name"
    values = ["app-vpc-private-us-east-1a"]
  }
}

data "aws_subnet" "app_subnet_1b_private" {
  filter {
    name   = "tag:Name"
    values = ["app-vpc-private-us-east-1b"]
  }
}

data "aws_subnet" "app_subnet_1c_private" {
  filter {
    name   = "tag:Name"
    values = ["app-vpc-private-us-east-1c"]
  }
}

data "aws_subnet" "app_subnet_1a_public" {
  filter {
    name   = "tag:Name"
    values = ["app-vpc-public-us-east-1a"]
  }
}

data "aws_subnet" "app_subnet_1b_public" {
  filter {
    name   = "tag:Name"
    values = ["app-vpc-public-us-east-1b"]
  }
}

data "aws_subnet" "app_subnet_1c_public" {
  filter {
    name   = "tag:Name"
    values = ["app-vpc-public-us-east-1c"]
  }
}

data "aws_vpc" "app_vpc" {
  filter {
    name   = "tag:Name"
    values = ["app-vpc"]
  }
}
