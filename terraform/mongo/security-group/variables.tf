variable "replica_set_name" {
  description = "Name of MongoDB replica set"
}

variable "port" {
  description = "Port to run MongoDB"
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
