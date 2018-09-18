using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Common;
using System.Data;
using System.Data.Common;
using System.Web.Mvc;
 
namespace CCIOfficeServiceManagementSystem.Models   
{  
    public class CCIRepository 
    { 
        protected CCIRepository()   
        {  
              
        }  
        public static CCIRepository CreateRepository()   
        {    
            return new CCIRepository();
        }
        public LoginModel GetUserName()      
        {  
            LoginModel model = new LoginModel(); 
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection"); 
            IDataReader reader = _db.ExecuteReader("[dbo].GetUserName");
            while (reader.Read())
            {
                model.UserName = reader["UserName"].ToString();
                model.Password = reader["UserPassword"].ToString();
            }
            return (model);
        }



        public bool CreateANewData(UserModel _usermodel)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            _db.ExecuteNonQuery("[dbo].AddNewData",
                _usermodel.EmployeeName,
                _usermodel.AccountName,
                _usermodel.EmailAddress,
                _usermodel.CostCenterId,
                _usermodel.MobileNumber,
                _usermodel.MobileAcNumber,
                _usermodel.DataCardNumber,
                _usermodel.DatacardAcNumber,
                _usermodel.OfficeLocation);
            return true;

        }



        public List<UserModel> viewEmployeeDetails()
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            IDataReader _reader = _db.ExecuteReader("[dbo].viewEmployeeDetails");
            
            List<UserModel> list = new List<UserModel>();
            while(_reader.Read())
            {
                UserModel _usermodel = new UserModel();
                _usermodel.EmployeeId = Convert.ToInt32(_reader["EmployeeId"]);
                _usermodel.EmployeeName = _reader["EmployeeName"].ToString();
                _usermodel.AccountName = _reader["AccountName"].ToString();
                _usermodel.EmailAddress = _reader["EmailAddress"].ToString();
                _usermodel.CostCenterId = Convert.ToInt32(_reader["CostCenterId"]);
                _usermodel.MobileNumber = Convert.ToInt64(_reader["MobileNumber"]);
                _usermodel.MobileAcNumber = Convert.ToInt64(_reader["MobileAcNumber"]);
                _usermodel.DataCardNumber = Convert.ToInt64(_reader["DataCardNumber"]);
                _usermodel.DatacardAcNumber = Convert.ToInt64(_reader["DatacardAcNumber"]);
                //_usermodel.OfficeLocation = _reader["OfficeLocation"].ToString();
                list.Add(_usermodel);
            }
           
