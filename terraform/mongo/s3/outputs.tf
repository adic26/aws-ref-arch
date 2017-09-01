output "s3_bucket_name" {
  value = "${aws_s3_bucket.bootstrap_mongo.bucket}"
}
