data "azurerm_resource_group" "app" {
  name = var.resource_group_name
}

resource "azurerm_storage_account" "terraform_state" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.app.name
  location                 = data.azurerm_resource_group.app.location

  account_tier              = "Standard" // No hay ottro mas bajo
  account_replication_type = "LRS" // Local Redundant Storage para tener varias copias del mismo fichero

  min_tls_version = "TLS1_2"

  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.terraform_state.id
  container_access_type = "private"
}

# Es necesario asignar permisos para que GitHub Actions pueda acceder al estado de Terraform
resource "azurerm_role_assignment" "terraform_state" {
  scope                = azurerm_storage_account.terraform_state.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.github_actions_principal_id
}

resource "azurerm_role_assignment" "terraform_resources" {
  scope                = data.azurerm_resource_group.app.id
  role_definition_name = "Contributor"
  principal_id         = var.github_actions_principal_id
}

resource "azurerm_role_assignment" "terraform_role_assignments" {
  scope                = data.azurerm_resource_group.app.id
  role_definition_name = "Role Based Access Control Administrator"
  principal_id         = var.github_actions_principal_id
}
