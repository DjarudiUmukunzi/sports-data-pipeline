# This single file creates all our Azure resources

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location

  lifecycle {
    ignore_changes = all
  }
}

# 2. ADLS Gen2 Storage Account
resource "azurerm_storage_account" "adls" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true

  lifecycle {
    ignore_changes = all
  }
}

# 3. Storage Containers (Bronze, Silver, Gold)
resource "azurerm_storage_container" "bronze" {
  name                  = "bronze"
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_storage_container" "silver" {
  name                  = "silver"
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"

  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_storage_container" "gold" {
  name                  = "gold"
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"

  lifecycle {
    ignore_changes = all
  }
}

# 4. Storage Container for Terraform State
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"

  lifecycle {
    ignore_changes = all
  }
}

# 5. Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                = var.kv_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  lifecycle {
    ignore_changes = all
  }
}

# 6. Azure Databricks Workspace
resource "azurerm_databricks_workspace" "dbw" {
  name                = var.dbw_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"

  lifecycle {
    ignore_changes = all
  }
}

# 7. Azure Data Factory
resource "azurerm_data_factory" "adf" {
  name                = var.adf_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = all
  }
}

data "azurerm_client_config" "current" {}
