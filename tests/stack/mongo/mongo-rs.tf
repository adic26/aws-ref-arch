variable "db_name" {
  default = "toggle"
}

variable "db_username" {
  default = "toggle"
}

variable "db_password_key" {
  default = "mongoPassword"
}

module "mongo_replica_set" {
  source = "../../../terraform/mongo"

  admin_username          = "some"
  admin_password_key      = "mongoAdminPassword"
  mongo_keyfile           = "./mongo-key"
  replica_set_name        = "toggle-stack-test"
  subnet_id               = "subnet-e47116ac"
  security_group          = "sg-47df2e36"
  key_name                = "pairing_two"
  instance_type           = "t2.micro"
  db_name                 = "${var.db_name}"
  db_username             = "${var.db_username}"
  db_password_key         = "${var.db_password_key}"
  parameter_key_namespace = "/toggle-service/test/test"
  hbc_banner              = "test"
  hbc_env                 = "test"
  hbc_group               = "rogue-squadron"
}

output "ip" {
  value = "${module.mongo_replica_set.ip}"
}

output "db_name" {
  value = "${var.db_name}"
}

output "db_username" {
  value = "${var.db_username}"
}

output "db_password_key" {
  value = "${var.db_password_key}"
}

terraform {
  backend "s3" {
    bucket = "rogue-infra"
    key    = "terraform/tests/stack/mongo-stack"
    region = "us-east-1"
  }
}
