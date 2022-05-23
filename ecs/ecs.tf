resource "aws_ecs_cluster" "test-cluster" {
  name = "test-cluster"
}

resource "aws_ecs_task_definition" "test-task" {
  container_definitions = file("./container.json")
  family = "hoge"
  cpu = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = "${aws_iam_role.ecs_task_execution_role.arn}"
}

resource "aws_ecs_service" "test-service" {
  name = "hoge-service"
  cluster = "${aws_ecs_cluster.test-cluster.id}"
  task_definition = aws_ecs_task_definition.test-task.arn
  //desired_count = 2
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "1.4.0"
  //health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = true
    security_groups = ["${aws_security_group.web_port_enable.id}"]
    subnets = [
      "${aws_subnet.public_hoge.id}",
      //"${aws_subnet.public_fuga.id}"
    ]
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

