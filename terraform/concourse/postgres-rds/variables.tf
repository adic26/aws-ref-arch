variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "storage" {
  description = "Storage size in GB"
}

variable "instance_class" {
  description = "Type of RDS instance"
}

variable "identifier" {
  description = "Identifier for your DB"
}

variable "username" {
  description = "User name"
}

variable "password" {
  description = "password, provide through your ENV variables"
}

variable "db_subnet_group" {
  description = "Name of postgres RDS DB subnet group"
}

variable "db_security_group_id" {
  default = "Security group id for postgres"
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

variable "vpc_security_group_ids" {
  type        = "list"
  description = "RDS DB Security group id for concourse stack (ex: \"sg-47df2e36\")"
}
