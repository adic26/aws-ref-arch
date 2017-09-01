# TF Config
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

# Network Config

variable "subnet_id" {
  description = "Subnet to deploy Mongo nodes"
}

variable "key_name" {
  description = "Name of EC2 kekypair for ssh access to provisioned instances (ex: \"super-secret-key\")"
}

variable "security_group" {
  description = "Name of security group to launch MongoDB instances with"
}

# Mongo Config
variable "admin_username" {
  description = "Username for Mongo admin account"
}

variable "mongo_keyfile" {
  description = "Absolute path to keyfile for mongo replica set"
}

variable "replica_set_name" {
  description = "Name of MongoDB replica set"
}

variable "mongo_version" {
  description = "Version of MongoDB"
  default     = "3.4"
}

variable "port" {
  description = "Port to run MongoDB"
  default     = "27017"
}

variable "instance_type" {
  default     = "m3.xlarge"
  description = "AWS instance type"
}

variable "volume_size" {
  default     = "200"
  description = "EBS Volume Size (data) for node"
}

# App DB config
variable "db_name" {
  description = "Database name for app"
}

variable "db_username" {
  description = "Username for app db"
}

variable "ami_name" {
  default     = "mongo_base"
  description = "Name of the AMI to be used for mongo nodes"
}

# DB Secrets
variable "parameter_key_namespace" {
  description = "Namespace for keys stored in AWS parameter store"
}

variable "admin_password_key" {
  description = "Key used to get password for Mongo admin account from AWS parameter store"
}

variable "db_password_key" {
  description = "Key used to get password for app db from AWS parameter store"
}

variable "hbc_banner" {
  description = "Banner deployed within (ex: multi-tenant, bay, saks...)"
}

variable "hbc_env" {
  description = "Environment executing within (i.e. production or pre-production)"
}

variable "hbc_group" {
  description = "HBC Tech group name (ex: back-office, path-to-purchase, search)"
}
