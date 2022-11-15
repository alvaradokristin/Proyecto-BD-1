using BasesP1.Data;
using BasesP1.Models;
using Microsoft.AspNetCore.Mvc;
using System.Web.Helpers;

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
                case "other":
                    // Code specific to PersonalPolicy
                    break;
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
    }
}
