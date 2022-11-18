using BasesP1.Models;
using System.Data.SqlClient;

namespace BasesP1.Data
{
    public class ReportsData
    {
        public IConfiguration Configuration { get; }

        public ReportsData(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        //Method to get all the year-monmths from quote dates
        public List<String> getYearMonth()
        {
            //Structure where the data fro the report will be save
            List<String> data = new List<String>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Query to be use
                string sql = $"SELECT * FROM cotDisMesAnno()";

                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add("" + dataReader["annoMes"]);
                        }

                    }
                }
                connection.Close();
            }
            return data;
        }

        //Method to get the data for the family products sales (circular) report
        public List<SimpleReportViewModel> getCFamilySales()
        {
            //Structure where the data fro the report will be save
            List<SimpleReportViewModel> data = new List<SimpleReportViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                
                //Show ALL family products and how many sells
                string sql = $"SELECT * FROM ventasFamProductos() ORDER BY ventas DESC";

                //Show the top 10 most sell family products
                //string sql = $"SELECT * FROM masVendidosFamProductos()";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new SimpleReportViewModel
                            {
                                DimensionOne = "" + dataReader["nombre"],
                                Quantity = int.Parse("" + dataReader["ventas"])
                            });
                        }

                    }
                }
                connection.Close();
            }
            return data;
        }

        //Method to get the data for the quotes and sells by department
        public List<StackedViewModel> getBQuotesSellsByDept()
        {
            //Structure where the data fro the report will be save
            List<StackedViewModel> data = new List<StackedViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM cotVentaXDepartamento()";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new StackedViewModel
                            {
                                StackedDimensionOne = "" + dataReader["nombre"],
                                LstData = new List<SimpleReportViewModel>()
                                {
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Ventas",
                                        Quantity = int.Parse("" + dataReader["ventas"])
                                    },
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Cotizaciones",
                                        Quantity = int.Parse("" + dataReader["cotizaciones"])
                                    },
                                }
                            });
                        }

                    }
                }
                connection.Close();
            }
            return data;
        }

        //Method to get the data for the quotes and sells by month and year
        public List<StackedViewModel> getBQuotesSellsByMonthYear()
        {
            //Structure where the data fro the report will be save
            List<StackedViewModel> data = new List<StackedViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM cotVentasMesAnno()";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new StackedViewModel
                            {
                                StackedDimensionOne = "" + dataReader["annoMes"],
                                LstData = new List<SimpleReportViewModel>()
                                {
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Ventas",
                                        Quantity = int.Parse("" + dataReader["ventas"])
                                    },
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Cotizaciones",
                                        Quantity = int.Parse("" + dataReader["cotizaciones"])
                                    },
                                }
                            });
                        }

                    }
                }
                connection.Close();
            }
            return data;
        }

        //Method to get the data for the 10 clients with the most sells
        public List<Client> getTClientMostSells()
        {
            //Structure where the data fro the report will be save
            List<Client> data = new List<Client>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM masVentasClientes()";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new Client
                            {
                                codigo = "" + dataReader["codigo"],
                                nombreCuenta = "" + dataReader["nombreCuenta"],
                                celular = "" + dataReader["celular"],
                                correo = "" + dataReader["correo"],
                                informacionAdicional = "" + dataReader["informacionAdicional"],
                                login_usuario = "" + dataReader["asesor"],
                                abreviatura_moneda = "" + dataReader["abreviatura_moneda"],
                                sector = "" + dataReader["sector"],
                                sitioWeb = "" + dataReader["sitioWeb"],
                                telefono = "" + dataReader["telefono"],
                                zona = "" + dataReader["zona"],
                                numeroCotizacion = Convert.ToInt16("" + dataReader["ventas"])
                            });
                        }
                    }
                }
            }
            return data;
        }
        public List<SimpleReportViewModel> getSellsBySector()
        {
            //Structure where the data from the report will be save
            List<SimpleReportViewModel> data = new List<SimpleReportViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Show the sells by sectors
                string sql = $"SELECT * FROM ventasxsector()";

                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new SimpleReportViewModel
                            {
                                DimensionOne = "" + dataReader["sector"],
                                Quantity = int.Parse("" + dataReader["Monto"])
                            });
                        }

                    }
                }
                connection.Close();
            }
            return data;
        }
        public List<SimpleReportViewModel> getSellsByZone()
        {
            //Structure where the data from the report will be save
            List<SimpleReportViewModel> data = new List<SimpleReportViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Show the sells by zones
                string sql = $"SELECT * FROM ventasxzona()";

                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new SimpleReportViewModel
                            {
                                DimensionOne = "" + dataReader["zona"],
                                Quantity = int.Parse("" + dataReader["Monto"])
                            });
                        }

                    }
                }
                connection.Close();
            }
            return data;
        }
        public List<SimpleReportViewModel> getSellsByDepartment()
        {
            //Structure where the data from the report will be save
            List<SimpleReportViewModel> data = new List<SimpleReportViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Show the sells by zones
                string sql = $"SELECT * FROM ventasxdepartamento()";

                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new SimpleReportViewModel
                            {
                                DimensionOne = "" + dataReader["departamento"],
                                Percentage = double.Parse("" + dataReader["Porcentaje"])
                            });
                        }

                    }
                }
                connection.Close();
            }
            return data;
        }
    }
}

