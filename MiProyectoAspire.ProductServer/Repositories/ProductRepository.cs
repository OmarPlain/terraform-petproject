
using Microsoft.EntityFrameworkCore;

/*
    SE ENCARGA DEL MANEJO DE DATOS MEDIANTE EF
 */
public class ProductRepository : IProductRepository
{
    private readonly ProductDbContext _context;

    public ProductRepository(ProductDbContext context)
    {
        _context = context;
    }
    public async Task<IEnumerable<Product>> GetAllProductsAsync()
    {
        return await _context.Products.ToListAsync();
    }

    public async Task<Product?> GetProductByIdAsync(int id)
    {
        return await _context.Products.FirstOrDefaultAsync(p => p.Id == id);
    }

    public async Task<Product> AddProductAsync(Product newProduct)
    {
        _context.Products.Add(newProduct);
        await _context.SaveChangesAsync();
        return newProduct;
    }

    public async Task<Product> UpdateProductAsync(Product updatedProduct)
    {
        /* 
            No es necesario llamar a _context.Products.Update(updatedProduct) porque EF Core rastrea los cambios automáticamente 
            y lo hemos hecho en el mapping
        */
        await _context.SaveChangesAsync();
        return updatedProduct;
    }

    public async Task<bool> DeleteProductAsync(Product deletedProduct)
    {
        _context.Products.Remove(deletedProduct);
        await _context.SaveChangesAsync();
        return true;
    }
}