using CCIOfficeServiceManagementSystem.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services.Description;


namespace CCIOfficeServiceManagementSystem.Controllers 
{
    [Authorize]
    public class UserManagementController : Controller
    {
        // 
        // GET: /UserManagement/ 

        public ActionResult Index(string sortorder, string controlfilter, string searchstring) 
        {
           
            List<UserModel> list = viewDetails(); 
            ViewBag.currentSort = sortorder;
            ViewBag.NameSortParm = String.IsNullOrEmpty(sortorder) ? "Name_desc" : "";
            if(searchstring!=null)
            {
                ViewBag.currentFilter = searchstring;
                var employeeDetails = from _model in list 
                                      select _model;
                if(!String.IsNullOrEmpty(searchstring))
                {
                    employeeDetails = employeeDetails.Where(A => A.EmployeeName.ToString().Contains(searchstring.ToString()));
                }
                
                employeeDetails = employeeDetails.OrderByDescending(A => A.EmployeeName);
                return View(employeeDetails.ToList());
            }
            var EmployeeDetails = from _usermodel in list
                                  select _usermodel;
            return View(EmployeeDetails.ToList());
        }
        public ActionResult Create()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            CCIRepository repository = CCIRepository.CreateRepository();
            UserModel _usermodel = new UserModel();
            if(ModelState.IsValid)
            {
                //_usermodel.EmployeeId = Convert.ToInt32(collection["EmployeeId"]); 
                _usermodel.EmployeeName = collection["EmployeeName"].ToString();
                _usermodel.AccountName = collection["AccountName"].ToString();
                _usermodel.EmailAddress = collection["EmailAddress"].ToString();
                _usermodel.CostCenterId = Convert.ToInt32(collection["CostCenterId"]);
                _usermodel.MobileNumber = Convert.ToInt64(collection["MobileNumber"]);
                _usermodel.MobileAcNumber = Convert.ToInt64(collection["MobileAcNumber"]);
                _usermodel.DataCardNumber = Convert.ToInt64(collection["DataCardNumber"]);
                _usermodel.DatacardAcNumber = Convert.ToInt64(collection["DatacardAcNumber"]);
                _usermodel.OfficeLocation = collection["OfficeLocation"].ToString();
                repository.CreateANewData(_usermodel);
            }
            return View();
        }

        public List<UserModel> viewDetails()
        {
            CCIRepository repository = CCIRepository.CreateRepository();
            List<UserModel> list = new List<UserModel>();
            list = repository.viewEmployeeDetails();
            return list;
        }


        public ActionResult Delete(Int32 EmployeeId)
        {
            UserModel _usermodel = new UserModel();
            try
            {
                CCIRepository repository = CCIRepository.CreateRepository();
                _usermodel = repository.getSingleEmployeeDetail(EmployeeId);
            }
            catch(Exception ex)
            {
                
            }
            return View(_usermodel);
        }

        [HttpPost]
        public ActionResult Delete(UserModel _model)
        {
            CCIRepository repository = CCIRepository.CreateRepository();
            //if(ModelState.IsValid)
            //{
            //    try
            //    {
            int Id = _model.EmployeeId;
                repository.DeleteDetails(Id);
                return RedirectToAction("Index");
            //        }
            //    catch(Exception ex)
            //    {
                    
            //    }
            //    return RedirectToAction("Index");
            //}
            //else
            //{
            //    return View();
            //}

        }

        public ActionResult Edit(Int32 EmployeeId)
        {
            CCIRepository repository = CCIRepository.CreateRepository();
            UserModel _model = new UserModel();
            try
            {
                _model = repository.getSingleEmployeeDetail(EmployeeId);
            }
            catch(Exception ex)
            {
 
            }

            return View(_model);
        }


        [HttpPost]
        public ActionResult Edit(Int32 EmployeeId,FormCollection collection)
        {
            CCIRepository _repository = CCIRepository.CreateRepository();
            UserModel _usermodel = new UserModel();
            if(ModelState.IsValid)
            {
                _usermodel.EmployeeId = EmployeeId;
                //_usermodel.EmployeeId = Convert.ToInt32(collection["EmployeeId"]);
                    _usermodel.EmployeeName = collection["EmployeeName"].ToString();
                    _usermodel.AccountName = collection["AccountName"].ToString();
                    _usermodel.EmailAddress = collection["EmailAddress"].ToString();
                    _usermodel.CostCenterId = Convert.ToInt32(collection["CostCenterId"]);
                    _usermodel.MobileNumber = Convert.ToInt64(collection["MobileNumber"]);
                    _usermodel.MobileAcNumber = Convert.ToInt32(collection["MobileAcNumber"]);
                    _usermodel.DataCardNumber = Convert.ToInt32(collection["DataCardNumber"]);
                    _usermodel.DatacardAcNumber = Convert.ToInt32(collection["DatacardAcNumber"]);
                    _usermodel.OfficeLocation = collection["OfficeLocation"].ToString();

                    _repository.EditSingleData(_usermodel);
            }
            return RedirectToAction("Index");
        }


        public ActionResult Details(Int32 EmployeeId)
        {
            UserModel _usermodel = new UserModel();
            CCIRepository _repository = CCIRepository.CreateRepository();
            _usermodel = _repository.getSingleEmployeeDetail(EmployeeId);
            return View(_usermodel);
        }
    }
}
