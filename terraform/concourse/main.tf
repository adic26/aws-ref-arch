provider "aws" {
  region = "${var.aws_region}"
}

data "aws_route53_zone" "zone" {
  name         = "${var.host_zone}"
  private_zone = false
}

resource "aws_route53_record" "worker" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.team_name}-concourse-worker"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.worker.private_ip}"]
}

resource "aws_route53_record" "web" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.team_name}-concourse-web"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.web.private_ip}"]
}

module "postgres_rds" {
  source = "./postgres-rds"

  identifier        = "${var.team_name}-concourse"
  username          = "${var.db_username}"
  password          = "${var.db_password}"
  instance_class    = "${var.db_instance_class}"
  storage           = "${var.db_storage_size}"
  db_subnet_group   = "${var.db_subnet_group}"
  db_security_group_id = "${var.db_security_group_id}"
  hbc_group         = "${var.hbc_group}"
  hbc_env           = "${var.hbc_env}"
  hbc_banner        = "${var.hbc_banner}"
  vpc_security_group_ids = ["${var.db_security_groups}"]
}

data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["195056086334"]

  filter {
    name   = "name"
    values = ["concourse_worker_web_base"]
  }
}

resource "aws_instance" "web" {
  ami                    = "${data.aws_ami.amazon.id}"
  instance_type          = "${var.instance_type}"
  user_data              = "${data.template_file.userdata-web.rendered}"
  vpc_security_group_ids = ["${var.security_group_id}"]
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.key_name}"
  iam_instance_profile   = "${var.iam_instance_profile}"

  tags {
    Name       = "${var.team_name}-concourse-web"
    hbc_group  = "${var.hbc_group}"
    hbc_env    = "${var.hbc_env}"
    hbc_banner = "${var.hbc_banner}"
  }

  ebs_block_device {
    device_name = "/dev/xvdf"
    volume_type = "gp2"
    volume_size = "${var.web_volume_size}"
  }

}

resource "aws_instance" "worker" {
  ami                    = "${data.aws_ami.amazon.id}"
  instance_type          = "${var.instance_type}"
  user_data              = "${data.template_file.userdata-worker.rendered}"
  vpc_security_group_ids = ["${var.security_group_id}"]
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.key_name}"
  iam_instance_profile   = "${var.iam_instance_profile}"

  tags {
    Name       = "${var.team_name}-concourse-worker"
    hbc_group  = "${var.hbc_group}"
    hbc_env    = "${var.hbc_env}"
    hbc_banner = "${var.hbc_banner}"
  }

  ebs_block_device {
    device_name = "/dev/xvdf"
    volume_type = "gp2"
    volume_size = "${var.worker_volume_size}"
  }
}

data "template_file" "userdata-web" {
  template = "${file("${path.module}/userdata-web.sh")}"

  vars {
    aws_region     = "${var.aws_region}"
    docker_compose_web = "${data.template_file.docker-compose-web.rendered}"
    team_name      = "${var.team_name}"
  }
}

data "template_file" "docker-compose-web" {
  template = "${file("${path.module}/docker-compose-web.yml")}"

  vars {
    aws_region                = "${var.aws_region}"
    cloudwatch_log_group_name = "${aws_cloudwatch_log_group.log_group.name}"
    db_host                   = "${module.postgres_rds.db_instance_address}"
    postgres_password         = "${var.db_password}"
    postgres_user             = "${var.db_username}"
    concourse_user            = "${var.concourse_username}"
    concourse_password        = "${var.concourse_password}"
  }
}


data "template_file" "userdata-worker" {
  template = "${file("${path.module}/userdata-worker.sh")}"

  vars {
    aws_region     = "${var.aws_region}"
    docker_compose_worker = "${data.template_file.docker-compose-worker.rendered}"
    team_name      = "${var.team_name}"
  }
}

data "template_file" "docker-compose-worker" {
  template = "${file("${path.module}/docker-compose-worker.yml")}"

  vars {
    aws_region                = "${var.aws_region}"
    cloudwatch_log_group_name = "${aws_cloudwatch_log_group.log_group.name}"
    db_host                   = "${module.postgres_rds.db_instance_address}"
    web_host                  = "${aws_instance.web.private_dns}"
    postgres_password         = "${var.db_password}"
    postgres_user             = "${var.db_username}"
    concourse_user            = "${var.concourse_username}"
    concourse_password        = "${var.concourse_password}"
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.team_name}-concourse"

  tags {
    hbc_banner = "${var.hbc_banner}"
    hbc_env    = "${var.hbc_env}"
    hbc_group  = "${var.hbc_group}"
  }
}

