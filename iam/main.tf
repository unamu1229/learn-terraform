data "aws_iam_policy_document" "ec2_regions" {
  statement {
    effect = "Allow"
    actions = ["ec2:DescribeRegions"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "hoge_policy" {
  name = "hoge_ec2_describe"
  policy = data.aws_iam_policy_document.ec2_regions.json
}

data "aws_iam_policy_document" "assume_role_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "assume_role" {
  name = "hoge_fuga_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_doc.json
}

resource "aws_iam_role_policy_attachment" "ec2_describe_regions" {
  policy_arn = aws_iam_policy.hoge_policy.arn
  role = aws_iam_role.assume_role.name
}