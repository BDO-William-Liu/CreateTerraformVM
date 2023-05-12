resource "azurerm_resource_group" "myResourceGroup" {
    name = "${var.name}-ResourceGroup"
    location = var.location
}

resource "azurerm_subnet" "mySubnet" {
  name                 = "${var.name}-Subnet"
  resource_group_name  = azurerm_resource_group.myRG.name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefix
}
// mySubnet depends on name argument of myResourceGroup

resource "azurerm_network_interface" "myNetworkInterface" {
  name                = "${var.name}-NIC"
  location            = azurerm_resource_group.myRG
  resource_group_name = azurerm_resource_group.myRG

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mySubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
// myNetworkInterface depends on name argument of myResourceGroup and id attribute reference of mySubnet

resource "azurerm_windows_virtual_machine" "myVirtualMachine" {
  name                = var.name
  resource_group_name = azurerm_resource_group.myResourceGroup.name
  location            = azurerm_resource_group.myResourceGroup.location
  size                = var.size
  admin_username      = var.adminUsername
  admin_password      = var.adminPassword
  network_interface_ids = [
    azurerm_network_interface.myNetworkInterface.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
// myVirtualMachine depends on arguments of myResourceGroup, mySubnet, and myVirtualInterface