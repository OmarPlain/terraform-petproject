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

URL publica https://petproject-dev-ca-01.wonderfulfield-3969ca0f.westeurope.azurecontainerapps.io/