public interface IProductRepository
{
    Task<IEnumerable<Product>> GetAllProductsAsync();
    Task<Product?> GetProductByIdAsync(int id);
    Task<Product> AddProductAsync(Product newProduct);
    Task<Product?> UpdateProductAsync(Product updatedProduct);
    Task<bool> DeleteProductAsync(Product product);
}