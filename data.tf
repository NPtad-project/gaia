# resource group information
data "azurerm_resource_group" "playground-rg" {
  name = var.rg-name
}

output "playground-rg-id"{
  value = data.azurerm_resource_group.playground-rg.id
}

output "playground-rg-name"{
 value = data.azurerm_resource_group.playground-rg.name
}

output "playground-rg-location"{
  value = data.azurerm_resource_group.playground-rg.location
}


data "azurerm_public_ip" "ip-first-time" {
  name = azurerm_public_ip.jumpbox-ip.name
  resource_group_name = data.azurerm_resource_group.playground-rg.name

  depends_on = [
    azurerm_public_ip.jumpbox-ip
  ]
}

#jumpbox server public IP address
output "public_ip_address" {
  value = azurerm_windows_virtual_machine.jumpbox.public_ip_address
}

output "private_ip_address" {
  value = azurerm_windows_virtual_machine.jumpbox.private_ip_address
}

# test output
output "environment-var-path1" {
  value = "${path.module}"
}

output "environment-var-path2" {
  value = "${path.cwd}"
}