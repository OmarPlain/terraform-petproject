# Para crear el grupo de recursos desde terraform
# resource "azurerm_resource_group" "app" {
#   name     = "petprojectterraform-dev-rg-01"
#   location = "West Europe"
# }

# Como IT ha creado el grupo de recursos utilizamos, sino tendriamos que crearlo nosotros
data "azurerm_resource_group" "app" {
  name = var.resource_group_name
}

resource "azurerm_container_registry" "app" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.app.name
  location            = data.azurerm_resource_group.app.location
  sku                 = var.acr_sku
  admin_enabled       = false
}

resource "azurerm_container_app_environment" "app" {
  name                = var.container_app_environment_name
  location            = data.azurerm_resource_group.app.location
  resource_group_name = data.azurerm_resource_group.app.name
}

# Autenticacion contra el ACR para poder hacer pull de las imagenes
resource "azurerm_user_assigned_identity" "webfrontend" {
  name                = var.managed_identity_name_front
  location            = data.azurerm_resource_group.app.location
  resource_group_name = data.azurerm_resource_group.app.name
}
resource "azurerm_user_assigned_identity" "productserver" {
  name                = var.managed_identity_name_back
  location            = data.azurerm_resource_group.app.location
  resource_group_name = data.azurerm_resource_group.app.name
}

resource "azurerm_role_assignment" "webfrontend_acr_pull" {
  scope                = azurerm_container_registry.app.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.webfrontend.principal_id
}
resource "azurerm_role_assignment" "productserver_acr_pull" {
  scope                = azurerm_container_registry.app.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.productserver.principal_id
}

# Contenedor para el frontend
resource "azurerm_container_app" "webfrontend" {
  name                         = "petproject-dev-ca-01"
  container_app_environment_id = azurerm_container_app_environment.app.id
  resource_group_name          = data.azurerm_resource_group.app.name
  revision_mode                = "Single"

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.webfrontend.id
    ]
  }

  registry {
    server   = azurerm_container_registry.app.login_server
    identity = azurerm_user_assigned_identity.webfrontend.id
  }

  template {
    container {
      name   = "frontend"
      image  = "${azurerm_container_registry.app.login_server}/frontend:latest"
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "PRODUCTSERVER_HOST"
        value = azurerm_container_app.productserver.name
      }

    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    transport        = "auto"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

# Contenedor para el backend
resource "azurerm_container_app" "productserver" {
  name                         = "petproject-dev-ca-02"
  container_app_environment_id = azurerm_container_app_environment.app.id
  resource_group_name          = data.azurerm_resource_group.app.name
  revision_mode                = "Single"

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.productserver.id
    ]
  }

  registry {
    server   = azurerm_container_registry.app.login_server
    identity = azurerm_user_assigned_identity.productserver.id
  }

  secret {
    name  = "productsdb-connection-string"
    value = "Host=${azurerm_postgresql_flexible_server.app.fqdn};Database=${var.postgres_database_name};Username=${var.postgres_admin_username};Password=${var.postgres_admin_password};SSL Mode=Require;Trust Server Certificate=true"
  }

  template {
    min_replicas = 1 // Es necesario en el back porque el front es accesible a internet
    max_replicas = 1
    container {
      name   = "productserver"
      image  = "${azurerm_container_registry.app.login_server}/productserver:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "ASPNETCORE_URLS"
        value = "http://+:8080"
      }

      env {
        name        = "ConnectionStrings__productsdb"
        secret_name = "productsdb-connection-string"
      }
    }
  }

  ingress {
    external_enabled = false
    target_port      = 8080
    transport        = "http"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

}
