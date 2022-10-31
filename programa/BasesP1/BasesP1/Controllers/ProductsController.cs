using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Data.SqlClient;
using System.Diagnostics;

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
            return View();
        }

        public IActionResult EditProduct()
        {
            return View();
        }

        public IActionResult ShowProductReport()
        {
            return View();
        }
        public IActionResult ShowProducts()
        {
            ProductData productData = new ProductData(this.Configuration);
            List<Product> products = productData.getProducts();

            return View("ShowProducts", products);
        }
    }
}
