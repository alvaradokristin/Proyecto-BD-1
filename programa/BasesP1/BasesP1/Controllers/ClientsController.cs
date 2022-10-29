using Microsoft.AspNetCore.Mvc;

namespace BasesP1.Controllers
{
    public class ClientsController : Controller
    {
        public IActionResult AddClient()
        {
            return View();
        }
        public IActionResult ShowClients()
        {
            return View("Clients");
        }
        public IActionResult ShowClientsBySector()
        {
            return View("ClientsBySector");
        }
        public IActionResult ShowClientsByZone()
        {
            return View("ClientsByZone");
        }
    }
}
