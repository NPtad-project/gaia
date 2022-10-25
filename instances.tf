# public IP address instance
resource "azurerm_public_ip" "jumpbox-ip" {
  name = "Jumpbox-ip"
  resource_group_name = data.azurerm_resource_group.playground-rg.name
  location = data.azurerm_resource_group.playground-rg.location
  allocation_method = "Dynamic"
}

# Network instance
resource "azurerm_virtual_network" "playground-vnet" {
  name = "playground-vnet"
  address_space = ["10.0.0.0/16"]
  location = data.azurerm_resource_group.playground-rg.location
  resource_group_name = data.azurerm_resource_group.playground-rg.name
}

resource "azurerm_subnet" "playground-subnet" {
  name = "playground-subnet"
  resource_group_name = data.azurerm_resource_group.playground-rg.name
  virtual_network_name = azurerm_virtual_network.playground-vnet.name
  address_prefixes = [ "10.0.0.0/24" ]
}