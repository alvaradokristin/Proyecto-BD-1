﻿using BasesP1.Models;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;

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
        public List<String> getDates()
        {
            //Structure where the data fro the report will be save
            List<String> data = new List<String>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Query to be use
                string sql = $"SELECT * FROM CotFechas";

                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {

                        while (dataReader.Read())
                        {
                            data.Add("" + dataReader["fecha"]);

                        }

                    }
                }
                connection.Close();
            }
            return data;
        }

        //Method to get the data for the family products sales (circular) report
        public List<SimpleReportViewModel> getCFamilySales(string from, string to)
        {
            //Structure where the data fro the report will be save
            List<SimpleReportViewModel> data = new List<SimpleReportViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                
                //Show ALL family products and how many sells they have
                string sql = $"SELECT * FROM ventasFamProductos('{from}', '{to}') ORDER BY ventas DESC";

                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new SimpleReportViewModel
                            {
                                DimensionOne = "" + dataReader["nombre"],
                                Percentage = double.Parse("" + dataReader["ventas"])
                            });
                        }

                    }
                }
                connection.Close();
            }
            return data;
        }

        //Method to get the data for the quotes and sells by department
        public List<StackedViewModel> getBQuotesSellsByDept(string from, string to)
        {
            //Structure where the data fro the report will be save
            List<StackedViewModel> data = new List<StackedViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM cotVentaXDepartamento('{from}', '{to}')";
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

        //Method to get the data for the quotes and sells by month and year (Quantity)
        public List<StackedViewModel> getBQuotesSellsByMonthYearQuantity(string from, string to)
        {
            //Structure where the data fro the report will be save
            List<StackedViewModel> data = new List<StackedViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Get the amount of quotes and sells
                string sql = $"SELECT * FROM cotVentasMesAnnoCant('{from}', '{to}')";
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

        //Method to get the data for the quotes and sells by month and year (Amount of money)
        public List<StackedViewModel> getBQuotesSellsByMonthYearAmount(string from, string to)
        {
            //Structure where the data fro the report will be save
            List<StackedViewModel> data = new List<StackedViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Get how much money the quotes and sells made
                string sql = $"SELECT * FROM cotVentasMesAnnoMonto('{from}', '{to}')";
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
                                        Percentage = double.Parse("" + dataReader["ventas"])
                                    },
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Cotizaciones",
                                        Percentage = double.Parse("" + dataReader["cotizaciones"])
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
        public List<Client> getTClientMostSells(string from, string to, string order)
        {
            //Structure where the data fro the report will be save
            List<Client> data = new List<Client>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sqlFunction = "";

                if (order == "DESC")
                {
                    sqlFunction = $"masVentasClientesDESC('{from}', '{to}')";
                }
                else
                {
                    sqlFunction = $"masVentasClientesASC('{from}', '{to}')";
                }

                string sql = $"SELECT * FROM {sqlFunction}";
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
                                numeroCotizacion = Convert.ToInt16("" + dataReader["ventas"]),
                                monto = double.Parse("" + dataReader["monto"])
                            });
                        }
                    }
                }
            }
            return data;
        }
        public List<SimpleReportViewModel> getSellsBySector(string from, string to)
        {
            //Structure where the data from the report will be save
            List<SimpleReportViewModel> data = new List<SimpleReportViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Show the sells by sectors
                string sql = $"SELECT * FROM ventasxsector('{from}', '{to}')";

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
        public List<SimpleReportViewModel> getSellsByZone(string from, string to)
        {
            //Structure where the data from the report will be save
            List<SimpleReportViewModel> data = new List<SimpleReportViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Show the sells by zones
                string sql = $"SELECT * FROM ventasxzona('{from}', '{to}')";

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
        public List<SimpleReportViewModel> getSellsByDepartment(string from, string to)
        {
            //Structure where the data from the report will be save
            List<SimpleReportViewModel> data = new List<SimpleReportViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Show the sells by departments
                string sql = $"SELECT * FROM ventasxdepartamento('{from}', '{to}')";

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

        //Method to get the information from a product report, from the DB
        public List<Product> getTTopSellerProd(string from, string to, string order)
        {
            //Since the product model has the same attributes as products families + some extra ones
            //we'll be using products to store the products families and the products
            List<Product> products = new List<Product>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sqlFunction = "";

                if (order == "DESC")
                {
                    sqlFunction = $"masVendidosProductosDESC('{from}', '{to}')";
                }
                else
                {
                    sqlFunction = $"masVendidosProductosASC('{from}', '{to}')";
                }

                string sql = $"SELECT * FROM {sqlFunction}";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            products.Add(new Product
                            {
                                Codigo = "" + dataReader["codigo"],
                                Nombre = "" + dataReader["nombre"],
                                Activo = bool.Parse("" + dataReader["activo"]),
                                Descripcion = "" + dataReader["descripcion"],
                                PrecioEstandar = Convert.ToDecimal("" + dataReader["precioEstandar"]),
                                CodigoFamilia = "" + dataReader["codigo_familia"],
                                Monto = double.Parse("" + dataReader["ventas"])
                            });
                        }
                        dataReader.Close();
                    }
                }
                connection.Close();
            }
            return products;
        }

        //Method to get the information from the most quoted products, from the DB
        public List<Product> getTTopQuoterProd(string from, string to, string order)
        {
            //Since the product model has the same attributes as products families + some extra ones
            //we'll be using products to store the products families and the products
            List<Product> products = new List<Product>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sqlFunction = "";

                if (order == "DESC")
                {
                    sqlFunction = $"masCotProductosDESC('{from}', '{to}')";
                }
                else
                {
                    sqlFunction = $"masCotProductosASC('{from}', '{to}')";
                }

                string sql = $"SELECT * FROM {sqlFunction}";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            products.Add(new Product
                            {
                                Codigo = "" + dataReader["codigo"],
                                Nombre = "" + dataReader["nombre"],
                                Activo = bool.Parse("" + dataReader["activo"]),
                                Descripcion = "" + dataReader["descripcion"],
                                PrecioEstandar = Convert.ToDecimal("" + dataReader["precioEstandar"]),
                                CodigoFamilia = "" + dataReader["codigo_familia"],
                                CotizacionesVentas = int.Parse("" + dataReader["cotizaciones"])
                            });
                        }
                        dataReader.Close();
                    }
                }
                connection.Close();
            }
            return products;
        }
        public List<SimpleReportViewModel> getCasesByType(string from, string to)
        {
            //Structure where the data from the report will be save
            List<SimpleReportViewModel> data = new List<SimpleReportViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Show the cases by type
                string sql = $"SELECT * FROM casosxtipo('{from}', '{to}')";

                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new SimpleReportViewModel
                            {
                                DimensionOne = "" + dataReader["Tipo"],
                                Percentage = double.Parse("" + dataReader["Porcentaje"])
                            });
                        }

                    }
                }
                connection.Close();
            }
            return data;
        }
        public List<SimpleReportViewModel> getCasesByState(string from, string to)
        {
            //Structure where the data from the report will be save
            List<SimpleReportViewModel> data = new List<SimpleReportViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Show the cases by state
                string sql = $"SELECT * FROM casosxestado('{from}', '{to}')";

                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new SimpleReportViewModel
                            {
                                DimensionOne = "" + dataReader["Estado"],
                                Quantity = int.Parse("" + dataReader["Casos"])
                            });
                        }

                    }
                }
                connection.Close();
            }
            return data;
        }
        public List<SimpleReportViewModel> getQuotationByType(string from, string to)
        {
            //Structure where the data from the report will be save
            List<SimpleReportViewModel> data = new List<SimpleReportViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Show the quotation by type
                string sql = $"SELECT * FROM cotizacionesxtipo('{from}', '{to}')";

                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new SimpleReportViewModel
                            {
                                DimensionOne = "" + dataReader["Tipo"],
                                Quantity = int.Parse("" + dataReader["Cotizaciones"])
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
