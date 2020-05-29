output "migration_instance_public_ip" {
  # we need this for easy testing since we're not using DNS
  value = aws_instance.webappmigrationinstance.public_ip
}

output "migration_instance_test_endpoint" {
  value = "${aws_instance.webappmigrationinstance.public_ip}${var.app_ready_check_path}"
}