            _reader.Close();
            return list;
        }


         
        public UserModel getSingleEmployeeDetail(Int32 EmployeeId)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            IDataReader _reader = _db.ExecuteReader("[dbo].getSingleEmployeeDetail", EmployeeId);
            UserModel _usermodel = new UserModel();
            while(_reader.Read())
            {
                _usermodel.EmployeeId = Convert.ToInt32(_reader["EmployeeId"]);
                _usermodel.EmployeeName = _reader["EmployeeName"].ToString();
                _usermodel.AccountName = _reader["AccountName"].ToString();
                _usermodel.EmailAddress = _reader["EmailAddress"].ToString();
                _usermodel.CostCenterId = Convert.ToInt32(_reader["CostCenterId"]);
                _usermodel.MobileNumber = Convert.ToInt64(_reader["MobileNumber"]);
                _usermodel.MobileAcNumber = Convert.ToInt64(_reader["MobileAcNumber"]);
                _usermodel.DataCardNumber = Convert.ToInt64(_reader["DataCardNumber"]);
                _usermodel.DatacardAcNumber = Convert.ToInt64(_reader["DatacardAcNumber"]);
                _usermodel.OfficeLocation = _reader["OfficeLocation"].ToString();
            }
            return _usermodel;
        }



        public bool DeleteDetails(Int32 EmployeeId)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            _db.ExecuteNonQuery("[dbo].DeleteDetails", EmployeeId);
            return true;
            
        }



        public bool EditSingleData(UserModel _usermodel)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            _db.ExecuteNonQuery("[dbo].EditSingleData",
                _usermodel.EmployeeId,
                _usermodel.EmployeeName,
                _usermodel.AccountName,
                _usermodel.EmailAddress,
                _usermodel.CostCenterId,
                _usermodel.MobileNumber,
                _usermodel.MobileAcNumber,
                _usermodel.DataCardNumber,
                _usermodel.DatacardAcNumber,
                _usermodel.OfficeLocationList);
            return true;
        }


        public bool SaveData(AirtelManagementModel _model)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            _db.ExecuteNonQuery("[dbo].SaveDataIntoDataBase", _model.MobileAcNumber,
                _model.AirtelNumber,
                _model.OneTime,
                _model.MonthlyCharges,
                _model.CallCharges,
                _model.ValueAddedServices,
                _model.MobileInternetUsage,
                _model.Roaming,
                _model.Discounts,
                _model.Taxes,
                _model.TotalCharges,
                _model.WhoUploaded,
                _model.ImportDateId
                //_model.DateId
                //_model.UploadedDate,
                //_model.DateOfCreation 
            );
            return true;
        }
        public bool SaveTransData(Transport _model)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            _db.ExecuteNonQuery("[dbo].SaveTransData", _model.PresentDate,
                _model.Name,
                _model.Place,
                _model.Driver,
                _model.VehicleNumber,
                _model.Amount,
                _model.CostCentre,
                _model.ImportDateId);
            return true;
        }

        public int InsertImportDate(AirtelManagementModel _model)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            DbCommand command = _db.GetStoredProcCommand("dbo.AddImportDates");
            
            _db.AddInParameter(command, "@UploadedDate", DbType.Date, _model.UploadedDate);
            _db.AddInParameter(command, "@ForWhichMonth", DbType.Date, _model.DateOfCreation);
            _db.AddOutParameter(command, "@DateId", DbType.Int32, 32);
            _db.ExecuteNonQuery(command);
            var columnid = Convert.ToInt32(_db.GetParameterValue(command,"@DateId").ToString());
            return columnid;
        }
        public int InsertTransImportDate(Transport _model)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            DbCommand command = _db.GetStoredProcCommand("dbo.AddTransImportDates");

            _db.AddInParameter(command, "@UploadedDate", DbType.Date, _model.UploadedDate);
            _db.AddInParameter(command, "@ForWhichMonth", DbType.Date, _model.DateOfCreation);
           _db.AddOutParameter(command, "@DateId", DbType.Int32,32);
            _db.ExecuteNonQuery(command);
           var columnid = Convert.ToInt32(_db.GetParameterValue(command, "@DateId").ToString());
            return columnid;
        }
        public List<AirtelManagementModel> ViewAirtelDetails()
        { 
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            IDataReader _reader = _db.ExecuteReader("[dbo].ViewAirtelDetails");
            List<AirtelManagementModel> list = new List<AirtelManagementModel>();
            while(_reader.Read())
            {
                AirtelManagementModel _model = new AirtelManagementModel();
                _model.MobileAcNumber = Convert.ToInt64(_reader["AccountNo"]);
                _model.AirtelNumber = Convert.ToInt64(_reader["AirtelNumber"]);
                _model.OneTime = Convert.ToInt16(_reader["OneTimeCharges"]);
                _model.MonthlyCharges = (float)Convert.ToDouble(_reader["MonthlyCharges"]);
                _model.CallCharges = (float)Convert.ToDouble(_reader["CallCharges"]);
                _model.ValueAddedServices = (float)Convert.ToDouble(_reader["ValueAddedServices"]);
                _model.MobileInternetUsage = (float)Convert.ToDouble(_reader["MobileInternetUsage"]);
                _model.Roaming = (float)Convert.ToDouble(_reader["Roaming"]);
                _model.Discounts = (float)Convert.ToDouble(_reader["Discounts"]); 
                _model.Taxes = (float)Convert.ToDouble(_reader["Taxes"]);
                _model.TotalCharges = (float)Convert.ToDouble(_reader["TotalCharges"]);
                _model.ImportDateId = Convert.ToInt32(_reader["ImportId"]);
                //_model.UploadedDate = (DateTime)(_reader["UploadedDate"]);
                //_model.DateOfCreation = _reader["ForWhichMonth"].ToString();
                list.Add(_model);
            }
            _reader.Close();
            return list;
        }
        public List<Transport>  ViewTransportDetails()
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            IDataReader _reader = _db.ExecuteReader("[dbo].ViewTranportDetails");
            List<Transport> list = new List<Transport>();
            while(_reader.Read())
            {
                Transport _model = new Transport();
                _model.PresentDate = Convert.ToDateTime(_reader["PresentDate"]);
                _model.Name = Convert.ToString(_reader["Name"]);
                _model.Place = Convert.ToString(_reader["Place"]);
                _model.Driver = Convert.ToString(_reader["Driver"]);
                _model.VehicleNumber = Convert.ToInt32(_reader["Vehiclenumber"]);
                _model.Amount = Convert.ToInt32(_reader["Amount"]);
                _model.CostCentre = Convert.ToInt32(_reader["Costcentre"]);
                list.Add(_model);
            }
            _reader.Close();
            return list;
        }

        public List<AirtelReportModel> ReportDetails()
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            IDataReader _reader = _db.ExecuteReader("[dbo].ViewReportDetails");
            List<AirtelReportModel> _list = new List<AirtelReportModel>();
            while(_reader.Read())
            {
                AirtelReportModel _model = new AirtelReportModel();
                _model.AirtelNumber = Convert.ToInt64(_reader["MobileNumber"]);
                _model.EmployeeName = _reader["EmployeeName"].ToString();
                _model.CostCenterId = Convert.ToInt64(_reader["CostCenterId"]);
                _model.Amount = (float)Convert.ToDouble(_reader["TotalCharges"]);
                _list.Add(_model);
            }
            _reader.Close();
            return _list;
        }

        public List<Transport> GetMnthAndYear(string par1,string par2)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            IDataReader _reader = _db.ExecuteReader("[dbo].GetMonthData",par1,par2);
            List<Transport> list = new List<Transport>();
            while (_reader.Read())
            {
                Transport _model = new Transport();
                _model.PresentDate = Convert.ToDateTime(_reader["PresentDate"]);
                _model.Name = Convert.ToString(_reader["Name"]);
                _model.Place = Convert.ToString(_reader["Place"]);
                _model.Driver = Convert.ToString(_reader["Driver"]);
                _model.VehicleNumber = Convert.ToInt32(_reader["Vehiclenumber"]);
                _model.Amount = Convert.ToInt32(_reader["Amount"]);
                _model.CostCentre = Convert.ToInt32(_reader["Costcentre"]);
                list.Add(_model);
            }
            _reader.Close();
            return list;
        }



        //public List<AirtelManagementModel> GetMnthAndYearForAirtel(string month,string year)
        //{
        //    Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
        //    IDataReader _reader = _db.ExecuteReader("[dbo].GetMonthDataForAirtel",month,year);
        //    List<AirtelManagementModel> list = new List<AirtelManagementModel>();
        //    while (_reader.Read())
        //    {
        //        AirtelManagementModel _model = new AirtelManagementModel();
        //        _model.MobileAcNumber = Convert.ToInt64(_reader["AccountNo"]);
        //        _model.AirtelNumber = Convert.ToInt64(_reader["AirtelNumber"]);
        //        _model.OneTime = Convert.ToInt16(_reader["OneTimeCharges"]);
        //        _model.MonthlyCharges = (float)Convert.ToDouble(_reader["MonthlyCharges"]);
        //        _model.CallCharges = (float)Convert.ToDouble(_reader["CallCharges"]);
        //        _model.ValueAddedServices = (float)Convert.ToDouble(_reader["ValueAddedServices"]);
        //        _model.MobileInternetUsage = (float)Convert.ToDouble(_reader["MobileInternetUsage"]);
        //        _model.Roaming = (float)Convert.ToDouble(_reader["Roaming"]);
        //        _model.Discounts = (float)Convert.ToDouble(_reader["Discounts"]);
        //        _model.Taxes = (float)Convert.ToDouble(_reader["Taxes"]);
        //        _model.TotalCharges = (float)Convert.ToDouble(_reader["TotalCharges"]);
        //        //_model.UploadedDate = (DateTime)(_reader["UploadedDate"]);
        //        //_model.DateOfCreation = _reader["ForWhichMonth"].ToString();
        //        list.Add(_model);
        //    }
        //    _reader.Close();
        //    return list;
        //}

        public List<clsYearOfDate> GetYearFromImportDate() 
        { 
            
            Database _db=DatabaseFactory.CreateDatabase("CCIDBConnection");
            IDataReader _reader = _db.ExecuteReader("[dbo].GetYearFromDates");
            List<clsYearOfDate> _list = new List<clsYearOfDate>();
            while(_reader.Read()) 
            {
                clsYearOfDate _model = new clsYearOfDate();
                _model.YearSelectedId = Convert.ToInt32(_reader["Id"]);
                _model.YearOfDate = (string)_reader["YearOfDate"];
                 
                _list.Add(_model);
            }
            _reader.Close();
            return _list;
        }

        public List<MonthListClass> GetMonthFromImportDate(int YearId)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            IDataReader _reader = _db.ExecuteReader("[dbo].GetMonthFromDates",YearId);
            List<MonthListClass> _list = new List<MonthListClass>();
            while(_reader.Read())
            {
                MonthListClass _model = new MonthListClass();
                _model.MonthSelectedId = Convert.ToInt32(_reader["MonthId"]);
                _model.MonthName = _reader["MonthOfDate"].ToString();
                _list.Add(_model);
            }
            _reader.Close();
            return _list;
        }


        public int GetImportDateId(int? SelectedYear,int? SelectedMonth)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            IDataReader _reader = _db.ExecuteReader("[dbo].GetImportDateId", SelectedYear, SelectedMonth);
            int ImportDateId;
            while(_reader.Read())
            {
                ImportDateId = Convert.ToInt16(_reader["DateId"]);
                return ImportDateId;
            }
            return 0;
        }


        public List<CityListClass> GetCities()
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            IDataReader _reader = _db.ExecuteReader("[dbo].GetCitiesFromDatabase");
            List<CityListClass> _list = new List<CityListClass>();
            while(_reader.Read())
            {
                CityListClass _city = new CityListClass();
                _city.CityId = Convert.ToInt16(_reader["CityId"]);
                _city.CityName = _reader["CityName"].ToString();
                _list.Add(_city);
            }
            _reader.Close();
            return _list;
        }


        public List<AirtelManagementModel> FilterAirtelDetails(string SearchString,int DateId,string CityName)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            IDataReader _reader = _db.ExecuteReader("[dbo].FilterAirtelDetails", SearchString, DateId, CityName);
            List<AirtelManagementModel> _list = new List<AirtelManagementModel>();
            while(_reader.Read())
            {
                AirtelManagementModel _model = new AirtelManagementModel();
                _model.MobileAcNumber = Convert.ToInt32(_reader["AccountNo"].ToString());
                _model.AirtelNumber = Convert.ToInt64(_reader["AirtelNumber"].ToString());
                _model.OneTime = Convert.ToInt16(_reader["OneTimeCharges"].ToString());
                _model.MonthlyCharges = (float)Convert.ToDouble(_reader["MonthlyCharges"].ToString());
                _model.CallCharges = (float)Convert.ToDouble(_reader["CallCharges"].ToString());
                _model.ValueAddedServices = (float)Convert.ToDouble(_reader["ValueAddedServices"].ToString());
                _model.MobileInternetUsage = (float)Convert.ToDouble(_reader["MobileInternetUsage"].ToString());
                _model.Roaming = (float)Convert.ToDouble(_reader["Roaming"].ToString());
                _model.Discounts = (float)Convert.ToDouble(_reader["Discounts"].ToString());
                _model.Taxes = (float)Convert.ToDouble(_reader["Taxes"]);
                _model.TotalCharges = (float)Convert.ToDouble(_reader["TotalCharges"].ToString());
                _list.Add(_model);
            }
            _reader.Close();
            return _list;
        }

        public bool UpadatePass(LocalPasswordModel _model)
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            _db.ExecuteNonQuery("[dbo].SaveNewPassData", _model.OldPassword, _model.NewPassword
                 );
            return true;
        }

        public LoginModel GetPassword()
        {
            Database _db = DatabaseFactory.CreateDatabase("CCIDBConnection");
            IDataReader _reader = _db.ExecuteReader("[dbo].GetPassword");
            LoginModel _mod = new LoginModel();
            while (_reader.Read())
            {

                _mod.Password = _reader["UserPassword"].ToString();
            }
            return (_mod);
        }
    }
}