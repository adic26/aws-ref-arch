output "concourse_dns" {
  value = "${module.concourse.concourse_fqdn}"
}
