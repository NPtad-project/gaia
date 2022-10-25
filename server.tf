resource "azurerm_network_interface" "playground-server-nic" {
  name = "server-nic"
  location = data.azurerm_resource_group.playground-rg.location
  resource_group_name = data.azurerm_resource_group.playground-rg.name

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.playground-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# cloud-init configuration
data "template_file" "init" {
  template = "${file("${path.module}/init_scripts/init.yaml")}"
  vars = {
    DBPassword = "password"
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename = "cloud-init-part-001"
    content_type = "text/cloud-config"
    content = "${data.template_file.init.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${file("${path.module}/init_scripts/bash.sh")}"
    filename     = "test_bash_file"
  }

  part {
    filename = "cloud-init-part-002"
    content_type = "text/cloud-config"
    content = "${file("${path.module}/init_scripts/2_init.yaml")}"
  }
}

#output metadata for checking the script
output metadata {
  value = data.template_cloudinit_config.config.part
}


resource "azurerm_linux_virtual_machine" "server" {
  name = "playground-server"
  computer_name = "server"
  resource_group_name = data.azurerm_resource_group.playground-rg.name
  location = data.azurerm_resource_group.playground-rg.location
  size = "Standard_D2s_v3"
  admin_username = "ftsadmin"
  admin_password = var.jumpbox-password

  # This is where we pass our cloud-init.
  custom_data = data.template_cloudinit_config.config.rendered

  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.playground-server-nic.id,
  ]
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "SUSE"
    offer     = "sles-sap-15-sp3"
    sku       = "gen2"
    version   = "latest"
  }
}

