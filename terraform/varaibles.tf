# Defines the default names for all resources

variable "rg_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-sports-analytics-dev"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "East US"
}

# --- THIS VARIABLE IS NEW ---
# We now use a fixed, globally unique name for the storage account
# to enable the CI/CD backend.
# The old 'sa_prefix' variable has been removed.
variable "storage_account_name" {
  description = "Globally unique name for the ADLS Gen2 storage account."
  type        = string
  # --- !! CHANGE THIS VALUE !! ---
  default     = "stsportsanalytics12345" # <-- MUST BE GLOBALLY UNIQUE
}

variable "kv_name" {
  description = "Name of the Azure Key Vault"
  type        = string
  default     = "kv-sports-analytics-dev"
}

variable "adf_name" {
  description = "Name of the Azure Data Factory"
  type        = string
  default     = "adf-sports-analytics-dev"
}

variable "dbw_name" {
  description = "Name of the Databricks workspace"
  type        = string
  default     = "dbw-sports-analytics-dev"
}

