data "aws_iam_policy_document" "instance" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  name               = "mongo_rs-${var.replica_set_name}"
  assume_role_policy = "${data.aws_iam_policy_document.instance.json}"
}

resource "aws_iam_instance_profile" "read_s3" {
  name = "mongo_rs-${var.replica_set_name}"
  role = "${aws_iam_role.instance.name}"
}

data "aws_iam_policy_document" "read_s3" {
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
  }

  statement {
    actions   = ["s3:ListBucket"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_bucket_name}"]
  }

  statement {
    actions   = ["ssm:GetParameters"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions   = ["kms:Decrypt"]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "test_policy" {
  name   = "mongo_rs-${var.replica_set_name}"
  role   = "${aws_iam_role.instance.id}"
  policy = "${data.aws_iam_policy_document.read_s3.json}"
}
