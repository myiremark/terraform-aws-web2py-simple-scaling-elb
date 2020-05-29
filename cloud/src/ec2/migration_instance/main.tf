resource "aws_instance" "webappmigrationinstance" {
  ami                         = var.deployed_ami_base_image
  instance_type               = var.deployed_instance_type
  user_data                   = data.template_cloudinit_config.migrationinstanceconfig.rendered
  associate_public_ip_address = true
  security_groups = [
    data.aws_security_group.in_all_http.id,
    data.aws_security_group.in_ssh.id,
    data.aws_security_group.out_all.id
  ]
  subnet_id = data.aws_subnet.app_subnet_1a_public.id
  tags = {
    Name = "Migration-Instance"
  }
}

