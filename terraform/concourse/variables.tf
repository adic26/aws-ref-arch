#
#
# Env specific
#
#

variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region to launch servers."
}

variable "security_group_id" {
  type        = "string"
  description = "Security group id for concourse stack (ex: \"sg-47df2e36\")"
}

variable "subnet_id" {
  type        = "string"
  description = "Subnet id  for web/worker EC2 instance (ex: \"subnet-1f359c33\")"
}

variable "db_subnet_group" {
  type        = "string"
  description = "Name of postgres RDS DB subnet group (ex: \"temp_postgres\")"
}

variable "host_zone" {
  type        = "string"
  description = "A hosted zone is a collection of resource record sets for a specified domain (ex: example.com)"
  default     = "hbccommon.private.hbc.com"
}

variable "iam_instance_profile" {
  type        = "string"
  description = "Instance profile for application (ex: \"Temp_Concourse_Role\")"
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
# Concourse specific
#
#

variable "team_name" {
  type        = "string"
  description = "Name of team who is provisioning this stack (ex: \"rogue-squadron\")"
}

variable "instance_type" {
  type        = "string"
  description = "Type of EC2 instance for web/worker (ex: \"t2.small\")"
}

variable "concourse_username" {
  type        = "string"
  description = "Concourse admin username"
}

variable "concourse_password" {
  type        = "string"
  description = "Concourse admin password"
}

variable "key_name" {
  type        = "string"
  description = "Keypair for web/worker EC2 instance"
}

variable "worker_volume_size" {
  type        = "string"
  description = "Size of worker volume in GB (ex: \"10\")"
}

variable "web_volume_size" {
  type        = "string"
  description = "Size of web volume in GB (ex: \"10\")"
}

#
#
# Concourse DB specific
#
#

variable "db_username" {
  type        = "string"
  description = "Postgres username"
}

variable "db_password" {
  type        = "string"
  description = "Postgres password"
}

variable "db_storage_size" {
  type        = "string"
  description = "Storage size in GB for postgres RDS (ex: \"10\")"
}

variable "db_instance_class" {
  type        = "string"
  description = "Type of RDS instance (ex: \"db.t2.micro\")"
}

variable "db_security_groups" {
 type        = "string"
 description = "RDS DB Security group id for concourse stack (ex: \"sg-47df2e36\")"
}

variable "db_security_group_id" {
  type        = "string"
  description = "Security group id for postgres concourse stack"
}