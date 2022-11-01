using Microsoft.AspNetCore.Mvc;
using System.Dynamic;

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
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();

            tableHeaders.Add("Codigo");
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
            tableHeaders.Add("Tareas");
            tableHeaders.Add("Actividades");

            model.Headers = tableHeaders;

            ViewData["Title"] = "Mostrar contacto por cliente";

            return View("ShowContactByClient", model);
        }
    }
}
