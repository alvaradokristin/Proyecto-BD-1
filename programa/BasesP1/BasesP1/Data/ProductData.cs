using Azure.Core;
using BasesP1.Models;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;

namespace BasesP1.Data
{
    public class ProductData
    {
        public IConfiguration Configuration { get; }

        public ProductData(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        //Method to get all the products available on the DB
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

        //Method to to add a new method to the DB
        public void addProduct(Product newProduct)
        {
            try
            {
                string connectionString = Configuration["ConnectionStrings:RealConnection"];
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string sql = $"EXEC [dbo].[insertarProducto] '{newProduct.Codigo}','{newProduct.Nombre}','{newProduct.Activo}','{newProduct.Descripcion}'" +
                        $",{newProduct.PrecioEstandar},'{newProduct.CodigoFamilia}'";

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

        //Method to get the information from a product report, from the DB
        public List<Product> getReport(int type)
        {
            //Since the product model has the same attributes as products families + some extra ones
            //we'll be using products to store the products families and the products
            List<Product> products = new List<Product>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sqlFunction = "";

                if (type == 1)
                {
                    sqlFunction = "masVendidosProductos()";
                }
                else if (type == 2)
                {
                    sqlFunction = "masVendidosFamProductos()";
                }
                else if (type == 3)
                {
                    sqlFunction = "masCotizadosProductos()";
                }
                else if (type == 4)
                {
                    sqlFunction = "masCotizadosFamProductos()";
                }

                string sql = $"SELECT * FROM {sqlFunction}";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Product product = new Product();

                            //Basic information, this is the information from product families
                            product.Codigo = "" + reader["codigo"];
                            product.Nombre = "" + reader["nombre"];
                            product.Activo = bool.Parse("" + reader["activo"]);
                            product.Descripcion = "" + reader["descripcion"];

                            if (type == 1 || type == 3)
                            {
                                
                                product.PrecioEstandar = Convert.ToDecimal("" + reader["precioEstandar"]);
                                product.CodigoFamilia = "" + reader["codigo_familia"];
                            }
                            if (type == 1 || type == 2)
                            {
                                product.CotizacionesVentas = int.Parse("" + reader["ventas"]);
                            }
                            if (type == 3 || type == 4)
                            {
                                product.CotizacionesVentas = int.Parse("" + reader["cotizaciones"]);
                            }

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
