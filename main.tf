module "create-azure-vm" {
    source = "./AzureVMTerraform"

    name = var.name
    location = var.location
    size = var.size
    admin_username = var.admin_username
    admin_password = var.admin_password
    resource_group = var.resource_group
    virtual_network = var.virtual_network
    address_prefix = var.address_prefix
}