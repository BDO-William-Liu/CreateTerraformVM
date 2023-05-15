resource "azurerm_subnet" "mySubnet" {
  name                 = "${var.name}-Subnet"
  resource_group_name  = var.resource_group
  virtual_network_name = var.virtual_network
  address_prefixes     = var.address_prefix
}

resource "azurerm_network_interface" "myNetworkInterface" {
  name                = "${var.name}-NIC"
  location            = var.location
  resource_group_name = azurerm_subnet.mySubnet.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mySubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "myVirtualMachine" {
  name                = var.name
  resource_group_name = azurerm_subnet.mySubnet.resource_group_name
  location            = azurerm_network_interface.myNetworkInterface.location
  size                = var.size
  network_interface_ids = [
    azurerm_network_interface.myNetworkInterface.id
  ]

  storage_os_disk {
    name              = "myOSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}