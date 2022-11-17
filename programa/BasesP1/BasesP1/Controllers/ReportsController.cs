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

        //Method to create a list of all DimensionOne on a List<SimpleReportViewModel>
        public List<String> getAllDimOne(List<SimpleReportViewModel> model)
        {
            List<String> data = model.Select(x => x.DimensionOne).ToList();

            return data;
        }

        //Method to create a list of all Quantities on a List<SimpleReportViewModel>
        public List<int> getAllQuantities(List<SimpleReportViewModel> model)
        {
            List<int> data = model.Select(x => x.Quantity).ToList();

            return data;
        }

        //Method to create a list of all Quantities on a List<SimpleReportViewModel> (Percentage / %)
        public List<double> getAllQuantitiesPer(List<SimpleReportViewModel> model)
        {
            List<double> data = model.Select(x => x.Percentage).ToList();

            return data;
        }

        //Method to create a list of all StackedDimensionOne on a List<StackedViewModel>
        public List<String> getAllSDO(List<StackedViewModel> model)
        {
            List<String> data = model.Select(x => x.StackedDimensionOne).ToList();

            return data;
        }

        //Method to create a list of all XLabels on a List<StackedViewModel>
        public List<String> getAllxL(List<StackedViewModel> model)
        {
            List<String> data = model.FirstOrDefault().LstData.Select(x => x.DimensionOne).ToList();

            return data;
        }

        //Method to create a list of all YValues on a List<StackedViewModel>
        public List<IEnumerable<int>> getAllyV(List<StackedViewModel> model)
        {
            List<IEnumerable<int>> data = model.Select(x => x.LstData.Select(w => w.Quantity)).ToList();

            return data;
        }

        public IActionResult LoadBarsGraphReport()
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            ReportsData reportData = new ReportsData(this.Configuration);
            List<StackedViewModel> dataModel = new List<StackedViewModel>();

            List<String> yearMonth = reportData.getYearMonth();

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

            model.XLabels = getAllxL(dataModel);
            model.YValues = getAllyV(dataModel);
            model.label2 = getAllSDO(dataModel);
            model.Dates = yearMonth;
            model.Show = false;

            return View("BarsGraphReport", model);
        }

        public IActionResult BarsGraphReport(string ReportType)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            ReportsData reportData = new ReportsData(this.Configuration);
            List<StackedViewModel> dataModel = new List<StackedViewModel>();

            List<String> yearMonth = reportData.getYearMonth();

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

            model.XLabels = getAllxL(dataModel);
            model.YValues = getAllyV(dataModel);
            model.label2 = getAllSDO(dataModel);
            model.Dates = yearMonth;
            model.Show = true;

            return View(model);
        }

        public IActionResult LoadCircularGraphReport()
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            ReportsData reportData = new ReportsData(this.Configuration);
            List<SimpleReportViewModel> dataModel = new List<SimpleReportViewModel>();

            List<String> yearMonth = reportData.getYearMonth();

            model.XLabels = getAllDimOne(dataModel);
            model.YValues = getAllQuantities(dataModel);
            model.Dates = yearMonth;
            model.Show = false;

            return View("CircularGraphReport", model);
        }

        public IActionResult LoadCircularPercentageGraphReport()
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            ReportsData reportData = new ReportsData(this.Configuration);
            List<SimpleReportViewModel> dataModel = new List<SimpleReportViewModel>();

            List<String> yearMonth = reportData.getYearMonth();

            model.XLabels = getAllDimOne(dataModel);
            model.YValues = getAllQuantitiesPer(dataModel);
            model.Dates = yearMonth;
            model.Show = false;

            return View("CircularPercentageGraphReport", model);
        }

        public IActionResult CircularGraphReport(string ReportType)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            ReportsData reportData = new ReportsData(this.Configuration);
            List<SimpleReportViewModel> dataModel = new List<SimpleReportViewModel>();

            List<String> yearMonth = reportData.getYearMonth();

            switch (ReportType)
            {
                case "fpv":
                    dataModel = reportData.getCFamilySales();
                    break;
                case "vps":
                    dataModel = reportData.getSellsBySector();
                    break;
                case "vpz":
                    dataModel = reportData.getSellsByZone();
                    break;
                case "vpd":
                    dataModel = reportData.getSellsByDepartment();
                    break;
                case null:
                    // Code for "any-other-than" cases :)
                    break;
            }

            model.XLabels = getAllDimOne(dataModel);
            model.YValues = getAllQuantities(dataModel);
            model.Dates = yearMonth;
            model.Show = true;

            return View(model);
        }

        public IActionResult CircularPercentageGraphReport(string ReportType)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            ReportsData reportData = new ReportsData(this.Configuration);
            List<SimpleReportViewModel> dataModel = new List<SimpleReportViewModel>();

            List<String> yearMonth = reportData.getYearMonth();

            switch (ReportType)
            {
                case "vpd":
                    dataModel = reportData.getSellsByDepartment();
                    break;
                case null:
                    // Code for "any-other-than" cases :)
                    break;
            }

            model.XLabels = getAllDimOne(dataModel);
            model.YValues = getAllQuantitiesPer(dataModel);
            model.Dates = yearMonth;
            model.Show = true;

            return View(model);
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
