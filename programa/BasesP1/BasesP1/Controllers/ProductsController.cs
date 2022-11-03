using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using System.Dynamic;

namespace BasesP1.Controllers
{
    public class ProductsController : Controller
    {

        public IConfiguration Configuration { get; }

        public ProductsController(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IActionResult LoadAddProduct()
        {
            ViewData["Title"] = "Agregar Producto";

            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            //Get all the available product families
            ProdFamilyData productData = new ProdFamilyData(this.Configuration);
            List<FamiliaProducto> prodFam = productData.getProdFamilies();

            model.Families = prodFam;
            return View("AddProduct", model);
        }

        [HttpPost]
        public IActionResult AddProduct(Product newProduct)
        {
            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            ProductData productData = new ProductData(this.Configuration);
            productData.addProduct(newProduct);

            List<Product> products = productData.getProducts();
            string[] tableHeaders = new string[] {
                "Codigo"
                ,"Nombre"
                ,"Activo"
                ,"Descripcion"
                ,"Precio"
                ,"Codigo Familia"
                ,"Acción"
            };

            //Add elements to the general model
            model.Products = products;
            model.Headers = tableHeaders;

            return View("ShowProducts", model);
        }
        
        [Route("Products/EditProduct/code={prod}")]
        public IActionResult LoadEditProduct(string prod)
        {
            ViewData["Title"] = "Editar Producto - " + prod;

            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            //Get all the available product families
            ProdFamilyData famProdData = new ProdFamilyData(this.Configuration);
            List<FamiliaProducto> prodFam = famProdData.getProdFamilies();

            //Get the data from the product
            ProductData productData = new ProductData(this.Configuration);
            Product product = productData.getProduct(prod);

            model.Families = prodFam;
            model.Product = product;
            return View("EditProduct", model);
        }

        [HttpPost]
        public IActionResult EditProduct(Product product)
        {
            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            ProductData productData = new ProductData(this.Configuration);
            productData.editProduct(product);

            List<Product> products = productData.getProducts();
            string[] tableHeaders = new string[] {
                "Codigo"
                ,"Nombre"
                ,"Activo"
                ,"Descripcion"
                ,"Precio"
                ,"Codigo Familia"
                ,"Acción"
            };

            //Add elements to the general model
            model.Products = products;
            model.Headers = tableHeaders;

            return View("ShowProducts", model);
        }

        [Route("Products/ShowProductReport/{type:int}")]
        public IActionResult ShowProductReport(int type)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();

            //List of products with the values from the query
            List<Product> data = new List<Product>();

            ProductData queryData = new ProductData(this.Configuration);

            //Types:
            //    1: Best Seller Products
            //    2: Best Seller Products Family
            //    3: Most Quoted Products
            //    4: Most Quoted Products Family
            if (type == 1)
            {
                ViewData["Title"] = "Productos más vendidos";
                tableHeaders.Add("Codigo");
                tableHeaders.Add("Nombre");
                tableHeaders.Add("Activo");
                tableHeaders.Add("Descripcion");
                tableHeaders.Add("Precio");
                tableHeaders.Add("Codigo Familia");
                tableHeaders.Add("Ventas");

                //Get the data from the query
                data = queryData.getReport(type);

                model.Headers = tableHeaders;
                model.Data = data;
                model.Type = type;

                return View("ShowProductReport", model);

            }
            else if (type == 2)
            {
                ViewData["Title"] = "Familia de Productos más vendidos";
                tableHeaders.Add("Codigo");
                tableHeaders.Add("Nombre");
                tableHeaders.Add("Activo");
                tableHeaders.Add("Descripcion");
                tableHeaders.Add("Ventas");

                //Get the data from the query
                data = queryData.getReport(type);

                model.Headers = tableHeaders;
                model.Data = data;
                model.Type = type;

                return View("ShowProductReport", model);
            }
            else if (type == 3)
            {
                ViewData["Title"] = "Productos más cotizados";
                tableHeaders.Add("Codigo");
                tableHeaders.Add("Nombre");
                tableHeaders.Add("Activo");
                tableHeaders.Add("Descripcion");
                tableHeaders.Add("Precio");
                tableHeaders.Add("Codigo Familia");
                tableHeaders.Add("Cotizaciones");

                //Get the data from the query
                data = queryData.getReport(type);

                model.Headers = tableHeaders;
                model.Data = data;
                model.Type = type;

                return View("ShowProductReport", model);
            }
            else if (type == 4)
            {
                ViewData["Title"] = "Familia de Productos más cotizados";
                tableHeaders.Add("Codigo");
                tableHeaders.Add("Nombre");
                tableHeaders.Add("Activo");
                tableHeaders.Add("Descripcion");
                tableHeaders.Add("Cotizaciones");

                //Get the data from the query
                data = queryData.getReport(type);

                model.Headers = tableHeaders;
                model.Data = data;
                model.Type = type;

                return View("ShowProductReport", model);
            }

            return View();
        }
        public IActionResult ShowProducts()
        {
            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            ProductData productData = new ProductData(this.Configuration);
            List<Product> products = productData.getProducts();
            string[] tableHeaders = new string[] {
                "Codigo"
                ,"Nombre"
                ,"Activo"
                ,"Descripcion"
                ,"Precio"
                ,"Codigo Familia"
                ,"Acción"
            };

            //Add elements to the general model
            model.Products = products;
            model.Headers = tableHeaders;

            return View("ShowProducts", model);
        }
    }
}
