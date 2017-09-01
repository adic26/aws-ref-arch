provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_elb" "elb" {
  name  = "${replace("${var.app_name}-${terraform.env}-${var.component}","/(.{0,32})(.*)/", "$1")}"

  subnets = [
    "${var.subnet_ids_elb}",
  ]

  security_groups = [
    "${var.lb_security_group}",
  ]

  listener {
    instance_port     = "${var.app_port}"
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.app_port}${var.ping_path}"
    interval            = 5
  }

  tags {
    hbc_banner = "${var.hbc_banner}"
    hbc_env    = "${var.hbc_env}"
    hbc_group  = "${var.hbc_group}"
  }
}

data "aws_route53_zone" "zone" {
  name         = "${var.host_zone}"
  private_zone = false
}

resource "aws_route53_record" "entry" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.component}.${var.app_name}-${terraform.env}.${var.hbc_env}.${var.hbc_banner}.${var.host_zone}"

  type = "A"

  alias {
    name                   = "${aws_elb.elb.dns_name}"
    zone_id                = "${aws_elb.elb.zone_id}"
    evaluate_target_health = false
  }
}


resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [
    "${var.subnet_ids_app}",
  ]

  name                  = "${var.app_name}-${terraform.env}-${var.component}-${aws_launch_configuration.lc.name}"
  max_size              = "${var.asg_max}"
  min_size              = "${var.asg_min}"
  desired_capacity      = "${var.asg_desired}"
  wait_for_elb_capacity = "${var.asg_min}"
  launch_configuration  = "${aws_launch_configuration.lc.name}"

  load_balancers = [
    "${var.additional_elb_to_associate_asg}","${aws_elb.elb.name}",
  ]

  tag {
    key                 = "Name"
    value               = "${var.app_name}-${terraform.env}-${var.component}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "hbc_banner"
    value               = "${var.hbc_banner}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "hbc_env"
    value               = "${var.hbc_env}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "hbc_group"
    value               = "${var.hbc_group}"
    propagate_at_launch = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "amazon" {
  owners = [
    "195056086334",
  ]

  filter {
    name = "name"

    values = [
      "ec2_instance_of_doom",
    ]
  }
}

data "template_file" "docker-compose" {
  template = <<EOF
version: '3'
services:
  ${var.app_name}:
    container_name: ${var.app_name}
    image: ${var.image}
    restart: always
    ports:
      - ${var.app_port}:${var.app_port}
    ${length(var.env_vars) >= 1? "environment:\n${join("", data.template_file.env_vars.*.rendered)}" : ""}
    logging:
        driver: awslogs
        options:
          awslogs-region: ${var.aws_region}
          awslogs-group: ${aws_cloudwatch_log_group.log_group.name}
          tag: ${var.hbc_group}-${var.hbc_env}
EOF
}

data "template_file" "env_vars" {
  count = "${length(var.env_vars)}"

  template = <<EOF
    - ${element(keys(var.env_vars), count.index)}=${lookup(var.env_vars, element(keys(var.env_vars), count.index))}
EOF
}

data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.sh")}"

  vars {
    aws_region     = "${var.aws_region}"
    docker_compose = "${data.template_file.docker-compose.rendered}"
  }
}

resource "aws_launch_configuration" "lc" {
  image_id      = "${data.aws_ami.amazon.id}"
  instance_type = "${var.instance_type}"
  user_data     = "${data.template_file.userdata.rendered}"
  key_name      = "${var.key_name}"

  security_groups = [
    "${var.app_security_group}",
  ]

  iam_instance_profile = "${aws_iam_instance_profile.instance_profile.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.app_name}-${terraform.env}-${var.component}-${var.hbc_env}-${var.hbc_banner}-instance-profile"
  role = "${aws_iam_role.role.id}"
}

data "aws_iam_policy_document" "key_doc" {
  statement {
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::195056086334:root"]
    }
  }
}

data "aws_iam_policy_document" "role_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  name               = "${var.app_name}-${terraform.env}-${var.component}-${var.hbc_env}-${var.hbc_banner}-role"
  assume_role_policy = "${data.aws_iam_policy_document.role_doc.json}"
}

data "aws_iam_policy_document" "role_policy_doc" {
  statement {
    actions   = ["ssm:*"]
    effect    = "Allow"
    resources = ["arn:aws:ssm:us-east-1:195056086334:parameter/${var.app_name}/${var.hbc_banner}/${var.hbc_env}/*"]
  }

  statement {
    actions   = ["ssm:*"]
    effect    = "Allow"
    resources = ["arn:aws:ssm:us-east-1:195056086334:parameter/artifactory2.*"]
  }

  statement {
    actions   = ["logs:*"]
    effect    = "Allow"
    resources = ["${aws_cloudwatch_log_group.log_group.arn}"]
  }

  statement {
    actions = ["kms:Decrypt"]
    effect  = "Allow"

    resources = [
      "arn:aws:kms:us-east-1:195056086334:key/${var.shared_kms_key}"
    ]
  }
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name   = "${var.app_name}-${terraform.env}-${var.component}-${var.hbc_env}-${var.hbc_banner}-role-policy"
  role   = "${aws_iam_role.role.id}"
  policy = "${data.aws_iam_policy_document.role_policy_doc.json}"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.app_name}-${terraform.env}-${var.component}"

  tags {
    hbc_banner = "${var.hbc_banner}"
    hbc_env    = "${var.hbc_env}"
    hbc_group  = "${var.hbc_group}"
  }
}
