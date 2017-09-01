output "prometheus_elb_hostname" {
  value = "${module.prometheus.elb_hostname}"
}

output "prometheus_ping_path" {
  value = "${module.prometheus.ping_path}"
}
