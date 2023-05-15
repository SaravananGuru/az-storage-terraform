resource "azurerm_virtual_network" "az_vnet" {
  name                = "az-network-1"
  location            = azurerm_resource_group.az_rg.location
  resource_group_name = azurerm_resource_group.az_rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet-az-1"
    address_prefix = "10.0.1.0/24"
  }
}

resource "azurerm_subnet" "az_subnet" {
  name                 = "subnet-az-1"
  resource_group_name  = azurerm_resource_group.az_rg.name
  virtual_network_name = azurerm_virtual_network.az_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}