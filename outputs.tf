output "aws_lb_proxy_id" {
  value = aws_lb.aws-lb-proxy.id
}

output "aws_lb_proxy_fqdn" {
  value = aws_lb.aws-lb-proxy.dns_name
}

output "aws_tg_proxy_arn" {
  value = aws_lb_target_group.aws-lb-tg-proxy.arn
}
