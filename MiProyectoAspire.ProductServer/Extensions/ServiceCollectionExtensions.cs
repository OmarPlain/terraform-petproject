using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;


public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        services.AddScoped<IProductRepository, ProductRepository>();
        services.AddScoped<IProductService, ProductService>();
        return services;
    }

    public static IServiceCollection AddDatabaseServices(this IServiceCollection services, IConfiguration configuration)
    {
        // Si existe ProductsDb es que se está ejecutando en un entorno, si no, se ejecuta en desarrollo y se usa la base de datos SQLite local
        // Si se ejecuta en entorno, va a buscar la ruta de la bbdd de Docker a appsettings.json
        // Como hemos creado la bbdd en Docker, la ruta de la bbdd es /data/products.db, y en appsettings.json se ha configurado así
        var connectionString = configuration.GetConnectionString("productsdb");

        services.AddDbContext<ProductDbContext>(options =>
            options.UseNpgsql(connectionString));
        return services;
    }
}