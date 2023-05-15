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
  account_name                  = "stnewaccfordemo"
  account_tier                  = "Standard"
  adls_replication              = "LRS"
  containers                    = {
    test = { type = "blob", access_type = "private" },
    test2 = { type = "blob", access_type = "private" },
    test3 = { type = "blob", access_type = "private" }
  }
  account_kind                  = "StorageV2"
  private_endpoints = {
    az-sbx = {
    subnet_id            = azurerm_subnet.az_subnet.id
    subresource_name     = "blob"
    private_dns_zone_id  = azurerm_private_dns_zone.blob.id
    is_manual_connection = false
    allow_on_prem_access = true
    },
    az-sbx-dfs = {
    subnet_id            = azurerm_subnet.az_subnet.id
    subresource_name     = "dfs"
    private_dns_zone_id  = azurerm_private_dns_zone.dfs.id
    is_manual_connection = false
    allow_on_prem_access = true
    }
  }

  virtual_network_subnet_ids = []
}

# storage account creation

module "DataLakeStorage" {
  source                           = "github.com/SaravananGuru/az-storage-template.git"
  name                             = local.account_name
  resource_group_name              = azurerm_resource_group.az_rg.name
  # labels_context                 = module.centralus_labels.context
  storage_account_enable_hns       = true
  storage_account_kind 		         = local.account_kind
  storage_account_tier		         = local.account_tier
  storage_account_replication_type = local.adls_replication
  private_endpoints                = local.private_endpoints
  containers                       = local.containers
  # tags                             = module.centralus_labels.tags
  virtual_network_subnet_ids       = local.virtual_network_subnet_ids
}