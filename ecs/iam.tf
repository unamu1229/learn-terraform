data "aws_iam_policy_document" "ecs_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  assume_role_policy = "${data.aws_iam_policy_document.ecs_role.json}"
  name = "hoge-role"
}

resource "aws_iam_role_policy_attachment" "ecs_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role = "${aws_iam_role.ecs_task_execution_role.name}"
}