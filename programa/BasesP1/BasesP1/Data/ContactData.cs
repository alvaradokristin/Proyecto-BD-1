using BasesP1.Models;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Security.Policy;
using Type = BasesP1.Models.Type;

namespace BasesP1.Data
{
    public class ContactData
    {
        public IConfiguration Configuration { get; }

        public ContactData(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        //Method to add a new method to the DB
        public void addContact(Contact newContact)
        {
            try
            {
                string connectionString = Configuration["ConnectionStrings:RealConnection"];
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string sql = $"EXEC [dbo].[insertarContactoCliente] '{newContact.CodigoCliente}','{newContact.Motivo}','{newContact.NombreContacto}','{newContact.Correo}'" +
                        $",'{newContact.Telefono}','{newContact.Direccion}','{newContact.Descripcion}','{newContact.Sector}','{newContact.Estado}','{newContact.Zona}'" +
                        $",'{newContact.Tipo}','{newContact.Asesor}'";

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

        //Method to get a list of all the types available for that category
        public List<Type> getTypes(string category)
        {
            List<Type> types = new List<Type>();
            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM tipoBasico('{category}')";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            Type type = new Type();
                            type.Nombre = "" + dataReader["nombre"];
                            types.Add(type);
                        }

                    }
                }
                connection.Close();
            }
            return types;
        }

        //Method to get a list of all the status available for that category
        public List<Status> getStatus(string category)
        {
            List<Status> status = new List<Status>();
            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM estadoBasico('{category}')";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            Status temp = new Status();
                            temp.Nombre = "" + dataReader["nombre"];
                            status.Add(temp);
                        }

                    }
                }
                connection.Close();
            }
            return status;
        }

        //Method to get all the products available on the DB
        public List<Contact> getAllContacts()
        {
            List<Contact> contacts = new List<Contact>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM obtenerTodosContactos()";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Contact contact = new Contact();

                            contact.CodigoCliente = "" + reader["codigoCliente"];
                            contact.Motivo = "" + reader["motivo"];
                            contact.NombreContacto = "" + reader["nombreContacto"];
                            contact.Correo = "" + reader["correo"];
                            contact.Telefono = "" + reader["telefono"];
                            contact.Direccion = "" + reader["direccion"];
                            contact.Descripcion = "" + reader["descripcion"];
                            contact.Sector = "" + reader["sector"];
                            contact.Estado = "" + reader["nombre_estado"];
                            contact.Zona = "" + reader["zona"];
                            contact.Tipo = "" + reader["nombre_tipo"];
                            contact.Asesor = "" + reader["asesor"];
                            contact.NombreCuenta = "" + reader["nombreCuenta"];

                            contacts.Add(contact);
                        }
                        reader.Close();
                    }
                }
                connection.Close();
            }
            return contacts;
        }

        //Method to get all the products available on the DB
        public List<Contact> getClientsByContact(string CodigoCliente)
        {
            List<Contact> contacts = new List<Contact>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM obtenerContactosCliente('{CodigoCliente}')";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Contact contact = new Contact();

                            contact.CodigoCliente = "" + reader["codigoCliente"];
                            contact.Motivo = "" + reader["motivo"];
                            contact.NombreContacto = "" + reader["nombreContacto"];
                            contact.Correo = "" + reader["correo"];
                            contact.Telefono = "" + reader["telefono"];
                            contact.Direccion = "" + reader["direccion"];
                            contact.Descripcion = "" + reader["descripcion"];
                            contact.Sector = "" + reader["sector"];
                            contact.Estado = "" + reader["nombre_estado"];
                            contact.Zona = "" + reader["zona"];
                            contact.Tipo = "" + reader["nombre_tipo"];
                            contact.Asesor = "" + reader["asesor"];
                            contact.NombreCuenta = "" + reader["nombreCuenta"];

                            contacts.Add(contact);
                        }
                        reader.Close();
                    }
                }
                connection.Close();
            }
            return contacts;
        }
    }
}
