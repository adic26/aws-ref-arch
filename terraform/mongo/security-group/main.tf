resource "aws_security_group" "mongodb_replica_set" {
  name        = "mongo_rs-${var.replica_set_name}"
  description = "Allow traffic to mongo and between mongo nodes in replica set"

  ingress {
    from_port   = "${var.port}"
    to_port     = "${var.port}"
    self        = true
    protocol    = "tcp"
    cidr_blocks = ["38.109.119.254/32"]
  }

  ingress {
    from_port   = "1521"
    to_port     = "1521"
    protocol    = "tcp"
    cidr_blocks = ["38.109.119.254/32"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["38.109.119.254/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    hbc_banner = "${var.hbc_banner}"
    hbc_env    = "${var.hbc_env}"
    hbc_group  = "${var.hbc_group}"
  }
}
