module "mongo_replica_set" {
  source = "../../terraform/mongo"

  admin_username          = "some"
  admin_password_key      = "mongoAdminPassword"
  mongo_keyfile           = "./mongo-key"
  replica_set_name        = "replica-test"
  subnet_id               = "subnet-e47116ac"
  security_group          = "sg-47df2e36"
  key_name                = "pairing_two"
  instance_type           = "t2.micro"
  db_name                 = "test"
  db_username             = "test"
  db_password_key         = "mongoPassword"
  parameter_key_namespace = "/toggle-service/test/test"
  hbc_banner              = "test"
  hbc_env                 = "test"
  hbc_group               = "rogue-squadron"
}

output "ip" {
  value = "${module.mongo_replica_set.public_ip}"
}

terraform {
  backend "s3" {
    bucket = "rogue-infra"
    key    = "terraform/tests/mongo"
    region = "us-east-1"
  }
}
