terraform {
  backend "azurerm" {
    # These values will be filled in by our CI/CD pipeline
    # We are just telling Terraform to use this backend
  }
}

