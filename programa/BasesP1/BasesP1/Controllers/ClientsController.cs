using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;

namespace BasesP1.Controllers
{
    public class ClientsController : Controller
    {
        public IConfiguration Configuration { get; }

        public ClientsController(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IActionResult AddClient()
        {
            return View();
        }
        public IActionResult ShowClients()
        {
            ClientData clientData = new ClientData(this.Configuration);
            List<Client> clients = clientData.getClients();

            return View("Clients", clients);
        }
        public IActionResult ShowClientsBySector()
        {
            return View("ClientsBySector");
        }
        public IActionResult ShowClientsByZone()
        {
            return View("ClientsByZone");
        }
        public IActionResult ShowClientsByQuotes()
        {
            return View("ClientsByQuotes");
        }
        public IActionResult ShowClientsByQuotedAmount()
        {
            return View("ClientsByQuotedAmount");
        }

        public void deleteClient(string codigo)
        {
            System.Diagnostics.Debug.WriteLine(codigo);
        }
    }
}
