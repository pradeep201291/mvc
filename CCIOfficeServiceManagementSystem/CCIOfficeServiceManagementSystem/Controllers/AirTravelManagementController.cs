using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CCIOfficeServiceManagementSystem.Controllers
{
    [Authorize]
    public class AirTravelManagementController : Controller 
    {
        //
        // GET: /AirTravelManagement/ 

        public ActionResult Index()
        {
            return View();
        }


        public ActionResult ImportExcelFile()
        {
            return View();
        }


        [HttpPost]
        public ActionResult ImportExcelFile(HttpPostedFileBase fileuploaded,FormCollection collection)
        {
            return View();

        }
    }
}
