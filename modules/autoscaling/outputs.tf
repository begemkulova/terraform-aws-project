output "lb_dns_name" {
  description = "The DNS name of our ALB"
  value       = aws_lb.bekaiym.dns_name
}
