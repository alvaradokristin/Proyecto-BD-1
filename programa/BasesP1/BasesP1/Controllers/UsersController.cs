using Microsoft.AspNetCore.Mvc;

namespace BasesP1.Controllers
{
    public class UsersController : Controller
    {
        public IActionResult AddUser()
        {
            return View();
        }
        public IActionResult ShowUsers()
        {
            return View("Users");
        }
    }
}
