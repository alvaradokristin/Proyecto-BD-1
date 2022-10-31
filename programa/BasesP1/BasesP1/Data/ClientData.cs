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
    }
}
