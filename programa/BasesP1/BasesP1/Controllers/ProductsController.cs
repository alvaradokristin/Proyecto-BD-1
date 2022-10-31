using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Data.SqlClient;
using System.Diagnostics;

namespace BasesP1.Controllers
{
    public class ProductsController : Controller
    {
        SqlCommand command = new SqlCommand();
        SqlDataReader reader;

        SqlConnection connection = new SqlConnection();

        private void FetchData()
        {
            try
            {
                connection.Open();
                command.Connection = connection;
                command.CommandText = "SELECT * FROM Producto";
                reader = command.ExecuteReader();
                while (reader.Read())
                {
                    Debug.WriteLine("Producto : " + reader["codigo"]);
                }
                connection.Close();

            }
            catch (Exception ex)
            {
                Debug.WriteLine("Exception: " + ex.ToString());
            }
        }
        public IActionResult AddProduct()
        {
            return View();
        }

        public IActionResult EditProduct()
        {
            return View();
        }

        public IActionResult ShowProductReport()
        {
            return View();
        }
        public IActionResult ShowProducts()
        {
            FetchData();
            return View();
        }
    }
}
