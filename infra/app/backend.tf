# Configuracion del backend remoto para almacenar el estado de Terraform en Azure Storage
terraform {
  backend "azurerm" {
    resource_group_name  = "petprojectterraform-dev-rg-01"
    storage_account_name = "petprojectdevst01"
    container_name       = "tfstate"
    key                  = "petproject-dev.tfstate"
  }
}
