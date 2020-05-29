data "aws_db_instance" "appdb" {
  db_instance_identifier = var.app_db_instance_identifier
}

data "template_file" "userdataprereqs" {
  template = "${file("${path.cwd}/../user_data/userdata.tpl")}"
}

data "template_file" "addsshkey" {
  template = "${file("${path.module}/../user_data/add-ssh-key.tpl")}"
  vars = {
    ssh_pub_key = var.ssh_pub_key
  }
}

data "template_file" "dbconnectionstring" {
  template = "${file("${path.module}/../user_data/dbconnectionstring.tpl")}"

  vars = {
    app_db_address  = data.aws_db_instance.appdb.address
    app_db_user     = var.app_db_user
    app_db_password = var.app_db_password
    app_db_name     = var.app_db_name
  }
}

data "template_cloudinit_config" "migrationinstanceconfig" {
  base64_encode = true
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.userdataprereqs.template}"
  }
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.addsshkey.rendered
  }
  part {
    content_type = "text/x-shellscript"
    content      = "${file("${path.cwd}/../user_data/install-web2py.sh")}"
  }
  part {
    content_type = "text/x-shellscript"
    content      = "${file("${path.cwd}/../user_data/install-web2py-app.sh")}"
  }
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.dbconnectionstring.rendered
  }
  part {
    content_type = "text/x-shellscript"
    content      = "${file("${path.cwd}/../user_data/restart-services.sh")}"
  }
}

