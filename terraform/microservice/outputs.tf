output "elb_hostname" {
  value = "${aws_elb.elb.dns_name}"
}

output "elb_name" {
  value = "${aws_elb.elb.name}"
}

output "ping_path" {
  value = "${var.ping_path}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.asg.name}"
}

output "fqdn" {
  value = "${aws_route53_record.entry.fqdn}"
}

output "component" {
  value = "${var.component}"
}

output "log_group" {
  value = "${aws_cloudwatch_log_group.log_group.name}"
}

output "app_name" {
  value = "${var.app_name}"
}

output "docker_image_deployed" {
  value = "${var.image}"
}