output "template_instance_public_ip" {
  value = aws_instance.webapptemplateinstance.public_ip
}

output "template_instance_test_endpoint" {
  value = "${aws_instance.webapptemplateinstance.public_ip}${var.app_ready_check_path}"
}
