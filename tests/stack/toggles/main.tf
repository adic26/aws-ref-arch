provider "aws" {
  region = "us-east-1"
}

module "toggle-service" {
  source = "../../../terraform/canary"

  "key_name"             = "pairing_key"
  "aws_region"           = "us-east-1"
  "lb_security_group"    = "sg-a0df2ed1"
  "app_security_group"   = "sg-47df2e36"
  "app_name"             = "toggle-stack-test"
  "ping_path"            = "/v1/toggle-service"
  "app_port"             = "9860"
  "asg_min"              = "1"
  "asg_max"              = "2"
  "asg_desired"          = "1"
  "dark_image"           = "hbc-docker.jfrog.io/toggle-service:1.4.0"
  "live_image"           = "hbc-docker.jfrog.io/toggle-service:1.4.0"
  "instance_type"        = "t2.micro"
  "shared_kms_key"       = "57b7e9e3-50a7-4f11-9731-b4b399e9558e"
  hbc_group              = "rogue-squadron"
  hbc_banner             = "test"
  hbc_env                = "test"

  "subnet_ids" = [
    "subnet-e47116ac",
    "subnet-1f359c33",
  ]

  env_vars = {
    APP_NAME                  = "toggle-service"
    HBC_BANNER                = "test"
    HBC_ENV                   = "test"
    MONGO_USER                = "${data.terraform_remote_state.mongo.db_username}"
    MONGO_PASSWORD_SECRET_KEY = "${data.terraform_remote_state.mongo.db_password_key}"
    MONGO_PASSWORD            = "password"
    MONGO_HOST                = "${data.terraform_remote_state.mongo.ip}/${data.terraform_remote_state.mongo.db_name}"
    MONGO_DB_NAME             = "${data.terraform_remote_state.mongo.db_name}"
    NEW_RELIC_LICENSE_KEY     = ""
    NEW_RELIC_APP_NAME        = "toggle-service"
  }
}

data "terraform_remote_state" "mongo" {
  backend = "s3"

  config {
    bucket = "rogue-infra"
    key    = "terraform/tests/stack/mongo-stack"
    region = "us-east-1"
  }
}

terraform {
  backend "s3" {
    bucket = "rogue-infra"
    key    = "terraform/tests/stack/toggle-stack"
    region = "us-east-1"
  }
}
