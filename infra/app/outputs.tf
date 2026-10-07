output "resource_group_name" {
  description = "Nombre del Resource Group"
  value       = data.azurerm_resource_group.app.name
}

output "acr_name" {
  description = "The name of the Azure Container Registry"
  value       = var.acr_name
}

output "acr_login_server" {
  description = "URL del Azure Container Registry"
  value       = azurerm_container_registry.app.login_server
}