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
            List<Currency> currencies = clientData.getCurrencies();
            ClientDataContainer clientDataContainer = new ClientDataContainer();
            clientDataContainer.zones = zones;
            clientDataContainer.sectors = sectors;
            clientDataContainer.user_logins = users;
            clientDataContainer.currencies = currencies;

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
            ClientData clientData = new ClientData(this.Configuration);
            List<Sector> sectors = clientData.getSectors();
            ClientDataContainer clientDataContainer = new ClientDataContainer();
            clientDataContainer.sectors = sectors;
            clientDataContainer.clients = null;

            return View("ClientsBySector", clientDataContainer);
        }

        public IActionResult LoadClientsBySector(string sectorName)
        {
            ClientData clientData = new ClientData(this.Configuration);
            List<Sector> sectors = clientData.getSectors();
            List<Client> clients = clientData.getClientsBySector(sectorName);
            ClientDataContainer clientDataContainer = new ClientDataContainer();
            clientDataContainer.sectors = sectors;
            clientDataContainer.clients = clients;

            return View("ClientsBySector", clientDataContainer);
        }

        public IActionResult ShowClientsByZone()
        {
            ClientData clientData = new ClientData(this.Configuration);
            List<Zone> zones = clientData.getZones();
            ClientDataContainer clientDataContainer = new ClientDataContainer();
            clientDataContainer.zones = zones;
            clientDataContainer.clients = null;


            return View("ClientsByZone", clientDataContainer);
        }
        public IActionResult LoadClientsByZone(string zoneName)
        {
            ClientData clientData = new ClientData(this.Configuration);
            List<Zone> zones = clientData.getZones();
            List<Client> clients = clientData.getClientsByZone(zoneName);
            ClientDataContainer clientDataContainer = new ClientDataContainer();
            clientDataContainer.zones = zones;
            clientDataContainer.clients = clients;

            return View("ClientsByZone", clientDataContainer);
        }
        public IActionResult ShowClientsByQuotes()
        {
            ClientData clientData = new ClientData(this.Configuration);
            List<Quotation> quotes = clientData.getQuotes();
            ClientDataContainer clientDataContainer = new ClientDataContainer();
            clientDataContainer.quotes = quotes;
            clientDataContainer.clients = null;

            return View("ClientsByQuotes", clientDataContainer);
        }

        public IActionResult LoadClientsByQuotes(Int16 quotationNumber)
        {
            ClientData clientData = new ClientData(this.Configuration);
            List<Quotation> quotes = clientData.getQuotes();
            List<Client> clients = clientData.getClientsByQuotes(quotationNumber);
            ClientDataContainer clientDataContainer = new ClientDataContainer();
            clientDataContainer.quotes = quotes;
            clientDataContainer.clients = clients;

            return View("ClientsByQuotes", clientDataContainer);
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
