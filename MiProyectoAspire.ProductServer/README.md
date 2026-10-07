
$ dotnet ef migrations add InitialCreate
dotnet ef database update

dotnet ef migrations add SeedProducts
$ dotnet ef database update


DOCKER
Para construir la imagen de Docker:
docker build --no-cache -t miproyecto-productapi .
Para ejecutar la imagen de Docker:
docker run --rm -p 8080:8080 miproyecto-productapi


SQLite no necesita un contenedor porque es un fichero, este fichero puede ser persistido en un volumen de Docker.