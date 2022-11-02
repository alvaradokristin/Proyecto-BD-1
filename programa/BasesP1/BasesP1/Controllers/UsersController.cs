using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using System.Dynamic;

namespace BasesP1.Controllers
{
    public class UsersController : Controller
    {
        public IConfiguration Configuration { get; }

        public UsersController(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        public IActionResult AddUser()
        {
            return View();
        }
        public IActionResult ShowUsers()
        {
            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            ClientData productData = new ClientData(this.Configuration);
            List<User> users = productData.getUsers();

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();

            tableHeaders.Add("Login");
            tableHeaders.Add("Cedula");
            tableHeaders.Add("Nombre Completo");
            tableHeaders.Add("Rol");
            tableHeaders.Add("Codigo Departamento");
            tableHeaders.Add("Acciones");

            //Add elements to the general model
            model.Users = users;
            model.Headers = tableHeaders;
            return View("Users", model);
        }
    }
}
