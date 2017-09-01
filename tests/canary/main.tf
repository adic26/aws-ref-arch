module "toggle-service" {
  source = "../../terraform/canary"

  key_name             = "pairing_two"
  "aws_region"         = "us-east-1"
  "lb_security_group"  = "sg-a0df2ed1"
  "app_security_group" = "sg-47df2e36"
  "app_name"           = "toggle-test"
  "ping_path"          = "/v1/toggle-service"
  "app_port"           = "9860"
  "asg_min"            = "1"
  "asg_max"            = "2"
  "asg_desired"        = "1"
  "dark_image"         = "hbc-docker.jfrog.io/toggle-service:1.4.0"
  "live_image"         = "hbc-docker.jfrog.io/toggle-service:1.4.0"
  "instance_type"      = "t2.micro"
  "hbc_env"            = "toggle-service"
  "hbc_banner"         = "saks"
  "hbc_group"          = "preprod"
  "shared_kms_key"     = "57b7e9e3-50a7-4f11-9731-b4b399e9558e"

  "subnet_ids" = [
    "subnet-e47116ac",
    "subnet-1f359c33",
  ]

  env_vars = {
    APP_NAME                  = "toggle-service"
    HBC_BANNER                = "saks"
    HBC_ENV                   = "preprod"
    MONGO_USER                = "fake"
    MONGO_PASSWORD            = "password"
    MONGO_PASSWORD_SECRET_KEY = "mongoPassword"
    MONGO_HOST                = "not_real/fake"
    MONGO_DB_NAME             = "fake"
    NEW_RELIC_LICENSE_KEY     = ""
    NEW_RELIC_APP_NAME        = "toggle-service"
  }
}

terraform {
  backend "s3" {
    bucket = "rogue-infra"
    key    = "terraform/tests/stack/mongo"
    region = "us-east-1"
  }
}
