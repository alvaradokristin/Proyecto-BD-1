using Azure.Core;
using BasesP1.Models;
using System.Data;
using System.Data.SqlClient;

namespace BasesP1.Data
{
    public class ProdFamilyData
    {
        public IConfiguration Configuration { get; }

        public ProdFamilyData(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        public List<FamiliaProducto> getProdFamilies()
        {
            List<FamiliaProducto> families = new List<FamiliaProducto>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM obtenerFamProd()";

                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            FamiliaProducto prodFam = new FamiliaProducto();

                            prodFam.Codigo = "" + reader["codigo"];
                            prodFam.Nombre = "" + reader["nombre"];
                            prodFam.Activo = bool.Parse("" + reader["activo"]);
                            prodFam.Descripcion = "" + reader["descripcion"];

                            families.Add(prodFam);
                        }
                        reader.Close();
                    }
                }
                connection.Close();
            }
            return families;
        }
    }
}
