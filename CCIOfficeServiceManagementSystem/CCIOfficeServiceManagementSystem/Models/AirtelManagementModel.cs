using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CCIOfficeServiceManagementSystem.Models   
{
    public class AirtelManagementModel
    {
        public long MobileAcNumber { get; set; } 
        public long AirtelNumber { get; set; }
        public int OneTime { get; set; }
        public float MonthlyCharges { get; set; }
        public float CallCharges { get; set; } 
        public float ValueAddedServices { get; set; } 
        public float MobileInternetUsage { get; set; }  
        public float Roaming{ get; set; }  
        public float Discounts { get; set; }
        public float Taxes { get; set; }  
        public float TotalCharges { get; set; }
        public string WhoUploaded { get; set; }
        public DateTime UploadedDate { get; set; }
        public DateTime DateOfCreation { get; set; }
        public int ImportDateId { get; set; }

        public int YearId { get; set; }

        public int MonthId { get; set; }
        
        public List<MonthListClass> MonthList
        { 
            get;
            set;
        }

        

        public List<clsYearOfDate> YearList
        {
            get;
            set;
        }
    }

    public class MonthListClass
    {
        public int MonthSelectedId { get; set; }
        public string MonthName { get; set; }
    }


    public class clsYearOfDate
    {
        public int YearSelectedId { get; set; }
        public string YearOfDate { get; set; }
    }
}