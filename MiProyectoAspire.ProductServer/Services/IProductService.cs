public interface IProductService
{
    Task<IEnumerable<Product>> GetAllProductsAsync();
    Task<Product?> GetProductByIdAsync(int id);
    Task<Product> AddProductAsync(CreateProductDTO newProduct);
    Task<Product?> UpdateProductAsync(int id, UpdateProductDTO updatedProduct);
    Task<bool> DeleteProductAsync(int id);
}