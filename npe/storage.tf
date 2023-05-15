terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.54.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=1.6.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Local value declaration

locals {
  storage_account_suffix = [
    {
      account_name                  = "stprodshpequip"
      account_tier                  = "Standard"
      adls_replication              = "LRS"
      containers                    = "raw,stage,analytic,hubscan"
      file_shares                   = ""
      is_hns_enabled                = "true"
      is_private_end_point_required = "false"
      queues                        = ""
      eai                           = "3535162"
    }]

    private_endpoints = [{
      name                 = "stprdshpequipblobst"
      storage_account      = "stprodshpequip"
      subnet_id            = "/subscriptions/aa365c78-baef-4db6-9b9a-682db6e1de6d/resourceGroups/centralus-fxe-data-mgmt-prd-network-rg/providers/Microsoft.Network/virtualNetworks/centralus-fxe-data-mgmt-prd-fxconnect-vnet/subnets/datalake"
      subresource_name     = "blob"
      zone_name            = "privatelink.blob.core.windows.net"
      private_dns_zone_id  = "/subscriptions/aa365c78-baef-4db6-9b9a-682db6e1de6d/resourceGroups/centralus-fxe-data-mgmt-prd-private-dns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
      is_manual_connection = false
      virtual_network_subnets = ["/subscriptions/aa365c78-baef-4db6-9b9a-682db6e1de6d/resourceGroups/centralus-fxe-data-mgmt-prd-network-rg/providers/Microsoft.Network/virtualNetworks/centralus-fxe-data-mgmt-prd-main-vnet/subnets/devops-agents", "/subscriptions/aa365c78-baef-4db6-9b9a-682db6e1de6d/resourceGroups/centralus-fxe-data-mgmt-prd-network-rg/providers/Microsoft.Network/virtualNetworks/centralus-fxe-data-mgmt-prd-fxconnect-vnet/subnets/datalake"]
      allow_subnet_rule = false 
      allow_pep = true
    }]
}


# storage account creation

module "DataLakeStorage" {
  source                     = "git::git@ssh.dev.azure.com:v3/fxe-data-mgmt/common/terraform-azurerm-auxiliaryDataLakeStorage?ref=main"
  storage_account_list       = local.storage_account_list
  environment_name           = local.environment_name
  location                   = local.location
  resource_group_name        = azurerm_resource_group.this["primary"].name
  subnet_id                  = local.subnet_id
  subresource_names          = local.subresource_names
  private_endpoints          = local.private_endpoints
  tags                       = local.common_dmo_tags
  app_tags                   = local.pip_tags
}