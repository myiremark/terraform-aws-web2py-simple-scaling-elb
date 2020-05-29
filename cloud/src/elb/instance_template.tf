data "aws_instance" "webapptemplate" {
  filter {
    name   = "tag:Name"
    values = ["webapp-template-instance"]
  }
}

resource "aws_ami_from_instance" "webapptemplateami" {
  name               = "webapptemplateami.${data.aws_instance.webapptemplate.id}"
  source_instance_id = data.aws_instance.webapptemplate.id
}

