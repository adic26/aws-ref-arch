variable "availability_zones"      { type = "list" }
variable "bastion_ami" {}
variable "bastion_type"            { default = "t2.nano"}
variable "bastion_subnet_ids"      { type = "list" }
variable "bastion_security_groups" { type = "list" }
variable "team_name" {}
variable "key_name" {}

resource "aws_launch_configuration" "bastion" {
  name_prefix = "bastion-${var.team_name}"
  image_id = "${var.bastion_ami}"
  instance_type = "${var.bastion_type}"
  security_groups = ["${var.bastion_security_groups}"]
  iam_instance_profile = "HbcdS3Readonly"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name                 = "${aws_launch_configuration.bastion.name}" # Forces recreation when the launch configuration changes
  launch_configuration = "${aws_launch_configuration.bastion.name}"
  min_size             = "1"
  max_size             = "1"
  vpc_zone_identifier  = ["${var.bastion_subnet_ids}"]

  tag {
    key                 = "hbc_banner"
    value               = "multi"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "hbc_env"
    value               = "multi"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "hbc_group"
    value               = "${var.team_name}"
    propagate_at_launch = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}
