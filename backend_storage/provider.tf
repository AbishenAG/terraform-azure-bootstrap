# terraform.required_providers = controls which provider plugins and versions Terraform downloads.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0" # Uses any version from 3.0.0 and above (including patch and minor upgrades) but won't automatically upgrade to a new major version like v4.x
    }
  }
}

provider "azurerm" {
  features {}
}
