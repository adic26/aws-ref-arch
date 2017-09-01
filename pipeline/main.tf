variable "password" {}

variable "key_name" {
  default     = "rogue_squadron_shared"
  description = "Key Pair for ssh'ing into box"
}

module "concourse" {
  source = "../terraform/concourse"

  team_name            = "rogue-squadron"
  concourse_username   = "concourse"
  concourse_password   = "${var.password}"
  db_username          = "concourse"
  db_password          = "${var.password}"
  db_storage_size      = "10"
  db_security_group_id = "sg-400f3731"
  instance_type        = "t2.large"
  db_subnet_group      = "concourse_postgres"
  key_name             = "${var.key_name}"
  aws_region           = "us-east-1"
  db_instance_class    = "db.t2.micro"
  security_group_id    = "sg-49818238"
  subnet_id            = "subnet-7beca033"
  worker_volume_size   = "100"
  iam_instance_profile = "Concourse_Role"
  hbc_env              = "preprod"
  hbc_group            = "rogue-squadron"
  hbc_banner           = "common"
  host_zone            = "hbccommon.private.hbc.com"

}

terraform {
  backend "s3" {
    bucket = "rogue-infra"
    key    = "terraform/common/concourse"
    region = "us-east-1"
  }
}
