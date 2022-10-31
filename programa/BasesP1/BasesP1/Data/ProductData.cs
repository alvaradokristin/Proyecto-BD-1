using BasesP1.Models;
using System.Data.SqlClient;

namespace BasesP1.Data
{
    public class ProductData
    {
        public IConfiguration Configuration { get; }

        public ProductData(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public List<Product> getProducts()
        {
            List<Product> products = new List<Product>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM obtenerProductos()";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Product product = new Product();

                            product.Codigo = "" + reader["codigo"];
                            product.Nombre = "" + reader["nombre"];
                            product.Activo = bool.Parse("" + reader["activo"]);
                            product.Descripcion = "" + reader["descripcion"];
                            product.PrecioEstandar = Convert.ToDecimal("" + reader["precioEstandar"]);
                            product.CodigoFamilia = "" + reader["codigo_familia"];

                            products.Add(product);
                        }
                        reader.Close();
                    }
                }
                connection.Close();
            }
            return products;
        }
    }
}
