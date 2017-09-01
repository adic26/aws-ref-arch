module "concourse" {
  source = "../../terraform/concourse"

  team_name            = "test-rogue-squadron"
  concourse_username   = "concourse"
  concourse_password   = "password"
  db_username          = "postgres"
  db_password          = "password"
  db_storage_size      = "10"
  instance_type        = "t2.large"
  db_subnet_group      = "concourse_postgres"
  key_name             = "rogue_squadron_shared"
  aws_region           = "us-east-1"
  db_instance_class    = "db.t2.micro"
  security_group_id    = "sg-49818238"
  subnet_id            = "subnet-7beca033"
  worker_volume_size   = "100"
  iam_instance_profile = "Concourse_Role"
  hbc_banner           = "some_banner"
  hbc_env              = "ci-test"
  hbc_group            = "ci-test-group"
  web_volume_size      = "10"
  db_security_group_id = "sg-400f3731"
  db_security_groups   = "sg-400f3731"
}

terraform {
  backend "s3" {
    bucket = "rogue-infra"
    key    = "terraform/tests/concourse"
    region = "us-east-1"
  }
}
