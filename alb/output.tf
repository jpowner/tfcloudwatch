output "instance_ip" {
  value = module.ec2_instance_alb.public_ip
}

output "lb_address" {
  value = module.alb.lb_dns_name
}
