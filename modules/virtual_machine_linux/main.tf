resource "azurerm_public_ip" "ip_public" {
  count = var.enable_public_ip_address ? 1 : 0

  name                = "pip-${lower(var.vm_name)}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.ip_allocation
  domain_name_label   = var.vm_name
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.vm_name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal-nic-${var.vm_name}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.ip_allocation
    public_ip_address_id          = var.enable_public_ip_address ? azurerm_public_ip.ip_public[0].id : null
  }
}

resource "random_string" "random" {
  count   = var.enable_boot_diagnostics ? 1 : 0
  length  = 12
  special = false
  upper   = false
}

resource "azurerm_storage_account" "boot_diagnostics" {
  count                    = var.enable_boot_diagnostics ? 1 : 0
  name                     = "stobootdiag${lower(random_string.random[count.index].result)}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create (and display) an SSH key
resource "tls_private_key" "linux_key" {
  count     = var.generate_admin_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "linuxkey" {
  count    = var.generate_admin_ssh_key ? 1 : 0
  filename = "linuxkey.pem"
  content  = tls_private_key.linux_key[count.index].private_key_pem
  #file_permission = "0400"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = [azurerm_network_interface.nic.id]
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = var.disable_password_authentication
  admin_password                  = var.admin_password

  dynamic "admin_ssh_key" {
    for_each = var.generate_admin_ssh_key ? ["this"] : []
    content {
      username   = var.admin_username
      public_key = tls_private_key.linux_key[0].public_key_openssh
    }
  }

  source_image_reference {
    publisher = var.os_publisher
    offer     = var.os_offer
    sku       = var.os_sku
    version   = var.os_version
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  boot_diagnostics {
    storage_account_uri = var.enable_boot_diagnostics ? azurerm_storage_account.boot_diagnostics[0].primary_blob_endpoint : null
  }
}

resource "azurerm_managed_disk" "data_disk" {
  for_each             = var.data_disks
  name                 = "${azurerm_linux_virtual_machine.vm.name}-disk00${each.key}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.storage_account_type
  disk_size_gb         = each.value.disk_size_gb
  create_option        = var.create_option
}

resource "azurerm_virtual_machine_data_disk_attachment" "data" {
  for_each           = var.data_disks
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  managed_disk_id    = azurerm_managed_disk.data_disk[each.key].id
  lun                = each.key
  caching            = each.value.caching
}