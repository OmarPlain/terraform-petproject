using Microsoft.AspNetCore.Mvc;

/* 
    SE ENCARGA DE TODO LO RELACIONADO CON HTTP
    Cuando llegue una peticion por ejemplo GET /api/products
    se ejecutara el constructor que necesita la dependencia IProductService, quien la provee?
    va a buscarla en el contenedor de dependencias y se la inyecta al constructor
    el Program.cs a traves de builder.Services.AddScoped<IProductService, ProductService>();
 */

[ApiController]
[Route("api/[controller]")]
public class ProductsController: ControllerBase
{
    private readonly IProductService _productService;

    public ProductsController(IProductService productService)
    {
        _productService = productService;
    }

    [HttpGet]
    public async Task<IEnumerable<ProductDTO>> GetAllProducts()
    {
        var products = await _productService.GetAllProductsAsync();
        return products.Select(ProductMapping.ToDTO);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ProductDTO>> GetProductById(int id)
    {
        var product = await _productService.GetProductByIdAsync(id);
        
        if(product is null)
        {
            return NotFound();
        }
        return Ok(ProductMapping.ToDTO(product));
    }

    [HttpPost]
    public async Task<ActionResult<ProductDTO>> AddProduct(CreateProductDTO newProduct)
    {
        var addedProduct = await _productService.AddProductAsync(newProduct);
        return CreatedAtAction(nameof(GetProductById), new { id = addedProduct.Id }, ProductMapping.ToDTO(addedProduct));
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<ProductDTO>> UpdateProduct(int id, UpdateProductDTO updatedProduct)
    {

        var product = await _productService.UpdateProductAsync(id, updatedProduct);
        return product is not null ? Ok(ProductMapping.ToDTO(product)) : NotFound();
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> DeleteProduct(int id)
    {
        var deleted = await _productService.DeleteProductAsync(id);
        return deleted ? NoContent() : NotFound();
    }
}