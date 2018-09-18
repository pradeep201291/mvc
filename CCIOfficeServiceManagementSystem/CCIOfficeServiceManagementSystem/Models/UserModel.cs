using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CCIOfficeServiceManagementSystem.Models
{
    public class UserModel
    {
        
        public int EmployeeId { get; set; } 
         
        [Required(ErrorMessage = "*value required")]
        [RegularExpression(@"[A-Za-z{1,20}]+(\s[A-Za-z]+)*", ErrorMessage = "*Enter text only")]
        public string EmployeeName { get; set; }
        [Required(ErrorMessage = "*value required")]
        [RegularExpression(@"[A-Za-z\s,{1,20}]+(\s[A-Za-z]+)?", ErrorMessage = "*Enter text only")]
        public string AccountName { get; set; }
         
        public string EmailAddress { get; set; }
        [Required(ErrorMessage = "*value required")]
        [RegularExpression(@"\d{3,10}", ErrorMessage = "*Enter maximum 10 digits")]
        public int CostCenterId { get; set; } 

        [Required(ErrorMessage = "*value required")]
        [RegularExpression(@"^\(?([0-9]{10})", ErrorMessage = "*Not a valid number, must be 10 digits")]
        public long MobileNumber { get; set; }
        [Required(ErrorMessage = "*value required")]
        [RegularExpression(@"\d{3,10}", ErrorMessage = "*Enter maximum 10 digits")]
        public long MobileAcNumber { get; set; }

        [RegularExpression(@"\d{3,10}", ErrorMessage = "*Enter maximum 10 digits")]
        public long DataCardNumber { get; set; }

        [RegularExpression(@"\d{3,10}", ErrorMessage = "*Enter maximum 10 digits")]
        public long DatacardAcNumber { get; set; }

        [Required(ErrorMessage = "Value Required")]
        [RegularExpression(@"[A-Za-z{1,20}]+(\s[A-Za-z]+)?", ErrorMessage = "*Enter text only")]
        public string OfficeLocation { get; set; }


        public List<CityListClass> OfficeLocationList { get; set; }

    }

    public class CityListClass
    {
        public int CityId { get; set; }
        public string CityName { get; set; }
    }
}