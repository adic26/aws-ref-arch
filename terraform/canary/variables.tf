#
#
# Env specific
#
#

variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region to deploy stack"
}

variable "shared_kms_key" {
  type        = "string"
  description = "key for shared parameters"
}

variable "lb_security_group" {
  type        = "string"
  description = "Security group for load balancer (ex: \"sg-xxxxxxxx\")"
}

variable "app_security_group" {
  type        = "string"
  description = "Security group for application (ex: \"sg-xxxxxxxx\")"
}

variable "hbc_banner" {
  type        = "string"
  description = "Banner deployed within (ex: multi-tenant, bay, saks...)"
}

variable "hbc_env" {
  type        = "string"
  description = "Environment executing within (i.e. production or pre-production)"
}

variable "hbc_group" {
  type        = "string"
  description = "HBC Tech group name (ex: back-office, path-to-purchase, search)"
}

#
#
# App specific
#
#

variable "app_name" {
  type        = "string"
  description = "Name of application (ex: \"hello-world\")"
}

variable "instance_type" {
  type        = "string"
  description = "Type of EC2 instance to use for each container"
}

variable "dark_image" {
  type        = "string"
  description = "Docker image for dark container, including version"
}

variable "live_image" {
  type        = "string"
  description = "Docker image for live container, including version"
}

variable "key_name" {
  type        = "string"
  description = "Security group for application (ex: \"super-secret-key\")"
}

variable "app_port" {
  type        = "string"
  description = "Port to run application that is exposed in docker image (ex: \"8080\")"
}

variable "asg_min" {
  type        = "string"
  description = "Minimum instances for app autoscaling group (ex: \"1\")"
}

variable "asg_max" {
  type        = "string"
  description = "Maximum instances for app autoscaling group (ex: \"2\")"
}

variable "asg_desired" {
  type        = "string"
  description = "Desired instances for app autoscaling group (ex: \"1\")"
}

variable "ping_path" {
  type        = "string"
  description = "Endpoint for application health check (ex: \"/_internal_/ping\")"
}

variable "env_vars" {
  type = "map"
}

variable "subnet_ids_app" {
  type = "list"
}

variable "subnet_ids_elb" {
  type = "list"
}