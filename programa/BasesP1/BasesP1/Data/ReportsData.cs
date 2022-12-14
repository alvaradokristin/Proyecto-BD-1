using BasesP1.Models;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Security.Policy;
using Task = BasesP1.Models.Task;

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
            //Structure where the data for the report will be save
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

        //Method to get all the zones
        public List<String> getZones()
        {
            //Structure where the data for the report will be save
            List<String> data = new List<String>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Query to be use
                string sql = $"SELECT * FROM todas_las_zonas()";

                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {

                        while (dataReader.Read())
                        {
                            data.Add("" + dataReader["nombre"]);

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
            //Structure where the data for the report will be save
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
            //Structure where the data for the report will be save
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
            //Structure where the data for the report will be save
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
            //Structure where the data for the report will be save
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

        //Method to get the data for the sells by department sector
        public List<StackedViewModel> getBSellsByDeptSector(string from, string to)
        {
            //Structure where the data for the report will be save
            List<StackedViewModel> data = new List<StackedViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Get how much money the quotes and sells made
                string sql = $"SELECT * FROM ventasSectorDept('{from}', '{to}')";
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
                                        DimensionOne="Gobierno",
                                        Percentage = double.Parse("" + dataReader["gobierno"])
                                    },
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Hoteleria",
                                        Percentage = double.Parse("" + dataReader["hoteleria"])
                                    },
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Residencial",
                                        Percentage = double.Parse("" + dataReader["residencial"])
                                    },
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Turismo",
                                        Percentage = double.Parse("" + dataReader["turismo"])
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

        //Method to get the data for the sells by department zone
        public List<StackedViewModel> getBSellsByDeptZone(string from, string to)
        {
            //Structure where the data for the report will be save
            List<StackedViewModel> data = new List<StackedViewModel>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                //Get how much money the quotes and sells made
                string sql = $"SELECT * FROM ventasZonaDept('{from}', '{to}')";
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
                                        DimensionOne="Alajuela",
                                        Percentage = double.Parse("" + dataReader["alajuela"])
                                    },
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Cartago",
                                        Percentage = double.Parse("" + dataReader["cartago"])
                                    },
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Guanacaste",
                                        Percentage = double.Parse("" + dataReader["guanacaste"])
                                    },
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Heredia",
                                        Percentage = double.Parse("" + dataReader["heredia"])
                                    },
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Limon",
                                        Percentage = double.Parse("" + dataReader["limon"])
                                    },
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="Puntarenas",
                                        Percentage = double.Parse("" + dataReader["puntarenas"])
                                    },
                                    new SimpleReportViewModel()
                                    {
                                        DimensionOne="San Jose",
                                        Percentage = double.Parse("" + dataReader["sj"])
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
            //Structure where the data for the report will be save
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
        
        //Method to get the data for the 10 sellers with the most sells
        public List<User> getTSellersMostSells(string from, string to, string order)
        {
            //Structure where the data for the report will be save
            List<User> data = new List<User>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sqlFunction = "";

                if (order == "DESC")
                {
                    sqlFunction = $"usuariosMasVentasDESC('{from}', '{to}')";
                }
                else
                {
                    sqlFunction = $"usuariosMasVentasASC('{from}', '{to}')";
                }

                string sql = $"SELECT * FROM {sqlFunction}";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new User
                            {
                                userLogin = "" + dataReader["userLogin"],
                                nombre = "" + dataReader["nombre"],
                                primerApellido = "" + dataReader["primerApellido"],
                                segundoApellido = "" + dataReader["segundoApellido"],
                                monto = double.Parse("" + dataReader["monto"])
                            });
                        }
                    }
                }
            }
            return data;
        }

        //Method to get the data for the contacts by seller
        public List<User> getTContactsByUsers(string from, string to, string order)
        {
            //Structure where the data for the report will be save
            List<User> data = new List<User>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sqlFunction = "";

                if (order == "DESC")
                {
                    sqlFunction = $"contactosXUsuarioDESC('{from}', '{to}')";
                }
                else
                {
                    sqlFunction = $"contactosXUsuarioASC('{from}', '{to}')";
                }

                string sql = $"SELECT * FROM {sqlFunction}";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new User
                            {
                                userLogin = "" + dataReader["userLogin"],
                                nombre = "" + dataReader["nombre"],
                                primerApellido = "" + dataReader["primerApellido"],
                                segundoApellido = "" + dataReader["segundoApellido"],
                                cantidad = int.Parse("" + dataReader["contactos"])
                            });
                        }
                    }
                }
            }
            return data;
        }

        //Method to get the oldest open tasks
        public List<Task> getTOldestsOpenTasks(string from, string to, string order)
        {
            //Structure where the data for the report will be save
            List<Task> data = new List<Task>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sqlFunction = "";

                if (order == "DESC")
                {
                    sqlFunction = $"tareasAntiguasDESC('{from}', '{to}')";
                }
                else
                {
                    sqlFunction = $"tareasAntiguasASC('{from}', '{to}')";
                }

                string sql = $"SELECT * FROM {sqlFunction}";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new Task
                            {
                                Codigo = "" + dataReader["codigo"],
                                Nombre = "" + dataReader["nombre"],
                                FechaFinalizacion = "" + dataReader["tipo"],
                                Descripcion = "" + dataReader["descripcion"],
                                Estado = "" + dataReader["nombre_estado"],
                                Asesor = "" + dataReader["usuario_asignado"],
                                FechaInicio = "" + dataReader["fechaInicio"],
                                Cantidad = int.Parse("" + dataReader["dias"])
                            });
                        }
                    }
                }
            }
            return data;
        }

        //Method to get the top 10 quotes with the most days between start and end date
        public List<Quotation> getTQuotesDaysBDates(string from, string to, string order)
        {
            //Structure where the data for the report will be save
            List<Quotation> data = new List<Quotation>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sqlFunction = "";

                if (order == "DESC")
                {
                    sqlFunction = $"cotDifDiasDESC('{from}', '{to}')";
                }
                else
                {
                    sqlFunction = $"cotDifDiasASC('{from}', '{to}')";
                }

                string sql = $"SELECT * FROM {sqlFunction}";
                using (var command = new SqlCommand(sql, connection))
                {
                    using (var dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new Quotation
                            {
                                numeroCotizacion = short.Parse("" + dataReader["numeroCotizacion"]),
                                codigoCleinte = "" + dataReader["codigo"],
                                nombreCuenta = "" + dataReader["nombreCuenta"],
                                nombre_etapa = "" + dataReader["nombre_etapa"],
                                nombre_tipo = "" + dataReader["nombre_tipo"],
                                sector = "" + dataReader["sector"],
                                zona = "" + dataReader["zona"],
                                login_usuario = "" + dataReader["login_usuario"],

                                fecha = DateTime.Parse("" + dataReader["fecha"]).ToShortDateString(), // Convert DateTime to String with format SmallDate

                                fechaCierre = DateTime.Parse("" + dataReader["fechaCierre"]).ToShortDateString(), // Convert DateTime to String with format SmallDate

                                cantidad = int.Parse("" + dataReader["dias"])
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
            //Data to populate the table
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

        //Method to get the task by user
        public List<TasksByUser> getTTasksByUser(string from, string to, string order)
        {
            //Data to populate the table
            List<TasksByUser> tbu = new List<TasksByUser>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sqlFunction = "";

                if (order == "DESC")
                {
                    sqlFunction = $"tareasPorUsuarioDESC('{from}', '{to}')";
                }
                else
                {
                    sqlFunction = $"tareasPorUsuarioASC('{from}', '{to}')";
                }

                string sql = $"SELECT * FROM {sqlFunction}";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            tbu.Add(new TasksByUser
                            {
                                Login = "" + dataReader["userLogin"],
                                Nombre = "" + dataReader["nombre"],
                                PrimerApellido = "" + dataReader["primerApellido"],
                                SegundoApellido = "" + dataReader["segundoApellido"],
                                Iniciadas = int.Parse("" + dataReader["iniciadas"]),
                                EnProgreso = int.Parse("" + dataReader["enProgreso"]),
                                Finalizadas = int.Parse("" + dataReader["finalizadas"]),
                                Total = int.Parse("" + dataReader["total"])
                            });
                        }
                        dataReader.Close();
                    }
                }
                connection.Close();
            }
            return tbu;
        }

        //Method to get the execs by user
        public List<User> getTExesByUser(string from, string to, string order)
        {
            //Data to populate the table
            List<User> data = new List<User>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sqlFunction = "";

                if (order == "DESC")
                {
                    sqlFunction = $"ejecPorUsuarioDESC('{from}', '{to}')";
                }
                else
                {
                    sqlFunction = $"ejecPorUsuarioASC('{from}', '{to}')";
                }

                string sql = $"SELECT * FROM {sqlFunction}";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            data.Add(new User
                            {
                                userLogin = "" + dataReader["userLogin"],
                                nombre = "" + dataReader["nombre"],
                                primerApellido = "" + dataReader["primerApellido"],
                                segundoApellido = "" + dataReader["segundoApellido"],
                                cantidad = int.Parse("" + dataReader["ejecuciones"])
                            });
                        }
                        dataReader.Close();
                    }
                }
                connection.Close();
            }
            return data;
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

        public List<ClientsAndSales> getClientsAndSalesPerZone(string? from, string? to, string? zones)
        {

            List<ClientsAndSales> clientsAndSales = new List<ClientsAndSales>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM cantidad_clientes_monto_x_zona('{from}', '{to}', '{zones}')";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            clientsAndSales.Add(new ClientsAndSales
                            {
                                Zona = "" + dataReader["Zona"],
                                Clientes = "" + dataReader["Clientes"],
                                Monto = int.Parse("" + dataReader["Monto"]),
                            });
                        }
                        dataReader.Close();
                    }
                }
                connection.Close();
            }
            return clientsAndSales;
        }

        public List<ExecutionsWithTasksAndActivities> getTopTenExecutions(string? from, string? to)
        {
            List<ExecutionsWithTasksAndActivities> executionsWithTasksAndActivities = new List<ExecutionsWithTasksAndActivities>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM top_10_cotizaciones_con_tareas_actividades('{from}', '{to}')";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            executionsWithTasksAndActivities.Add(new ExecutionsWithTasksAndActivities
                            {
                                NumeroCotizacion = "" + dataReader["numeroCotizacion"],
                                Tareas = "" + dataReader["Tareas"],
                                Actividades = "" + dataReader["Actividades"],
                                Total = int.Parse("" + dataReader["Total"]),
                            });
                        }
                        dataReader.Close();
                    }
                }
                connection.Close();
            }
            return executionsWithTasksAndActivities;
        }

        internal List<int> getTotalExecutionsByMonthAndYear(string? from, string? to)
        {
            List<int> executions = new List<int>();

            string connectionString = Configuration["ConnectionStrings:RealConnection"];
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = $"SELECT * FROM cantidad_ejecuciones_mes_anno('{from}', '{to}')";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    using (SqlDataReader dataReader = command.ExecuteReader())
                    {
                        while (dataReader.Read())
                        {
                            executions.Add(int.Parse("" + dataReader["Ejecuciones"]));
                        }
                        dataReader.Close();
                    }
                }
                connection.Close();
            }
            return executions;
        }
    }
}
