using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CCIOfficeServiceManagementSystem.Models
{
    public class AirtelReportModel
    {
        public long AirtelNumber { get; set; }
        public float Amount { get; set; }
        public string EmployeeName { get; set; }
        public long CostCenterId { get; set; }
    }
}