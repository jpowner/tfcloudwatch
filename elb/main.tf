provider "aws" {
  region  = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

module "ec2_instance_elb" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "appway-test-instance-elb"
  instance_count         = 1
  ami                    = "ami-0dc2d3e4c0f9ebd18"
  instance_type          = "t2.micro"
  key_name               = "appway-test"
  subnet_ids              = ["subnet-4d98736c","subnet-39ea5674"]
  vpc_security_group_ids = [module.http_80_security_group.security_group_id, module.ssh_22_security_group.security_group_id]
  user_data = <<-EOF
      #! /bin/bash
      sudo yum install -y httpd
      sudo systemctl start httpd
      echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
      EOF
}

module "http_80_security_group" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"
  name        = "http-sg"
  vpc_id      = data.aws_vpc.default.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "ssh_22_security_group" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"
  name        = "ssh-sg"
  vpc_id      = data.aws_vpc.default.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "elb" {
  source  = "terraform-aws-modules/elb/aws"
  name = "test-elb"
  subnets         = ["subnet-4d98736c","subnet-39ea5674"]
  security_groups = [module.http_80_security_group.security_group_id]
  internal        = false
  listener = [
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
  ]
  health_check = {
    target              = "HTTP:80/"
    interval            = 6
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
  // ELB attachments
  number_of_instances   = 1
  instances             = module.ec2_instance_elb.id
}
