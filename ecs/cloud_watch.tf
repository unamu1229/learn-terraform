resource "aws_cloudwatch_log_group" "hoge-ecs" {
  name = "/ecs/hoge"
  retention_in_days = 3
}

