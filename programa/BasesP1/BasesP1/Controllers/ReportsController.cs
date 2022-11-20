using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using System.Dynamic;
using Task = BasesP1.Models.Task;

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

        //Method to create a list of all YValues on a List<StackedViewModel>
        public List<IEnumerable<double>> getAllyVDouble(List<StackedViewModel> model)
        {
            List<IEnumerable<double>> data = model.Select(x => x.LstData.Select(w => w.Percentage)).ToList();

            return data;
        }

        public IActionResult LoadBarsGraphReport()
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            ReportsData reportData = new ReportsData(this.Configuration);
            List<StackedViewModel> dataModel = new List<StackedViewModel>();

            List<String> yearMonth = reportData.getDates();

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

        public IActionResult BarsGraphReport(GraphFilters filters)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            ReportsData reportData = new ReportsData(this.Configuration);
            List<StackedViewModel> dataModel = new List<StackedViewModel>();

            List<String> yearMonth = reportData.getDates();

            switch (filters.ReportType)
            {
                case "cvpd":
                    dataModel = reportData.getBQuotesSellsByDept(filters.From, filters.To);
                    model.XLabels = getAllxL(dataModel);
                    model.YValues = getAllyV(dataModel);
                    break;
                case "vcpma":
                    //How many sells/quotes
                    //dataModel = reportData.getBQuotesSellsByMonthYearQuantity(filters.From, filters.To);
                    //model.XLabels = getAllxL(dataModel);
                    //model.YValues = getAllyV(dataModel);

                    //Amount of money
                    dataModel = reportData.getBQuotesSellsByMonthYearAmount(filters.From, filters.To);
                    model.XLabels = getAllxL(dataModel);
                    model.YValues = getAllyVDouble(dataModel);
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

            List<String> yearMonth = reportData.getDates();

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

            List<String> yearMonth = reportData.getDates();

            model.XLabels = getAllDimOne(dataModel);
            model.YValues = getAllQuantitiesPer(dataModel);
            model.Dates = yearMonth;
            model.Show = false;

            return View("CircularPercentageGraphReport", model);
        }

        [HttpPost]
        public IActionResult CircularGraphReport(GraphFilters filters)
            //string ReportType, string From, string To
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            ReportsData reportData = new ReportsData(this.Configuration);
            List<SimpleReportViewModel> dataModel = new List<SimpleReportViewModel>();

            List<String> yearMonth = reportData.getDates();

            switch (filters.ReportType)
            {
                case "fpv":
                    dataModel = reportData.getCFamilySales(filters.From, filters.To);
                    model.YValues = getAllQuantitiesPer(dataModel);
                    break;
                case "vps":
                    dataModel = reportData.getSellsBySector(filters.From, filters.To);
                    model.YValues = getAllQuantities(dataModel);
                    break;
                case "vpz":
                    dataModel = reportData.getSellsByZone(filters.From, filters.To);
                    model.YValues = getAllQuantities(dataModel);
                    break;
                case "vpd":
                    dataModel = reportData.getSellsByDepartment(filters.From, filters.To);
                    model.YValues = getAllQuantities(dataModel);
                    break;
                case "cpe":
                    dataModel = reportData.getCasesByState(filters.From, filters.To);
                    model.YValues = getAllQuantities(dataModel);
                    break;
                case "ccpt":
                    dataModel = reportData.getQuotationByType(filters.From, filters.To);
                    model.YValues = getAllQuantities(dataModel);
                    break;
                case null:
                    // Code for "any-other-than" cases :)
                    break;
            }



            model.XLabels = getAllDimOne(dataModel);
            model.Dates = yearMonth;
            model.Show = true;

            return View(model);
        }

        public IActionResult CircularPercentageGraphReport(GraphFilters filters)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            ReportsData reportData = new ReportsData(this.Configuration);
            List<SimpleReportViewModel> dataModel = new List<SimpleReportViewModel>();

            List<String> yearMonth = reportData.getDates();

            switch (filters.ReportType)
            {
                case "vpd":
                    dataModel = reportData.getSellsByDepartment(filters.From, filters.To);
                    model.YValues = getAllQuantities(dataModel);
                    break;
                case "cpt":
                    dataModel = reportData.getCasesByType(filters.From, filters.To);
                    model.YValues = getAllQuantities(dataModel);
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

            ReportsData reportData = new ReportsData(this.Configuration);
            List<String> yearMonth = reportData.getDates();

            model.Data = null;
            model.Dates = yearMonth;

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
                    tableHeaders.Add("Codigo Familia");
                    tableHeaders.Add("Precio");
                    tableHeaders.Add("Ventas");
                    break;
                case "ttpmc":
                    tableHeaders.Add("Codigo");
                    tableHeaders.Add("Nombre");
                    tableHeaders.Add("Activo");
                    tableHeaders.Add("Descripcion");
                    tableHeaders.Add("Codigo Familia");
                    tableHeaders.Add("Precio");
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
                    tableHeaders.Add("Monto");
                    break;
                case "ttvcmv":
                    tableHeaders.Add("Login");
                    tableHeaders.Add("Nombre");
                    tableHeaders.Add("Ventas");
                    break;
                case "cccu":
                    tableHeaders.Add("Login");
                    tableHeaders.Add("Nombre");
                    tableHeaders.Add("Contactos");
                    break;
                case "tftscma":
                    tableHeaders.Add("Codigo");
                    tableHeaders.Add("Nombre");
                    tableHeaders.Add("Tipo");
                    tableHeaders.Add("Descripcion");
                    tableHeaders.Add("Estado");
                    tableHeaders.Add("Asesor");
                    tableHeaders.Add("FechaInicio");
                    tableHeaders.Add("Dias");
                    break;
                case "ttcdccma":
                    tableHeaders.Add("Numero Cotización");
                    tableHeaders.Add("Cod Cliente");
                    tableHeaders.Add("Cuenta");
                    tableHeaders.Add("Etapa");
                    tableHeaders.Add("Tipo");
                    tableHeaders.Add("Sector");
                    tableHeaders.Add("Zona");
                    tableHeaders.Add("Asesor");
                    tableHeaders.Add("Fecha Inicio");
                    tableHeaders.Add("Fecha Cierre");
                    tableHeaders.Add("Dias");
                    break;
                case null:
                    // Code for "any-other-than" cases :)
                    break;
            }

            return tableHeaders;
        }

        public IActionResult TableReport(GraphFilters filters)
        {
            //Create a model that wll store several models to be use in View
            dynamic model = new ExpandoObject();

            //Create an array of the headers that will be used in View table
            List<String> tableHeaders = new List<String>();

            //List of products with the values from the query
            List<Product> product = new List<Product>();
            List<Client> client = new List<Client>();
            List<User> user = new List<User>();
            List<Task> task = new List<Task>();
            List<Quotation> quote = new List<Quotation>();

            ProductData queryProd = new ProductData(this.Configuration);
            ReportsData queryReport = new ReportsData(this.Configuration);

            List<String> yearMonth = queryReport.getDates();

            // Get the table headers
            tableHeaders = getTableHeaders(filters.ReportType);

            //Add the data to the general model that cointains dirrefent models inside
            model.Headers = tableHeaders;

            switch (filters.ReportType)
            {
                case "ttpmv":
                    //Get the data from the query
                    product = queryReport.getTTopSellerProd(filters.From, filters.To, filters.OrderBy);
                    model.Data = product;

                    break;
                case "ttpmc":
                    //Get the data from the query
                    product = queryReport.getTTopQuoterProd(filters.From, filters.To, filters.OrderBy);
                    model.Data = product;
                    break;
                case "ttccmv":
                    //Get the data from the query
                    client = queryReport.getTClientMostSells(filters.From, filters.To, filters.OrderBy);
                    model.Data = client;
                    break;
                case "ttvcmv":
                    //Get the data from the query
                    user = queryReport.getTSellersMostSells(filters.From, filters.To, filters.OrderBy);
                    model.Data = user;
                    break;
                case "cccu":
                    //Get the data from the query
                    user = queryReport.getTContactsByUsers(filters.From, filters.To, filters.OrderBy);
                    model.Data = user;
                    break;
                case "tftscma":
                    //Get the data from the query
                    task = queryReport.getTOldestsOpenTasks(filters.From, filters.To, filters.OrderBy);
                    model.Data = task;
                    break;
                case "ttcdccma":
                    //Get the data from the query
                    quote = queryReport.getTQuotesDaysBDates(filters.From, filters.To, filters.OrderBy);
                    model.Data = quote;
                    break;
                case null:
                    // Default
                    break;
            }

            model.Dates = yearMonth;
            model.Type = filters.ReportType;

            return View(model);
        }
    }
}
