using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CCIOfficeServiceManagementSystem.Controllers
{
    [Authorize]
    public class SuccessController : Controller
    {
        //
        // GET: /Success/
        
        public ActionResult Success()
        {
            return View();
        }

    }
}
