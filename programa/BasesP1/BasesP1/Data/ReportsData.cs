﻿using BasesP1.Models;
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
    }
}
