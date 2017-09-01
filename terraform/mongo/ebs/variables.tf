
# Network Config
variable "subnet_id" {
  description = "Subnet for Mongo node"
}

variable "security_group" {
  description = "Security group for Mongo cluster"
}

variable "aws_region" {
  type        = "string"
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

# Mongo EBS Config


variable "volume_size" {
  type = "string"
  description = "EBS Volume Size (data) for node"
  default = "200"
}

variable "replica_set_name" {
  description = "MongoDB replica set name"
}

variable "v_count" {
  description = "Count of EBS volume that is to be created"
  default = 1
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