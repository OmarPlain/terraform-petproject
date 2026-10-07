public static class ProductMapping
{

    public static ProductDTO ToDTO(Product product)
    {
        return new ProductDTO
        {
            Id = product.Id,
            Name = product.Name,
            Price = product.Price
        };
    }
    public static Product ToEntity(CreateProductDTO createProductDTO)
    {
        return new Product
        {
            Name = createProductDTO.Name,
            Price = createProductDTO.Price
        };
    }
    public static Product ToEntity(UpdateProductDTO updateProductDTO)
    {
        return new Product
        {
            Name = updateProductDTO.Name,
            Price = updateProductDTO.Price
        };
    }
    public static void UpdateEntity(Product product, UpdateProductDTO updateProductDTO)
    {
        product.Name = updateProductDTO.Name;
        product.Price = updateProductDTO.Price;
    }
}