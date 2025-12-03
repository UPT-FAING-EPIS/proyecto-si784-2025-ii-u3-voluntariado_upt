terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0"
    }
  }
  backend "azurerm" {
    # Se configurará vía variables de entorno o backend-config
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "voluntariado" {
  name     = "rg-voluntariado-${var.environment}"
  location = var.location
  tags = {
    Environment = var.environment
    Project     = "Voluntariado UPT"
  }
}

# App Service Plan (Gratuito F1 para desarrollo)
resource "azurerm_service_plan" "voluntariado" {
  name                = "asp-voluntariado-${var.environment}"
  location            = azurerm_resource_group.voluntariado.location
  resource_group_name = azurerm_resource_group.voluntariado.name
  os_type            = "Linux"
  sku_name           = "F1" # Free tier para desarrollo
}

# Web App para Java JSP
resource "azurerm_linux_web_app" "voluntariado" {
  name                = "webapp-voluntariado-${var.environment}"
  location            = azurerm_resource_group.voluntariado.location
  resource_group_name = azurerm_resource_group.voluntariado.name
  service_plan_id     = azurerm_service_plan.voluntariado.id

  site_config {
    application_stack {
      java_server         = "TOMCAT"
      java_server_version = "9.0"
      java_version        = "17"
    }
  }
}