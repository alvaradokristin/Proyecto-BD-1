using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Hosting;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Diagnostics;
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

        public IActionResult AddProduct()
        {
            ViewData["Title"] = "Agregar Producto";

            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            //Get all the available product families
            ProdFamilyData productData = new ProdFamilyData(this.Configuration);
            List<FamiliaProducto> prodFam = productData.getProdFamilies();

            ////Create a product model to store the values for the new product
            //Product newProduct = new Product();

            ////Asign the data from the website input into an object/variables
            //newProduct.Codigo = Request.Form["app-code"];
            //newProduct.Nombre = Request.Form["app-code"];
            ////newProduct.Activo = bool.Parse(Request.Form["app-code"]);
            //newProduct.Descripcion = Request.Form["app-code"];
            //newProduct.PrecioEstandar = decimal.Parse(Request.Form["app-code"]);
            //newProduct.CodigoFamilia = Request.Form["app-code"];

            model.Families = prodFam;
            return View("AddProduct", model);
        }

        [HttpPost]
        //[ValidateAntiForgeryToken]
        public IActionResult Create([Bind] Product newProduct)
        {
            //Create an object to store the data from the form and send it to the DB
            //Product newProduct = new Product();

            //Get the data from the form
            //newProduct.Codigo = Request.Form["prod-code"];

            ProductData productData = new ProductData(this.Configuration);

            try
            {
                if (ModelState.IsValid)
                {
                    productData.addProduct(newProduct);
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("Exception: " + ex.ToString());
            }

            return View();
        }

        public IActionResult EditProduct()
        {
            return View();
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
