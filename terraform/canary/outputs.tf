output "live_component" {
  value = {
    app_name     = "${module.live.app_name}"
    asg_name     = "${module.live.asg_name}"
    elb_hostname = "${module.live.elb_hostname}"
    elb_name     = "${module.live.elb_name}"
    fqdn         = "${module.live.fqdn}"
    component    = "${module.live.component}"
    log_group    = "${module.live.log_group}"
  }
}

output "dark_component" {
  value = {
    asg_name     = "${module.dark.asg_name}"
    elb_hostname = "${module.dark.elb_hostname}"
    elb_name     = "${module.dark.elb_name}"
    fqdn         = "${module.dark.fqdn}"
    component    = "${module.dark.component}"
    log_group    = "${module.dark.log_group}"
  }
}

output "ping_path" {
  value = "${module.live.ping_path}"
}
