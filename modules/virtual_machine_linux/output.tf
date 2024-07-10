output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "vm_fqdn" {
  value = [
    for vm in azurerm_public_ip.ip_public : vm.fqdn
  ]
}

output "vm_public_ip" {
  value = [
    for vm in azurerm_public_ip.ip_public : vm.ip_address
  ]
}