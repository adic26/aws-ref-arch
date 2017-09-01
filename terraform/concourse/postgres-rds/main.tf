resource "aws_db_instance" "postgres_concourse" {
  identifier             = "${var.identifier}"
  allocated_storage      = "${var.storage}"
  instance_class         = "${var.instance_class}"
  username               = "${var.username}"
  password               = "${var.password}"
  engine                 = "postgres"
  engine_version         = "9.6.2"
  name                   = "concourse"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  db_subnet_group_name   = "${var.db_subnet_group}"
  skip_final_snapshot    = true

  tags {
    hbc_banner = "${var.hbc_banner}"
    hbc_env    = "${var.hbc_env}"
    hbc_group  = "${var.hbc_group}"
  }
}
