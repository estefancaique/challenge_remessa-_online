
data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["Teste-vpc"]
  }
  depends_on = [aws_ecs_cluster.teste-remessa]
}


resource "aws_security_group" "nginx_sg" {
  name        = "nginx_security_lb_group"
  description = "Terraform load balancer security group"
  vpc_id      =  data.aws_vpc.selected.id
    
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LB-teste "
  }

  depends_on = [aws_ecs_cluster.teste-remessa]
}

resource "aws_lb" "nginx_lb" {
  name               = "nginx-lb"
  load_balancer_type = "application"
  subnets            = "${module.networking.public_subnets_id[0]}"
  security_groups    = ["${aws_security_group.nginx_sg.id}"]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  depends_on = [aws_ecs_cluster.teste-remessa]
}

# alb_target_group.tf nginx

resource "aws_alb_target_group" "nginx-tg" {
  health_check {
    healthy_threshold = "3"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/"
    unhealthy_threshold = "2"
  }

  name     = "nginx-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = data.aws_vpc.selected.id
}


