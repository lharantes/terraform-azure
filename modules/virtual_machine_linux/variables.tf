variable "resource_group_name" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type    = string
  default = "P@$$w0rd!2024"
}

variable "disable_password_authentication" {
  type    = bool
  default = true
}

variable "generate_admin_ssh_key" {
  type = bool
}

variable "enable_public_ip_address" {
  type    = bool
  default = true
}

variable "enable_boot_diagnostics" {
  type    = bool
  default = false
}

variable "os_publisher" {
  type = string
}

variable "os_offer" {
  type = string
}

variable "os_sku" {
  type = string
}

variable "os_version" {
  type = string
}

variable "os_disk_caching" {
  type = string
}

variable "os_disk_storage_account_type" {
  type = string
}

variable "ip_allocation" {
  type    = string
  default = "Dynamic"
}

variable "data_disks" {
  type = map(any)
}

variable "storage_account_type" {
  type    = string
  default = "Standard_LRS"
}

variable "disk_size_gb" {
  type    = number
  default = 1
}

variable "create_option" {
  type    = string
  default = "Empty"
}