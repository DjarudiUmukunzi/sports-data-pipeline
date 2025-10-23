# Defines the default names for all resources, just like the healthcare project

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

variable "sa_prefix" {
  description = "Prefix for the ADLS Gen2 storage account name. A random string will be appended."
  type        = string
  default     = "stsportsanalytics"
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