# Network Config
variable "subnet_id" {
  description = "Subnet for Mongo node"
}

variable "security_group" {
  description = "Security group for Mongo cluster"
}

variable "key_name" {
  description = "Name of EC2 keypair to launch MongoDB instances with"
}

variable "iam_instance_profile" {
  description = "IAM instance profile for Mongo EC2 instances"
}

variable "s3_bucket_name" {
  description = "Name of s3 bucket that stores Mongo bootstrap files"
}

# Mongo Config
variable "node_name" {
  description = "Name of mongo node"
}

variable "mongo_version" {
  description = "Version of MongoDB"
}

variable "admin_username" {
  description = "Username for Mongo admin account"
}

variable "instance_type" {
  description = "AWS instance type"
}

variable "volume_size" {
  description = "EBS Volume Size (data) for node"
}

variable "ami_name" {
  description = "AMI name for Mongo node"
}

variable "port" {
  description = "Port to run MongoDB"
}

variable "replica_set_name" {
  description = "MongoDB replica set name"
}

variable "secondary0_ip" {
  default     = ""
  description = "AMI for Mongo node"
}

variable "secondary1_ip" {
  default     = ""
  description = "AMI for Mongo node"
}

# App DB Config
variable "db_name" {
  description = "Database name for app"
}

variable "db_username" {
  description = "Username for app db"
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
