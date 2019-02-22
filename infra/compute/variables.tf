variable "controllers" {
  description = "Number of controller nodes to provision"
  type        = "string"
}

variable "workers" {
  description = "Number of worker nodes to provision"
  type        = "string"
}

variable "subnet" {
  description = "Name of the subnet to place nodes in"
  type        = "string"
}
