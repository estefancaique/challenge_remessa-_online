resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.nginx-tg.arn
    type             = "forward"
  }

  depends_on = [aws_security_group.nginx_sg]
}

resource "aws_ecs_service" "nginx-service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.teste-remessa.id
  task_definition = aws_ecs_task_definition.nginx-test.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  

  network_configuration {
    security_groups = [aws_security_group.nginx_sg.id]
    subnets         = "${module.networking.private_subnets_id[0]}"
    assign_public_ip = "true"
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.nginx-tg.arn
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.nginx_listener]
}