resource "aws_launch_configuration" "web" {
  name_prefix                 = "web-launch-config"
  image_id                    = aws_ami_from_instance.webapptemplateami.id
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  security_groups             = [data.aws_security_group.in_local_http.id, data.aws_security_group.out_all.id, data.aws_security_group.in_ssh.id]
  lifecycle {
    create_before_destroy = true
  }
}

