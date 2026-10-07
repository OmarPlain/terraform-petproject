resource "azurerm_postgresql_flexible_server" "app" {
  name                = var.postgres_server_name
  resource_group_name = data.azurerm_resource_group.app.name
  location            = data.azurerm_resource_group.app.location
  zone                = "1"

  version    = "16"
  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768

  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password

  backup_retention_days = 7

  public_network_access_enabled = true

  tags = {
    environment = "dev"
    project     = "petproject"
  }
}

resource "azurerm_postgresql_flexible_server_database" "app" {
  name      = var.postgres_database_name
  server_id = azurerm_postgresql_flexible_server.app.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Sin esta regla, Container Apps no puede alcanzar el servidor
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name             = "AllowAllAzureServicesAndResourcesWithinAzureIps"
  server_id        = azurerm_postgresql_flexible_server.app.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
