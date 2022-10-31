using Microsoft.AspNetCore.Mvc;

namespace BasesP1.Controllers
{
    public class QuoteController : Controller
    {
        public IActionResult AddQuote()
        {
            return View();
        }
    }
}
