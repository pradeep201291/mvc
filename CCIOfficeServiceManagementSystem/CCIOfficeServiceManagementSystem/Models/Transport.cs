using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CCIOfficeServiceManagementSystem.Models
{
    public class Transport
    {
        public DateTime PresentDate { get; set; }
        public String Name { get; set; }
        public String Place { get; set; }
    public String Driver  { get; set; }
    public int VehicleNumber { get; set; } 
    public int Amount { get; set; }
    public int CostCentre { get; set; }
    public DateTime UploadedDate { get; set; }
    public DateTime DateOfCreation { get; set; }
    public int ImportDateId { get; set; }
    }
}