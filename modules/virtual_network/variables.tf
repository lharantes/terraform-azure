variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnets" {
  type = map(object({
    name           = string
    address_prefix = string
  }))
}

variable "location" {
  type = string
}