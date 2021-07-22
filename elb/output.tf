output "instance_ip" {
  value = module.ec2_instance_elb.public_ip
}

output "lb_address" {
  value = module.elb.elb_dns_name
}
