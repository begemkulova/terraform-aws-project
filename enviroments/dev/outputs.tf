output "alb-dns-apache" {
  description = "The DNS name of our ALB"
  value       = data.terraform_remote_state.autoscaling.outputs.lb_dns_name
}
