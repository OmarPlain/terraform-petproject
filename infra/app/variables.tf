variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Region of the resources"
  type        = string
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
}

variable "container_app_environment_name" {
  description = "The name of the Azure Container App Environment"
  type        = string
}

variable "managed_identity_name_front" {
  description = "The name of the managed identity for the web frontend"
  type        = string
}

variable "managed_identity_name_back" {
  description = "The name of the managed identity for the backend"
  type        = string
}

variable "acr_sku" {
  description = "The SKU of the Azure Container Registry"
  type        = string
}

# POSTGRESQL VARIABLES
variable "postgres_server_name" {
  description = "Name of the PostgreSQL Flexible Server"
  type        = string
}

variable "postgres_database_name" {
  description = "Name of the PostgreSQL database"
  type        = string
}

variable "postgres_admin_username" {
  description = "PostgreSQL administrator username"
  type        = string
  sensitive   = true
}

variable "postgres_admin_password" {
  description = "PostgreSQL administrator password"
  type        = string
  sensitive   = true
}
