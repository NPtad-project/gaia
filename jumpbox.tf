resource "azurerm_network_interface" "playground-jumpbox-nic" {
  name = "jumpbox-nic"
  location = data.azurerm_resource_group.playground-rg.location
  resource_group_name = data.azurerm_resource_group.playground-rg.name

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.playground-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.jumpbox-ip.id
  }
}

resource "azurerm_windows_virtual_machine" "jumpbox" {
  name = "playground-jumpbox"
  computer_name = "jumpbox"
  resource_group_name = data.azurerm_resource_group.playground-rg.name
  location = data.azurerm_resource_group.playground-rg.location
  size = "Standard_D2s_v3"
  admin_username = "ftsadmin"
  admin_password = var.jumpbox-password
  network_interface_ids = [
    azurerm_network_interface.playground-jumpbox-nic.id,
  ]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}