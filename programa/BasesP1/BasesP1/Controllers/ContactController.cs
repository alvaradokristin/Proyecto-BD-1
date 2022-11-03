using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.Dynamic;
using Type = BasesP1.Models.Type;

namespace BasesP1.Controllers
{
    public class ContactController : Controller
    {
        private const string Category = "CC";

        public IConfiguration Configuration { get; }

        public ContactController(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IActionResult LoadAddContact()
        {
            ViewData["Title"] = "Agregar Contacto a Cliente";

            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            //Get all the data from the catalogs
            ClientData clientData = new ClientData(this.Configuration);
            List<Zone> zones = clientData.getZones();
            List<Sector> sectors = clientData.getSectors();
            List<User> users = clientData.getUsers();
            List<Client> clients = clientData.getClients();

            ContactData contactData = new ContactData(this.Configuration);
            List<Type> types = contactData.getTypes(Category);
            List<Status> status = contactData.getStatus(Category);

            model.Zones = zones;
            model.Sectors = sectors;
            model.Users = users;
            model.Clients = clients;
            model.Types = types;
            model.Status = status;

            return View("AddContact", model);
        }

        [HttpPost]
        public IActionResult AddContact(Contact newContact)
        {
            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            // Add the new contact to the BD
            ContactData contactData = new ContactData(this.Configuration);
            contactData.addContact(newContact);

            //Get the data for the table
            List<Contact> contacts = contactData.getAllContacts();

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();
            tableHeaders.Add("Codigo Cliente");
            tableHeaders.Add("Nombre Cuenta");
            tableHeaders.Add("Nombre Contacto");
            tableHeaders.Add("Motivo");
            tableHeaders.Add("Correo");
            tableHeaders.Add("Telefono");
            tableHeaders.Add("Dirección");
            tableHeaders.Add("Descripción");
            tableHeaders.Add("Sector");
            tableHeaders.Add("Estado");
            tableHeaders.Add("Zona");
            tableHeaders.Add("Tipo");
            tableHeaders.Add("Login Asesor");
            tableHeaders.Add("Acción");
            tableHeaders.Add("Tareas");
            tableHeaders.Add("Actividades");

            //Add elements to the general model
            model.Contacts = contacts;
            model.Headers = tableHeaders;

            ViewData["Title"] = "Contactos a Clientes";

            return View("ShowAllContacts", model);
        }

        public IActionResult ShowContactByClient()
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            //Get the data for the dropdown
            ClientData clientData = new ClientData(this.Configuration);
            List<Client> clients = clientData.getClients();

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();

            tableHeaders.Add("Codigo Cliente");
            tableHeaders.Add("Nombre Cuenta");
            tableHeaders.Add("Nombre Contacto");
            tableHeaders.Add("Motivo");
            tableHeaders.Add("Correo");
            tableHeaders.Add("Telefono");
            tableHeaders.Add("Dirección");
            tableHeaders.Add("Descripción");
            tableHeaders.Add("Sector");
            tableHeaders.Add("Estado");
            tableHeaders.Add("Zona");
            tableHeaders.Add("Tipo");
            tableHeaders.Add("Login Asesor");
            tableHeaders.Add("Tareas");
            tableHeaders.Add("Actividades");

            model.Headers = tableHeaders;
            model.Clients = clients;
            model.Contacts = null;

            ViewData["Title"] = "Mostrar Contacto por Cliente";

            return View("ShowContactByClient", model);
        }

        public IActionResult LoadContactsByClient(string CodigoCliente)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            //Get the data for the dropdown
            ClientData clientData = new ClientData(this.Configuration);
            List<Client> clients = clientData.getClients();

            //Get the data for the table
            ContactData contactData = new ContactData(this.Configuration);
            List<Contact> contacts = contactData.getClientsByContact(CodigoCliente);

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();

            tableHeaders.Add("Codigo de Cliente");
            tableHeaders.Add("Nombre de Cuenta");
            tableHeaders.Add("Nombre De Contacto");
            tableHeaders.Add("Motivo");
            tableHeaders.Add("Correo");
            tableHeaders.Add("Telefono");
            tableHeaders.Add("Dirección");
            tableHeaders.Add("Descripción");
            tableHeaders.Add("Sector");
            tableHeaders.Add("Estado");
            tableHeaders.Add("Zona");
            tableHeaders.Add("Tipo");
            tableHeaders.Add("Login Asesor");
            tableHeaders.Add("Tareas");
            tableHeaders.Add("Actividades");

            model.Headers = tableHeaders;
            model.Clients = clients;
            model.Contacts = contacts;

            ViewData["Title"] = "Mostrar Contacto por Cliente";

            return View("ShowContactByClient", model);
        }

        public IActionResult ShowAllContacts()
        {
            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            ContactData contactData = new ContactData(this.Configuration);

            List<Contact> contacts = contactData.getAllContacts();

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();
            tableHeaders.Add("Codigo de Cliente");
            tableHeaders.Add("Nombre de Cuenta");
            tableHeaders.Add("Nombre Contacto");
            tableHeaders.Add("Motivo");
            tableHeaders.Add("Correo");
            tableHeaders.Add("Telefono");
            tableHeaders.Add("Dirección");
            tableHeaders.Add("Descripción");
            tableHeaders.Add("Sector");
            tableHeaders.Add("Estado");
            tableHeaders.Add("Zona");
            tableHeaders.Add("Tipo");
            tableHeaders.Add("Login Asesor");
            //tableHeaders.Add("Acción");
            tableHeaders.Add("Tareas");
            tableHeaders.Add("Actividades");

            //Add elements to the general model
            model.Contacts = contacts;
            model.Headers = tableHeaders;

            ViewData["Title"] = "Contactos a Clientes";

            return View("ShowAllContacts", model);
        }
    }
}
