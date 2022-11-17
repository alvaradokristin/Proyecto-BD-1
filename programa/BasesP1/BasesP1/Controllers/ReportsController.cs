using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using System.Dynamic;

namespace BasesP1.Controllers
{
    public class ReportsController : Controller
    {
        public IConfiguration Configuration { get; }

        public ReportsController(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IActionResult LoadBarsGraphReport()
        {
            ReportsData reportData = new ReportsData(this.Configuration);
            List<StackedViewModel> dataModel = new List<StackedViewModel>();

            Random rnd = new Random();

            // Example to avoid errors
            dataModel.Add(new StackedViewModel
            {
                StackedDimensionOne = "First Quarter",
                LstData = new List<SimpleReportViewModel>()
               {
                   new SimpleReportViewModel()
                   {
                       DimensionOne="TV",
                       Quantity = rnd.Next(10)
                   },
                   new SimpleReportViewModel()
                   {
                       DimensionOne="Games",
                       Quantity = rnd.Next(10)
                   },
                   new SimpleReportViewModel()
                   {
                       DimensionOne="Books",
                       Quantity = rnd.Next(10)
                   }
               }
            });

            return View("BarsGraphReport", dataModel);
        }

        public IActionResult BarsGraphReport(string ReportType)
        {
            ReportsData reportData = new ReportsData(this.Configuration);
            List<StackedViewModel> dataModel = new List<StackedViewModel>();

            switch (ReportType)
            {
                case "cvpd":
                    dataModel = reportData.getBQuotesSellsByDept();
                    break;
                case "vcpma":
                    dataModel = reportData.getBQuotesSellsByMonthYear();
                    break;
                case "vcpmavp":
                    // Code specific to PersonalPolicy
                    break;
                case "vpspd":
                    // Code specific to PersonalPolicy
                    break;
                case "vpzpd":
                // Code specific to PersonalPolicy
                case null:
                    // Code for "any-other-than" cases :)
                    break;
            }

            return View(dataModel);
        }

        public IActionResult LoadCircularGraphReport()
        {
            ReportsData reportData = new ReportsData(this.Configuration);
            List<SimpleReportViewModel> dataModel = new List<SimpleReportViewModel>();

            return View("CircularGraphReport", dataModel);
        }

        public IActionResult CircularGraphReport(string ReportType)
        {
            ReportsData reportData = new ReportsData(this.Configuration);
            List<SimpleReportViewModel> dataModel = new List<SimpleReportViewModel>();

            switch (ReportType)
            {
                case "fpv":
                    dataModel = reportData.getCFamilySales();
                    break;
                case "other":
                    // Code specific to PersonalPolicy
                    break;
                case null:
                    // Code for "any-other-than" cases :)
                    break;
            }

            return View(dataModel);
        }

        public IActionResult LoadTableReport()
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            model.Data = null;

            return View("TableReport", model);
        }

        public List<String> getTableHeaders(string ReportType)
        {
            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();

            switch (ReportType)
            {
                case "ttpmv":
                    tableHeaders.Add("Codigo");
                    tableHeaders.Add("Nombre");
                    tableHeaders.Add("Activo");
                    tableHeaders.Add("Descripcion");
                    tableHeaders.Add("Precio");
                    tableHeaders.Add("Codigo Familia");
                    tableHeaders.Add("Ventas");
                    break;
                case "ttpmc":
                    tableHeaders.Add("Codigo");
                    tableHeaders.Add("Nombre");
                    tableHeaders.Add("Activo");
                    tableHeaders.Add("Descripcion");
                    tableHeaders.Add("Precio");
                    tableHeaders.Add("Codigo Familia");
                    tableHeaders.Add("Cotizaciones");
                    break;
                case "ttccmv":
                    tableHeaders.Add("Codigo");
                    tableHeaders.Add("Nombre Cuenta");
                    tableHeaders.Add("Telefono");
                    tableHeaders.Add("Celular");
                    tableHeaders.Add("Correo");
                    tableHeaders.Add("Informacion Adicional");
                    tableHeaders.Add("Asesor");
                    tableHeaders.Add("Moneda");
                    tableHeaders.Add("Sector");
                    tableHeaders.Add("Sitio Web");
                    tableHeaders.Add("Zona");
                    tableHeaders.Add("Ventas");
                    break;
                case null:
                    // Code for "any-other-than" cases :)
                    break;
            }

            return tableHeaders;
        }

        public IActionResult TableReport(string ReportType)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();

            //List of products with the values from the query
            List<Product> product = new List<Product>();
            List<Client> client = new List<Client>();

            ProductData queryProd = new ProductData(this.Configuration);
            ReportsData queryReport = new ReportsData(this.Configuration);

            switch (ReportType)
            {
                case "ttpmv":
                    // Get the table headers
                    tableHeaders = getTableHeaders(ReportType);

                    //Get the data from the query
                    product = queryProd.getReport(1);

                    //Add the data to the general model that cointains dirrefent models inside
                    model.Headers = tableHeaders;
                    model.Data = product;
                    model.Type = ReportType;

                    break;
                case "ttpmc":
                    // Get the table headers
                    tableHeaders = getTableHeaders(ReportType);

                    //Get the data from the query
                    product = queryProd.getReport(3);

                    //Add the data to the general model that cointains dirrefent models inside
                    model.Headers = tableHeaders;
                    model.Data = product;
                    model.Type = ReportType;
                    break;
                case "ttccmv":
                    // Get the table headers
                    tableHeaders = getTableHeaders(ReportType);

                    //Get the data from the query
                    client = queryReport.getTClientMostSells();

                    //Add the data to the general model that cointains dirrefent models inside
                    model.Headers = tableHeaders;
                    model.Data = client;
                    model.Type = ReportType;
                    break;
                case null:
                    // Default
                    break;
            }

            return View(model);
        }
    }
}
