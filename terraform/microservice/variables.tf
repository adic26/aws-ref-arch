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
# Module Specific
#
#

variable "component" {
  type        = "string"
  description = "Name of component (ex: \"live\")"
}

#
#
# App Specific
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

variable "image" {
  type        = "string"
  description = "Docker image for microservice, including version (ex: \"hbc-docker.jfrog.io/toggle-service:latest\")"
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
  type        = "map"
  description = "URI for MongoDB connection (ex: \"mongodb://DB_USERNAME:DB_PASSWORD@DB_HOST/DB_NAME\")"
}

variable "host_zone" {
  type        = "string"
  description = "A hosted zone is a collection of resource record sets for a specified domain (ex: example.com)"
  default     = "hbccommon.private.hbc.com"
}

variable "subnet_ids_app" {
  type = "list"
  description = "List of subnet ids for application autoscaling group (ex: [ \"subnet-xxxxxxxx\", \"subnet-xxxxxxxx\" ])"
}

variable "subnet_ids_elb" {
  type = "list"
  description = "List of subnet ids for  elb  (ex: [ \"subnet-xxxxxxxx\", \"subnet-xxxxxxxx\" ])"
}

#
#
# Support canary deployments
#
#
variable "additional_elb_to_associate_asg" {
  type = "string"
  description = "Name for additional ELB to associate with this services ASG"
  default = ""
}