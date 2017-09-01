
output "concourse-worker_fqdn" {
  value = "${module.concourse.concourse-worker_fqdn}"
}

output "concourse-web_fqdn" {
  value = "${module.concourse.concourse-web_fqdn}"
}

output "concourse_web_instance_id" {
  value = "${module.concourse.concourse_web_instance_id}"
}

output "concourse_worker_instance_id" {
  value = "${module.concourse.concourse_worker_instance_id}"
}

output "concourse_db_id" {
  value = "${module.concourse.concourse_db_id}"
}
