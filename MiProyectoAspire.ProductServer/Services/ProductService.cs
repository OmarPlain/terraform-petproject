/* 
    SE ENCARGA DE LAS REGLAS DE NEGOCIO
 */
public class ProductService : IProductService
{
    private readonly IProductRepository _productRepository;

    public ProductService(IProductRepository productRepository)
    {
        _productRepository = productRepository;
    }

    public async Task<IEnumerable<Product>> GetAllProductsAsync()
    {
        return await _productRepository.GetAllProductsAsync();
    }

    public async Task<Product?> GetProductByIdAsync(int id)
    {
        return await _productRepository.GetProductByIdAsync(id);
    }

    public async Task<Product> AddProductAsync(CreateProductDTO newProduct)
    {
        return await _productRepository.AddProductAsync(ProductMapping.ToEntity(newProduct));
    }
public async Task<Product?> UpdateProductAsync(
    int id,
    UpdateProductDTO updatedProduct)
{
    var product = await _productRepository.GetProductByIdAsync(id);

    if (product is null)
    {
        return null;
    }

    ProductMapping.UpdateEntity(product, updatedProduct);

    return await _productRepository.UpdateProductAsync(product);
}


    public async Task<bool> DeleteProductAsync(int id)
    {

        var product = await _productRepository.GetProductByIdAsync(id);

        if (product is null)
        {
            return false;
        }

        return await _productRepository.DeleteProductAsync(product);
    }
}