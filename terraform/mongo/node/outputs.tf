output "ip" {
  value = "${aws_instance.mongo_node.private_ip}"
}

output "public_ip" {
  value = "${aws_instance.mongo_node.public_ip}"
}
