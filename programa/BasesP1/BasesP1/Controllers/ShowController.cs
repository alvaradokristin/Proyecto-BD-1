using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using System.Dynamic;
using Task = BasesP1.Models.Task;

namespace BasesP1.Controllers
{
    public class ShowController : Controller
    {
        public IConfiguration Configuration { get; }

        public ShowController(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IActionResult Index()
        {
            return View();
        }

        [Route("Show/ShowTasks/clt={client}")]
        public IActionResult ShowTasks(string client)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();

            //Get the table data
            GenData genData = new GenData(this.Configuration);
            List<Task> tasks = genData.getTasksByContact(client);

            tableHeaders.Add("Codigo");
            tableHeaders.Add("Nombre");
            tableHeaders.Add("Descripcion");
            tableHeaders.Add("FechaInicio");
            tableHeaders.Add("FechaFinalizacion");
            tableHeaders.Add("Estado");
            tableHeaders.Add("Asesor");

            model.Headers = tableHeaders;
            model.Tasks = tasks;

            return View("ShowTasks", model);
        }

        [Route("Show/ShowActivities/clt={client}")]
        public IActionResult ShowActivities(string client)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();

            //Get the table data
            GenData genData = new GenData(this.Configuration);
            List<Activity> activities = genData.getActivitiesByContact(client);

            tableHeaders.Add("Codigo");
            tableHeaders.Add("Nombre");
            tableHeaders.Add("Descripcion");
            tableHeaders.Add("Estado");
            tableHeaders.Add("Tipo");
            tableHeaders.Add("Asesor");

            model.Headers = tableHeaders;
            model.Activities = activities;

            return View("ShowActivities", model);
        }
    }
}
