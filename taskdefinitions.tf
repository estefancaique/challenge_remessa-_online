/*====
ECS task definitions
======*/

#Criando grupo de logs

resource "aws_cloudwatch_log_group" "awslogs-nginx-ecs" {
  name = "awslogs-nginx-ecs"

}

/* the task definition for the nginx-tes */

data "template_file" "nginx_task" {
  template = "${file("task/nginx.json")}"

}

resource "aws_ecs_task_definition" "nginx-test" {
  family                   = "nginx-test"
  container_definitions    = "${data.template_file.nginx_task.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "${aws_iam_role.ecs_task_execution_role.arn}"
  task_role_arn            = "${aws_iam_role.ecs_task_execution_role.arn}"
}

