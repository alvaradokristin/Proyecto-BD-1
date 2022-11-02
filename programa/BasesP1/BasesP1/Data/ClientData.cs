using BasesP1.Models;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace BasesP1.Data

{
    public class ClientData
    {
        public IConfiguration Configuration { get; }

        public ClientData(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public List<Client> getClients()
        {

            List<Client> clients = new List<Client>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM Cliente";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {

                            Client client = new Client();

                            client.codigo = Convert.ToString(dataReader["codigo"]);
                            client.nombreCuenta = Convert.ToString(dataReader["nombreCuenta"]);
                            client.correo = Convert.ToString(dataReader["correo"]);
                            client.telefono = Convert.ToString(dataReader["telefono"]);
                            client.celular = Convert.ToString(dataReader["celular"]);
                            client.sitioWeb = Convert.ToString(dataReader["sitioWeb"]);
                            client.informacionAdicional= Convert.ToString(dataReader["informacionAdicional"]);
                            client.zona = Convert.ToString(dataReader["zona"]);
                            client.sector = Convert.ToString(dataReader["sector"]);
                            client.abreviatura_moneda = Convert.ToString(dataReader["abreviatura_moneda"]);
                            client.nombre_moneda = Convert.ToString(dataReader["nombre_moneda"]);
                            client.login_usuario = Convert.ToString(dataReader["login_usuario"]);

                            clients.Add(client);
                        }

                    }
                }
                connection.Close();
            }

            return clients;
        }

        public void addClient(Client client)
        {
            if (client.abreviatura_moneda.Equals("USD"))
            {
                client.nombre_moneda = "dolar";
            }
            if (client.abreviatura_moneda.Equals("CRC"))
            {
                client.nombre_moneda = "colon";
            }
            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"EXEC [dbo].[sp_addClient]{client.codigo},{client.nombreCuenta},'{client.correo}','{client.telefono}','{client.celular}','{client.sitioWeb}','{client.informacionAdicional}','{client.zona}','{client.sector}','{client.abreviatura_moneda}','{client.nombre_moneda}','{client.login_usuario}'";
                using (var command = new SqlCommand(sql, connection))
                {
                    command.ExecuteNonQuery();
                    connection.Close();
                }
            }
        }

        public List<Zone> getZones()
        {
            List<Zone> zones = new List<Zone>();
            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM Zona";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            Zone zone = new Zone();
                            zone.nombre = Convert.ToString(dataReader["nombre"]);
                            zones.Add(zone);
                        }

                    }
                }
                connection.Close();
            }
            return zones;
        }

        public List<Sector> getSectors()
        {
            List<Sector> sectors = new List<Sector>();
            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM Sector";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            Sector sector = new Sector();
                            sector.nombre = Convert.ToString(dataReader["nombre"]);
                            sectors.Add(sector);
                        }
                    }
                }
                connection.Close();
            }
            return sectors;
        }

        public List<User> getUsers()
        {
            List<User> users = new List<User>();
            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM usuarios()";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            User user = new User();
                            user.userLogin = Convert.ToString(dataReader["userLogin"]);
                            user.cedula = Convert.ToString(dataReader["cedula"]);
                            user.nombre = Convert.ToString(dataReader["nombre"]);
                            user.primerApellido = Convert.ToString(dataReader["primerApellido"]);
                            user.segundoApellido = Convert.ToString(dataReader["segundoApellido"]);
                            user.nombre_rol = Convert.ToString(dataReader["nombre_rol"]);
                            user.codigo_departamento = Convert.ToString(dataReader["codigo_departamento"]);
                            users.Add(user);
                        }
                    }
                }
                connection.Close();
            }
            return users;
        }
        public List<Currency> getCurrencies()
        {
            List<Currency> currencies = new List<Currency>();
            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT abreviatura FROM Moneda";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            Currency currency = new Currency();
                            currency.abreviatura = Convert.ToString(dataReader["abreviatura"]);
                            currencies.Add(currency);
                        }
                    }
                }
                connection.Close();
            }
            return currencies;
        }
    }
}
