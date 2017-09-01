provider "aws" {
  region = "${var.aws_region}"
}


resource "aws_ebs_volume" "primary_mongo_volume" {
  count             = "${var.v_count}"
  availability_zone = "${data.aws_subnet.selected.availability_zone}"
  size              = "${var.volume_size}"
  type              = "gp2"


  tags {
    Name       = "PrimaryMongo-${var.replica_set_name}"
    hbc_banner = "${var.hbc_banner}"
    hbc_env    = "${var.hbc_env}"
    hbc_group  = "${var.hbc_group}"
  }
}

resource "aws_ebs_volume" "secondary_mongo_volume0" {
  count              = "${var.v_count}"
  availability_zone  = "${data.aws_subnet.selected.availability_zone}"
  size               = "${var.volume_size}"
  type               = "gp2"


  tags {
    Name       = "SecondaryMongo0-${var.replica_set_name}"
    hbc_banner = "${var.hbc_banner}"
    hbc_env    = "${var.hbc_env}"
    hbc_group  = "${var.hbc_group}"
  }
}

resource "aws_ebs_volume" "secondary_mongo_volume1" {
  count             = "${var.v_count}"
  availability_zone = "${data.aws_subnet.selected.availability_zone}"
  size              = "${var.volume_size}"
  type              = "gp2"


  tags {
    Name       = "SecondaryMongo1-${var.replica_set_name}"
    hbc_banner = "${var.hbc_banner}"
    hbc_env    = "${var.hbc_env}"
    hbc_group  = "${var.hbc_group}"
  }
}


data "aws_subnet" "selected" {
  id = "${var.subnet_id}"
}
