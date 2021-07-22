provider "aws" {
  region  = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

module "ec2_instance_alb" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  name                   = "appway-test-instance-alb"
  instance_count         = 1
  ami                    = "ami-0dc2d3e4c0f9ebd18"
  instance_type          = "t2.micro"
  key_name               = "appway-test"
  subnet_ids              = ["subnet-3b4b7b05","subnet-a23dd0c4"]
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

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  name = "test-alb"
  load_balancer_type = "application"
  subnets = ["subnet-3b4b7b05","subnet-a23dd0c4"]
  vpc_id = data.aws_vpc.default.id
  security_groups = [module.http_80_security_group.security_group_id]
  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval            = 6
        path                = "/index.html"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200"
      }
      targets = [
        {
          target_id = module.ec2_instance_alb.id[0]
          port = 80
        },
      ]
    }
  ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}



