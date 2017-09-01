output "concourse-worker_fqdn" {
  value = "${aws_route53_record.worker.fqdn}"
}

output "concourse-web_fqdn" {
  value = "${aws_route53_record.web.fqdn}"
}

output "concourse_web_instance_id" {
  value = "${aws_instance.web.id}"
}

output "concourse_worker_instance_id" {
  value = "${aws_instance.worker.id}"
}

output "concourse_db_id" {
  value = "${module.postgres_rds.rds_instance_id}"
}
