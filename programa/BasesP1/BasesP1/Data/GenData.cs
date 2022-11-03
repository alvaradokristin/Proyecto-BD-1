using BasesP1.Models;
using System.Data.SqlClient;
using System.Diagnostics;
using Activity = BasesP1.Models.Activity;
using Task = BasesP1.Models.Task;

namespace BasesP1.Data
{
    public class GenData
    {
        public IConfiguration Configuration { get; }

        public GenData(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        //Method to add a task to a contact
        public void addTask(Task newTask)
        {
            try
            {
                string connectionString = Configuration["ConnectionStrings:RealConnection"];
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string sql = $"EXEC [dbo].[insertarTareaContacto] '{newTask.Codigo}','{newTask.Nombre}','{newTask.Descripcion}','{newTask.FechaInicio}'" +
                        $",'{newTask.FechaFinalizacion}','{newTask.Estado}','{newTask.Asesor}','{newTask.FKCont}','{newTask.FKMot}'";

                    using (var command = new SqlCommand(sql, connection))
                    {
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("Exception: " + ex.ToString());
            }
        }

        //Method to get all the task by client contact
        public List<Task> getTasksByContact(string CodigoCliente)
        {
            List<Task> tasks = new List<Task>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM obtenerTareasContacto('{CodigoCliente}')";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        //Temp values to format the date
                        String tempString;
                        DateTime tempDateTime;

                        while (reader.Read())
                        {
                            Task temp = new Task();

                            temp.Codigo = "" + reader["codigo"];
                            temp.Nombre = "" + reader["nombre"];
                            temp.Descripcion = "" + reader["descripcion"];

                            tempString = "" + reader["fechaInicio"]; // Convert what we get from DB into String
                            tempDateTime = DateTime.Parse(tempString); // Convert String to DateTime
                            temp.FechaInicio = tempDateTime.ToShortDateString(); // Convert DateTime to String with format SmallDate

                            tempString = "" + reader["fechaFinalizacion"]; // Convert what we get from DB into String
                            tempDateTime = DateTime.Parse(tempString); // Convert String to DateTime
                            temp.FechaFinalizacion = tempDateTime.ToShortDateString(); // Convert DateTime to String with format SmallDate

                            temp.Estado = "" + reader["nombre_estado"];
                            temp.Asesor = "" + reader["usuario_asignado"];
                            temp.FKCont = "" + reader["cliente_contacto"];
                            temp.FKMot = "" + reader["motivo_contacto"];

                            tasks.Add(temp);
                        }
                        reader.Close();
                    }
                }
                connection.Close();
            }
            return tasks;
        }

        //Method to add an activity to a contact
        public void addActivity(Activity newActivity)
        {
            try
            {
                string connectionString = Configuration["ConnectionStrings:RealConnection"];
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string sql = $"EXEC [dbo].[insertarActividadContacto] '{newActivity.Codigo}','{newActivity.Nombre}','{newActivity.Descripcion}'" +
                        $",'{newActivity.Estado}','{newActivity.Tipo}','{newActivity.Asesor}','{newActivity.FKCont}','{newActivity.FKMot}'";

                    using (var command = new SqlCommand(sql, connection))
                    {
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine("Exception: " + ex.ToString());
            }
        }

        //Method to get all the activities by client contact
        public List<Activity> getActivitiesByContact(string CodigoCliente)
        {
            List<Activity> activities = new List<Activity>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM obtenerActividadesContacto('{CodigoCliente}')";
                Debug.WriteLine(sql);
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Activity temp = new Activity();

                            temp.Codigo = "" + reader["codigo"];
                            temp.Nombre = "" + reader["nombre"];
                            temp.Descripcion = "" + reader["descripcion"];
                            temp.Estado = "" + reader["nombre_estado"];
                            temp.Tipo = "" + reader["nombre_tipo"];
                            temp.Asesor = "" + reader["usuario_asignado"];
                            temp.FKCont = "" + reader["cliente_contacto"];
                            temp.FKMot = "" + reader["motivo_contacto"];

                            activities.Add(temp);
                        }
                        reader.Close();
                    }
                }
                connection.Close();
            }
            return activities;
        }
    }
}
