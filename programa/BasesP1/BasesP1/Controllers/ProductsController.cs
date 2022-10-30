using Microsoft.AspNetCore.Mvc;

namespace BasesP1.Controllers
{
    public class ProductsController : Controller
    {
        public IActionResult AddProduct()
        {
            return View();
        }
    }
}
