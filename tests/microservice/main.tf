provider "aws" {
  region = "us-east-1"
}

module "prometheus" {
  source = "../../terraform/microservice"

  aws_region           = "us-east-1"
  subnet_ids           = ["subnet-e47116ac", "subnet-1f359c33"]
  lb_security_group    = "sg-a0df2ed1"
  app_security_group   = "sg-47df2e36"
  key_name             = "pairing_key"
  app_port             = "9090"
  asg_max              = "2"
  asg_min              = "1"
  asg_desired          = "1"
  app_name             = "monitoring-example"
  component            = "prometheus"
  image                = "hbc-docker.jfrog.io/prometheus:latest"
  ping_path            = "/graph"
  iam_instance_profile = "${aws_iam_instance_profile.app_profile.id}"
  instance_type        = "t2.micro"
  env_vars             = {}
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "microservice-module-test"
  role = "Temp_App_Role"
}

terraform {
  backend "s3" {
    bucket = "rogue-infra"
    key    = "terraform/tests/monitoring"
    region = "us-east-1"
  }
}
