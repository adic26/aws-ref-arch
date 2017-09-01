resource "aws_s3_bucket" "bootstrap_mongo" {
  bucket = "mongo_rs-${var.replica_set_name}"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "mongo_keyfile" {
  key    = "keyfile"
  bucket = "${aws_s3_bucket.bootstrap_mongo.bucket}"
  source = "${var.mongo_keyfile}"

  tags {
    hbc_banner = "${var.hbc_banner}"
    hbc_env    = "${var.hbc_env}"
    hbc_group  = "${var.hbc_group}"
  }
}
