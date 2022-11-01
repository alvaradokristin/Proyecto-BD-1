using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using NuGet.Configuration;

namespace BasesP1.Controllers
{
    public class ClientsController : Controller
    {
        public IConfiguration Configuration { get; }

        public ClientsController(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IActionResult loadAddClientView()
        {
            ClientData clientData = new ClientData(this.Configuration);
            List<Zone> zones = clientData.getZones();
            List<Sector> sectors = clientData.getSectors();
            List<User> users = clientData.getUsers();
            ClientDataContainer clientDataContainer = new ClientDataContainer();
            clientDataContainer.zones = zones;
            clientDataContainer.sectors = sectors;
            clientDataContainer.user_logins = users;

            return View("AddClient", clientDataContainer);
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

        [HttpPost]
        public IActionResult AddClient(Client client)
        {
            ClientData clientData = new ClientData(this.Configuration);
            clientData.addClient(client);
            List<Client> clients = clientData.getClients();
            return View("Clients", clients);
        }
    }
}
