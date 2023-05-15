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
  account_name                  = "stdesignitsftwr"
  account_tier                  = "Standard"
  adls_replication              = "LRS"
  containers                    = {
    raw = { type = "blob", access_type = "private" },
    stage = { type = "blob", access_type = "private" },
    analytic = { type = "blob", access_type = "private" }
  }
  account_kind                  = "StorageV2"
  private_endpoints = {
    agility-sbx = {
    subnet_id            = data.azurerm_subnet.pep_agility_sbx.id
    subresource_name     = "blob"
    private_dns_zone_id  = local.private_dns_zones["privatelink.blob.core.windows.net"].id
    is_manual_connection = false
    on_prem_zone_name    = local.on_premise_dns.private_dns_zones["privatelink.blob.core.windows.net"].name
    on_prem_rg           = local.on_premise_dns.private_dns_zones["privatelink.blob.core.windows.net"].resource_group_name
    allow_on_prem_access = true
    },
    agility-sbx-dfs = {
    subnet_id            = data.azurerm_subnet.pep_agility_sbx.id
    subresource_name     = "dfs"
    private_dns_zone_id  = local.private_dns_zones["privatelink.dfs.core.windows.net"].id
    is_manual_connection = false
    on_prem_zone_name    = local.on_premise_dns.private_dns_zones["privatelink.dfs.core.windows.net"].name
    on_prem_rg           = local.on_premise_dns.private_dns_zones["privatelink.dfs.core.windows.net"].resource_group_name
    allow_on_prem_access = true
    }
  }

  virtual_network_subnet_ids = []
}

# storage account creation

module "DataLakeStorage" {
  source                           = "https://github.com/SaravananGuru/az-storage-template.git"
  name                             = local.account_name
  resource_group_name              = local.resource_obj.name
  labels_context                   = module.centralus_labels.context
  storage_account_enable_hns       = true
  storage_account_kind 		         = local.account_kind
  storage_account_tier		         = local.account_tier
  storage_account_replication_type = local.adls_replication
  private_endpoints                = local.private_endpoints
  containers                       = local.containers
  tags                             = module.centralus_labels.tags
  virtual_network_subnet_ids       = local.virtual_network_subnet_ids
}