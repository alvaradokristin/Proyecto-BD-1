using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using System.Dynamic;
using Task = BasesP1.Models.Task;

namespace BasesP1.Controllers
{
    public class ShowController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        [Route("Show/ShowTask/{type:int}/{key}")]
        public IActionResult ShowTasks(int type, string key)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();

            //List of tasks available
            List<Task> tasks = new List<Task>();

            tableHeaders.Add("Codigo");
            tableHeaders.Add("Nombre");
            tableHeaders.Add("Descripcion");
            tableHeaders.Add("FechaInicio");
            tableHeaders.Add("FechaFinalizacion");
            tableHeaders.Add("Estado");
            tableHeaders.Add("Asesor");

            model.Headers = tableHeaders;

            return View("ShowTasks", model);
        }

        [Route("Show/ShowTask/{type:int}/{key}")]
        public IActionResult ShowActivities(int type, string key)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();

            //List of tasks available
            List<Activity> activities = new List<Activity>();

            tableHeaders.Add("Codigo");
            tableHeaders.Add("Nombre");
            tableHeaders.Add("Descripcion");
            tableHeaders.Add("Estado");
            tableHeaders.Add("Tipo");
            tableHeaders.Add("Asesor");

            return View("ShowActivities", model);
        }
    }
}
