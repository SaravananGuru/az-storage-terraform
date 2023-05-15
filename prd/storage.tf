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