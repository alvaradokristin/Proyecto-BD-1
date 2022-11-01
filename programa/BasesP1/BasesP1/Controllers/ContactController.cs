using Microsoft.AspNetCore.Mvc;

namespace BasesP1.Controllers
{
    public class ContactController : Controller
    {
        public IActionResult AddContact()
        {
            return View();
        }

        public IActionResult ShowContactByClient()
        {
            return View();
        }
    }
}
