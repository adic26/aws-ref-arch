output "db_instance_address" {
  value = "${aws_db_instance.postgres_concourse.address}"
}

output "rds_instance_id" {
  value = "${aws_db_instance.postgres_concourse.id}"
}
