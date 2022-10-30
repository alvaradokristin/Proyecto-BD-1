using Microsoft.AspNetCore.Mvc;

namespace BasesP1.Controllers
{
    public class AddController : Controller
    {
        public IActionResult AddProduct()
        {
            return View();
        }
    }
}