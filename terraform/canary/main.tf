provider "aws" {
  region = "${var.aws_region}"
}

module "live" {
  source = "../microservice"

  component            = "live"
  lb_security_group    = "${var.lb_security_group}"
  subnet_ids_app       = ["${var.subnet_ids_app}"]
  subnet_ids_elb       = ["${var.subnet_ids_elb}"]
  app_security_group   = "${var.app_security_group}"
  app_name             = "${var.app_name}"
  ping_path            = "${var.ping_path}"
  key_name             = "${var.key_name}"
  app_port             = "${var.app_port}"
  instance_type        = "${var.instance_type}"
  asg_min              = "${var.asg_min}"
  asg_max              = "${var.asg_max}"
  asg_desired          = "${var.asg_desired}"
  image                = "${var.live_image}"
  env_vars             = "${var.env_vars}"
  hbc_env              = "${var.hbc_env}"
  hbc_group            = "${var.hbc_group}"
  hbc_banner           = "${var.hbc_banner}"
  shared_kms_key       = "${var.shared_kms_key}"
}

module "dark" {
  source = "../microservice"

  component            = "dark"
  lb_security_group    = "${var.lb_security_group}"
  subnet_ids_app       = ["${var.subnet_ids_app}"]
  subnet_ids_elb       = ["${var.subnet_ids_elb}"]
  app_security_group   = "${var.app_security_group}"
  app_name             = "${var.app_name}"
  ping_path            = "${var.ping_path}"
  key_name             = "${var.key_name}"
  app_port             = "${var.app_port}"
  instance_type        = "${var.instance_type}"
  asg_min              = "1"
  asg_max              = "1"
  asg_desired          = "1"
  image                = "${var.dark_image}"
  env_vars             = "${var.env_vars}"
  hbc_env              = "${var.hbc_env}"
  hbc_group            = "${var.hbc_group}"
  hbc_banner           = "${var.hbc_banner}"
  shared_kms_key       = "${var.shared_kms_key}"
}
