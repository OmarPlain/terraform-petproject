var builder = DistributedApplication.CreateBuilder(args);
builder.AddDockerComposeEnvironment("docker");

var postgres = builder.AddPostgres("postgres");

var productsDb = postgres.AddDatabase("productsdb");

if (builder.ExecutionContext.IsRunMode) // Cuando ejecutamos con dotnet run (local)
{
    var productServer = builder
        .AddProject<Projects.MiProyectoAspire_ProductApi>("productServer")
        .WithHttpHealthCheck("/health")
        .WithExternalHttpEndpoints()
        .WithReference(productsDb)
        .WaitFor(productsDb);

    var webfrontend = builder
        .AddViteApp("webfrontend", "../frontend")
        .WithEnvironment(
            "VITE_API_BASE_URL",
            productServer.GetEndpoint("http"))
        .WaitFor(productServer);
}
else // cuando ejecutamos con aspire publish
{
    var productServer = builder
        .AddDockerfile("productServer", "../MiProyectoAspire.ProductServer")
        .WithHttpEndpoint(targetPort: 8080, name: "http")
        .WithHttpHealthCheck("/health")
        .WithExternalHttpEndpoints()
        .WithReference(productsDb)
        .WaitFor(productsDb);

    var webfrontend = builder
        .AddViteApp("webfrontend", "../frontend")
        .WithHttpEndpoint(targetPort: 80, name: "http")
        .WithExternalHttpEndpoints()
        .WaitFor(productServer);
}

builder.Build().Run();
