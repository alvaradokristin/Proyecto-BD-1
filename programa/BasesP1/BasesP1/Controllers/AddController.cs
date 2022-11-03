using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.Dynamic;
using Task = BasesP1.Models.Task;
using Type = BasesP1.Models.Type;

namespace BasesP1.Controllers
{
    public class AddController : Controller
    {
        private const string CatActivity = "Actividad";
        private const string CatTask = "Tarea";

        public IConfiguration Configuration { get; }

        public AddController(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        [Route("Add/AddActivity/type={type:int}/key={key}&mtv={mtv}")]
        //Type: type of query to run
        //Key: Foreign key to add to the query
        public IActionResult LoadAddActivity(int type, string key, string mtv)
        {
            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            //Get all the data from the catalogs
            ClientData clientData = new ClientData(this.Configuration);
            List<User> users = clientData.getUsers();

            ContactData contactData = new ContactData(this.Configuration);
            List<Status> status = contactData.getStatus(CatActivity);
            List<Type> types = contactData.getTypes(CatActivity);

            model.ParamType = type;
            model.ParamKey = key;
            model.ParamMot = mtv;
            model.Users = users;
            model.Status = status;
            model.Types = types;
            return View("AddActivity", model);
        }
        [HttpPost]
        public IActionResult AddActivity(Activity activity, int type, string key, string mtv)
        {
            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            //Add the task to the DB
            GenData genData = new GenData(this.Configuration);
            genData.addActivity(activity);

            //Get all the data from the catalogs
            ClientData clientData = new ClientData(this.Configuration);
            List<User> users = clientData.getUsers();

            ContactData contactData = new ContactData(this.Configuration);
            List<Status> status = contactData.getStatus(CatActivity);
            List<Type> types = contactData.getTypes(CatActivity);

            model.ParamType = type;
            model.ParamKey = key;
            model.ParamMot = mtv;
            model.Users = users;
            model.Status = status;
            model.Types = types;
            return View("AddActivity", model);
        }

        [Route("Add/AddTask/type={type:int}/key={key}&mtv={mtv}")]
        //Type: type of query to run
        //Key: Foreign key to add to the query
        public IActionResult LoadAddTask(int type, string key, string mtv)
        {
            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            //Get all the data from the catalogs
            ClientData clientData = new ClientData(this.Configuration);
            List<User> users = clientData.getUsers();

            ContactData contactData = new ContactData(this.Configuration);
            List<Type> types = contactData.getTypes(CatTask);
            List<Status> status = contactData.getStatus(CatTask);

            model.ParamType = type;
            model.ParamKey = key;
            model.ParamMot = mtv;
            model.Users = users;
            model.Types = types;
            model.Status = status;
            return View("AddTask", model);
        }

        [HttpPost]
        public IActionResult AddTask(Task newTask,int type, string key, string mtv)
        {
            //Create a model that will contain different models
            dynamic model = new ExpandoObject();

            //Add the task to the DB
            GenData genData = new GenData(this.Configuration);
            genData.addTask(newTask);

            //Get all the data from the catalogs
            ClientData clientData = new ClientData(this.Configuration);
            List<User> users = clientData.getUsers();

            ContactData contactData = new ContactData(this.Configuration);
            List<Type> types = contactData.getTypes(CatTask);
            List<Status> status = contactData.getStatus(CatTask);
            model.ParamType = type;
            model.ParamKey = key;
            model.ParamMot = mtv;
            model.Users = users;
            model.Types = types;
            model.Status = status;
            return View("AddTask", model);
        }
    }
}