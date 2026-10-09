Añadimos aspire add docker
Cuando hacemos aspire publish -o ./aspire-output genera el docker-compose

Nuestro flujo ahora es:

                 aspire publish
                       │
                       ▼
                docker-compose
                       │
                       ▼
             PRODUCTSERVER_IMAGE
                       │
                       ▼
                 Docker image
                       │
                       ▼
                Dockerfile
                       │
              ┌────────┴────────┐
              │                 │
           dotnet sdk       dotnet aspnet
              │                 │
              ▼                 ▼
            build            runtime

echo "$TF_VAR_postgres_admin_password"
export TF_VAR_postgres_admin_password='admin123!'

docker build \
  -t petprojectdevacr01.azurecr.io/frontend:latest \
  .
az acr login --name petprojectdevacr01
docker push petprojectdevacr01.azurecr.io/frontend:latest

docker build \
  -t petprojectdevacr01.azurecr.io/productserver:latest \
  .
docker push petprojectdevacr01.azurecr.io/productserver:latest

URL publica https://petproject-dev-ca-01.wonderfulfield-3969ca0f.westeurope.azurecontainerapps.io/


En las GitHub Actions hay que configurar las variables de entorno Settings -> Secrets & Variables -> Actions
POSTGRES_ADMIN_PASSWORD
ACR_NAME
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID
RESOURCE_GROUP_NAME
PROD_RESOURCE_GROUP_NAME