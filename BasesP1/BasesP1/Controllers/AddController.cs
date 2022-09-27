using Microsoft.AspNetCore.Mvc;

namespace BasesP1.Controllers
{
    public class AddController : Controller
    {
        public IActionResult AddClient()
        {
            return View();
        }

        public IActionResult AddUser()
        {
            return View();
        }

        public IActionResult AddProduct()
        {
            return View();
        }
    }
}