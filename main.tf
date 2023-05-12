module "create-azure-vm" {
    source = "./AzureVMTerraform"

    name = var.name
    location = var.location
    size = var.size
    admin_username = var.admin_username
    admin_password = var.admin_password
    virtual_network_name = var.virtual_network_name
    address_prefix = var.address_prefix
}