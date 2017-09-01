provider "aws" {
  region = "${var.aws_region}"
}

module "primary_node" {
  source = "./node"

  node_name               = "PrimaryMongo"
  subnet_id               = "${var.subnet_id}"
  security_group          = "${var.security_group}"
  iam_instance_profile    = "${module.iam_profile.instance_profile_id}"
  key_name                = "${var.key_name}"
  instance_type           = "${var.instance_type}"
  volume_size             = "${var.volume_size}"
  ami_name                = "${var.ami_name}"
  mongo_version           = "${var.mongo_version}"
  port                    = "${var.port}"
  replica_set_name        = "${var.replica_set_name}"
  admin_username          = "${var.admin_username}"
  admin_password_key      = "${var.admin_password_key}"
  secondary0_ip           = "${module.secondary_node0.ip}"
  secondary1_ip           = "${module.secondary_node1.ip}"
  s3_bucket_name          = "${module.s3.s3_bucket_name}"
  db_name                 = "${var.db_name}"
  db_username             = "${var.db_username}"
  db_password_key         = "${var.db_password_key}"
  parameter_key_namespace = "${var.parameter_key_namespace}"
  hbc_group               = "${var.hbc_group}"
  hbc_env                 = "${var.hbc_env}"
  hbc_banner              = "${var.hbc_banner}"
}

module "secondary_node0" {
  source = "./node"

  node_name               = "SecondaryMongo0"
  subnet_id               = "${var.subnet_id}"
  security_group          = "${var.security_group}"
  iam_instance_profile    = "${module.iam_profile.instance_profile_id}"
  key_name                = "${var.key_name}"
  instance_type           = "${var.instance_type}"
  volume_size             = "${var.volume_size}"
  ami_name                = "${var.ami_name}"
  mongo_version           = "${var.mongo_version}"
  port                    = "${var.port}"
  replica_set_name        = "${var.replica_set_name}"
  admin_username          = "${var.admin_username}"
  admin_password_key      = "${var.admin_password_key}"
  s3_bucket_name          = "${module.s3.s3_bucket_name}"
  db_name                 = "${var.db_name}"
  db_username             = "${var.db_username}"
  db_password_key         = "${var.db_password_key}"
  parameter_key_namespace = "${var.parameter_key_namespace}"
  hbc_group               = "${var.hbc_group}"
  hbc_env                 = "${var.hbc_env}"
  hbc_banner              = "${var.hbc_banner}"
}

module "secondary_node1" {
  source = "./node"

  node_name               = "SecondaryMongo1"
  subnet_id               = "${var.subnet_id}"
  security_group          = "${var.security_group}"
  iam_instance_profile    = "${module.iam_profile.instance_profile_id}"
  key_name                = "${var.key_name}"
  instance_type           = "${var.instance_type}"
  volume_size             = "${var.volume_size}"
  ami_name                = "${var.ami_name}"
  mongo_version           = "${var.mongo_version}"
  port                    = "${var.port}"
  replica_set_name        = "${var.replica_set_name}"
  admin_username          = "${var.admin_username}"
  admin_password_key      = "${var.admin_password_key}"
  s3_bucket_name          = "${module.s3.s3_bucket_name}"
  db_name                 = "${var.db_name}"
  db_username             = "${var.db_username}"
  db_password_key         = "${var.db_password_key}"
  parameter_key_namespace = "${var.parameter_key_namespace}"
  hbc_group               = "${var.hbc_group}"
  hbc_env                 = "${var.hbc_env}"
  hbc_banner              = "${var.hbc_banner}"
}

module "iam_profile" {
  source = "./iam"

  replica_set_name = "${var.replica_set_name}"
  s3_bucket_name   = "${module.s3.s3_bucket_name}"
  hbc_group        = "${var.hbc_group}"
  hbc_env          = "${var.hbc_env}"
  hbc_banner       = "${var.hbc_banner}"
}

module "s3" {
  source = "./s3"

  replica_set_name = "${var.replica_set_name}"
  mongo_keyfile    = "${var.mongo_keyfile}"
  hbc_group        = "${var.hbc_group}"
  hbc_env          = "${var.hbc_env}"
  hbc_banner       = "${var.hbc_banner}"
}
