resource "aws_instance" "mongo_node" {
  ami                    = "${data.aws_ami.mongo_base_ami.image_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${var.security_group}"]
  iam_instance_profile   = "${var.iam_instance_profile}"
  user_data              = "${data.template_file.initialize_replica_set.rendered}"

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags {
    Name       = "${var.node_name}-${var.replica_set_name}"
    hbc_banner = "${var.hbc_banner}"
    hbc_env    = "${var.hbc_env}"
    hbc_group  = "${var.hbc_group}"
  }
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name  = "/dev/xvdf"
  volume_id    = "${data.aws_ebs_volume.ebs_volume.id}"
  instance_id  = "${aws_instance.mongo_node.id}"
  skip_destroy = true
}

data "aws_ebs_volume" "ebs_volume" {
  filter {
    name = "tag:Name"
    values = ["${var.node_name}-${var.replica_set_name}"]
  }
  filter {
    name = "size"
    values = ["${var.volume_size}"]
  }
}


  data "template_file" "initialize_replica_set" {
  template = "${file("${path.module}/initialize-replica-set.sh")}"

  vars {
    mongo_version           = "${var.mongo_version}"
    port                    = "${var.port}"
    admin_username          = "${var.admin_username}"
    admin_password_key      = "${var.admin_password_key}"
    replica_set_name        = "${var.replica_set_name}"
    secondary0_ip           = "${var.secondary0_ip}"
    secondary1_ip           = "${var.secondary1_ip}"
    s3_bucket_name          = "${var.s3_bucket_name}"
    db_name                 = "${var.db_name}"
    db_username             = "${var.db_username}"
    db_password_key         = "${var.db_password_key}"
    parameter_key_namespace = "${var.parameter_key_namespace}"
  }
}

data "aws_ami" "mongo_base_ami" {
  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }
}