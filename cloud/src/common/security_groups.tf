data "aws_security_group" "in_all_http" {
  filter {
    name   = "tag:Name"
    values = ["allow_all_http"]
  }
}

data "aws_security_group" "in_local_http" {
  filter {
    name   = "tag:Name"
    values = ["allow_local_http"]
  }
}

data "aws_security_group" "in_ssh" {
  filter {
    name   = "tag:Name"
    values = ["allow_ssh"]
  }
}

data "aws_security_group" "out_all" {
  filter {
    name   = "tag:Name"
    values = ["allow_all_outbound"]
  }
}
