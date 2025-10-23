# This single file creates all our Azure resources, based on the healthcare project structure

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

# 2. Random Suffix for Storage Account
resource "random_string" "sa_suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}

# 3. ADLS Gen2 Storage Account
resource "azurerm_storage_account" "adls" {
  name                     = "${var.sa_prefix}${random_string.sa_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true # This enables ADLS Gen2
}

# 4. Storage Containers
resource "azurerm_storage_container" "bronze" {
  name                  = "bronze"
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "silver" {
  name                  = "silver"
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "gold" {
  name                  = "gold"
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"
}

# 5. Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                = var.kv_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

# 6. Azure Databricks Workspace
resource "azurerm_databricks_workspace" "dbw" {
  name                = var.dbw_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard" # Use 'standard' to save costs
}

# 7. Azure Data Factory
resource "azurerm_data_factory" "adf" {
  name                = var.adf_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  # Create the Managed Identity (the fix from our last project)
  identity {
    type = "SystemAssigned"
  }
}

# --- Data for Role Assignments ---
data "azurerm_client_config" "current" {}

# --- Role Assignments (The fixes from our last project) ---

# 8. Grant ADF Access to Storage
resource "azurerm_role_assignment" "adf_to_adls" {
  scope                = azurerm_storage_account.adls.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.adf.identity[0].principal_id

  depends_on = [
    azurerm_data_factory.adf
  ]
}

# 9. Grant ADF Access to Key Vault (to read/write secrets)
resource "azurerm_key_vault_access_policy" "adf_to_kv" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = azurerm_data_factory.adf.identity[0].tenant_id
  object_id    = azurerm_data_factory.adf.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete"
  ]

  depends_on = [
    azurerm_key_vault.kv,
    azurerm_data_factory.adf
  ]
}