resource "aws_instance" "webapptemplateinstance" {
  # default is ubuntu 18 official base image:
  ami = var.deployed_ami_base_image

  # default is t2.micro (current free tier)
  instance_type = var.deployed_instance_type

  user_data     = data.template_cloudinit_config.webapptemplateinstanceconfig.rendered

  # use a public ip to facilitate quick testing, disable in asg
  associate_public_ip_address = true

  security_groups = [
    # allow all http in quick testing
    data.aws_security_group.in_all_http.id,
    # needed for updates and installs
    data.aws_security_group.out_all.id,
    # useful to have ssh to debug builds of template instance
    data.aws_security_group.in_ssh.id
  ]
  subnet_id = data.aws_subnet.app_subnet_1a_public.id

  tags = {
    Name = "webapp-template-instance"
  }
}
