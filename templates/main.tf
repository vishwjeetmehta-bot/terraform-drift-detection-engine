terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "drift_test" {
  name     = "rg-drift-sample"
  location = "eastus"
  tags = {
    Owner     = "SRE"
    ManagedBy = "Terraform"
  }
}

