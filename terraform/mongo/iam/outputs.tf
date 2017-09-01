output "instance_profile_id" {
  value = "${aws_iam_instance_profile.read_s3.id}"
}
