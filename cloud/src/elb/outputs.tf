output "lb-web-dns-name" {
  description = "DNS name of LB to send load test requests to"
  value       = aws_lb.lb-web.dns_name
}

