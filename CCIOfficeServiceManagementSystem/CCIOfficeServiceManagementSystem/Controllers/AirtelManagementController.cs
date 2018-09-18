using CCIOfficeServiceManagementSystem.Models;
using System;
using System.Data.Entity;
using System.Collections.Generic;   
using System.Data;
using System.Data.OleDb;  
using System.IO; 
using System.Linq; 
using System.Net;     
using System.Runtime.Serialization;   
using System.Runtime.Serialization.Json;    
using System.Web;    
using System.Web.Mvc;   
using System.Web.Script.Serialization;        
using System.Web.UI;   
using System.Web.UI.WebControls;   
using ClosedXML.Excel;
using Microsoft.Ajax.Utilities;   
using PagedList; 
using PagedList.Mvc;
using System.Data.Common;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser; 
using iTextSharp.text.pdf;
using System.Data.SqlClient;
namespace CCIOfficeServiceManagementSystem.Controllers
{   
    [Authorize]
    public class AirtelManagementController : Controller 
    {
        
        //   
        // GET: /AirtelManagement/
        public ActionResult Index() 
        {
            return View();
        }



        public ActionResult ImportExcelFile() 
        {
            return View();
        }


        //Post

        [HttpPost]
        public ActionResult ImportExcelFile(HttpPostedFileBase file,FormCollection collection)
        {
            CCIRepository repository = CCIRepository.CreateRepository(); 
            if(Request.Files["FileUpload"].ContentLength>0)
            {
                string fileExtension = System.IO.Path.GetExtension(Request.Files["FileUpload"].FileName);
                
                if(fileExtension==".xls"||fileExtension==".xlsx")
                {
                    string filename=Path.GetFileName(Request.Files["FileUpload"].FileName);
                    string fileLocation=string.Format("{0}{1}",Server.MapPath("/UploadedFile/"),filename); 

                    if (System.IO.File.Exists(fileLocation))
                        System.IO.File.Delete(fileLocation);
                    Request.Files["FileUpload"].SaveAs(fileLocation);
                    string excelConnectionString = string.Empty;
                    if(fileExtension==".xls")
                    {
                        excelConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + fileLocation + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"";
                    }
                    else if(fileExtension==".xlsx")
                    {
                        excelConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fileLocation + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"";
                    }

                    OleDbConnection excelConnection = new OleDbConnection(excelConnectionString);
                    excelConnection.Open();
                    DataTable dt = new DataTable();
                    dt = excelConnection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                    if(dt==null)
                    {
                        return null;
                    }
                    String[] excelsheets = new String[dt.Rows.Count];
                    int t = 0;
                    foreach(DataRow row in dt.Rows)
                    {
                        excelsheets[t] = row["TABLE_NAME"].ToString();
                        t++;
                    }
                    OleDbConnection excelConnection1 = new OleDbConnection(excelConnectionString);
                    DataSet ds = new DataSet();
                    string query = string.Format("Select * from [{0}]", excelsheets[0]);
                    using (OleDbDataAdapter dataAdapter = new OleDbDataAdapter(query, excelConnection1)) 
                    {
                        dataAdapter.Fill(ds);
                    }
                    AirtelManagementModel _model = new AirtelManagementModel();
                    _model.UploadedDate = DateTime.Now;
                    _model.DateOfCreation = Convert.ToDateTime(collection["DateOfCreation"].ToString());
                    var temp=repository.InsertImportDate(_model);
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        //AirtelManagementModel _model = new AirtelManagementModel();
                        _model.MobileAcNumber = Convert.ToInt64(ds.Tables[0].Rows[i]["accountno"]);
                        _model.AirtelNumber = Convert.ToInt64(ds.Tables[0].Rows[i]["airtelnumber"]);
                        _model.OneTime = Convert.ToInt32(ds.Tables[0].Rows[i]["Onetimecharges"]);
                        _model.MonthlyCharges = (float)Convert.ToDouble(ds.Tables[0].Rows[i]["monthlycharges"]);
                        _model.CallCharges = (float)Convert.ToDouble(ds.Tables[0].Rows[i]["Callcharges"]);
                        _model.ValueAddedServices = (float)Convert.ToDouble(ds.Tables[0].Rows[i]["Valueaddeservices"]);
                        _model.MobileInternetUsage = (float)Convert.ToDouble(ds.Tables[0].Rows[i]["mobileinternetusage"]);
                        _model.Roaming = (float)Convert.ToDouble(ds.Tables[0].Rows[i]["roaming"]);
                        _model.Discounts = (float)Convert.ToDouble(ds.Tables[0].Rows[i]["discounts"]);
                        _model.Taxes = (float)Convert.ToDouble(ds.Tables[0].Rows[i]["taxes"]);
                        _model.TotalCharges = (float)Convert.ToDouble(ds.Tables[0].Rows[i]["totalcharges"]);
                        _model.WhoUploaded = System.Web.HttpContext.Current.User.Identity.Name;
                        _model.ImportDateId = temp;
                        //_model.UploadedDate = DateTime.Now;
                        //_model.DateOfCreation = collection["DateOfCreation"].ToString();
                        repository.SaveData(_model);
                        //MemoryStream streampost = new MemoryStream();
                        //WebClient clientpost = new WebClient();
                        //clientpost.Headers["Content-Type"] = "application/json";
                        //DataContractJsonSerializer serializerpost = new DataContractJsonSerializer(typeof(AirtelManagementModel));
                        //serializerpost.WriteObject(streampost, _model);
                        //dynamic serviceUrl = string.Empty;

                        //string url = string.Format("{0},Save Details", serviceUrl);
                        //byte[] datapost = clientpost.UploadData(url, "Post", streampost.ToArray());

                        //streampost = new MemoryStream(datapost);
                        //serializerpost = new DataContractJsonSerializer(typeof(string));
                        //string result = (string)serializerpost.ReadObject(streampost);
                    }
                    }
                else
                {
                    ModelState.AddModelError("","Please Select a excel file");
                    return null;
                }
            }
            return RedirectToAction("Success", "Success");
        }


        public ActionResult ViewDataOfDatabase( string currentFilter, string searchString, int? page,FormCollection collection,int? Year, int? Month, String City) 
         {
             CCIRepository _repository = CCIRepository.CreateRepository();
             AirtelManagementModel _Airtelmodel = new AirtelManagementModel();
             IEnumerable<CityListClass> CityList = _repository.GetCities();
             IEnumerable<SelectListItem> CityNames = from c in CityList
                                                         select new SelectListItem()
                                                         {
                                                             Value = c.CityName.ToString(),
                                                             Text = c.CityName.ToString(),
                                                             Selected = c.CityName == Request["CityNames"],
                                                         };
             ViewBag.CityList = CityNames;
             IEnumerable<clsYearOfDate> SelectList = GetYears();
             //IEnumerable<MonthListClass> SelectMonthList = GetMonths(YearId);
             IEnumerable<SelectListItem> Yearitems = (from v in SelectList
                                                 select new SelectListItem()
                                                 {
                                                     Value = v.YearSelectedId.ToString(),
                                                     Text = v.YearOfDate.ToString(),
                                                     Selected = v.YearOfDate == Request["Yearitems"],
                                                 });

             ViewBag.SelectList = Yearitems;
             int DateId=0;
             string CityName = string.Empty; 
            
                    //int SelectedYear = Year;
                    //int SelectedMonth = Month;
                    CityName = City;
                    DateId = _repository.GetImportDateId(Year, Month);
                    //ViewBag.SelectedYear = SelectedYear;
                    //ViewBag.SelectedMonth = SelectedMonth;
                    ViewBag.SelectedCity = CityName;
             
             
             //IEnumerable<SelectListItem> MonthItems = (from m in SelectMonthList
             //                                          select new SelectListItem()
             //                                          {
             //                                              Value = m.MonthSelectedId.ToString(),
             //                                              Text = m.MonthName,
                                                           

             //                                          });
             //ViewBag.SelectMonthList = MonthItems;
             IEnumerable<SelectListItem> MonthItems = Enumerable.Empty<SelectListItem>();
             ViewBag.SelectMonthList = MonthItems;
            List<AirtelManagementModel> list = ViewDetails();
            //ViewBag.CurrentSort = sortorder;
            
            //ViewBag.PhoneSortParm = String.IsNullOrEmpty(sortorder) ? "Phone_desc" : "";
            if (searchString != null )
            {
                page = 1;
            }
            else
            {
               
                searchString = currentFilter;
            }
            //if(searchString!=null)
            //{
            ViewBag.Year = Year;
            ViewBag.Month = Month;
            ViewBag.City = City;
                ViewBag.CurrentFilter = searchString;
                var airteldetails = from _model in list
                                    select _model;
                if(!String.IsNullOrEmpty(searchString) && DateId!=0 && !String.IsNullOrEmpty(CityName))
                {
                    airteldetails = _repository.FilterAirtelDetails(searchString, DateId, CityName);
                    int PageSize = 5;
                    int PageNumber = (page ?? 1);
                    return View(airteldetails.ToPagedList(PageNumber, PageSize));
                }
                //airteldetails=airteldetails.OrderByDescending(A=>A.AirtelNumber);
                int pageSize = 5;
                int pageNumber = (page ?? 1); 
                //return View(airteldetails.ToList());
                return View(airteldetails.ToPagedList(pageNumber, pageSize));
            //}
            //if (list.Count > 0) 
            //{
            //    var airteldetails = from _model in list
            //                        select _model;
            //    return View(airteldetails.ToPagedList(pageNumber,pageSize));
            //}
            //else
            //{
            //    ModelState.AddModelError("Error", "No Data found in Database");
            //    return RedirectToAction("ImportExcelFile", "AirtelManagement");
            //}
        }
        public IEnumerable<clsYearOfDate> GetYears()
        {
            CCIRepository _repository = CCIRepository.CreateRepository();
            List<clsYearOfDate> list = new List<clsYearOfDate>();
            list = _repository.GetYearFromImportDate();
            return list;

        }

        [HttpPost]
        public  JsonResult GetMonths(int YearId)
        {


            
            CCIRepository _repository = CCIRepository.CreateRepository();
            List<MonthListClass> list = new List<MonthListClass>();
            list =  _repository.GetMonthFromImportDate(YearId);
            return Json(list);



        }



        public List<AirtelManagementModel> ViewDetails()  
        {
            CCIRepository _repository = CCIRepository.CreateRepository();
            List<AirtelManagementModel> list = new List<AirtelManagementModel>();
            //list = _repository.ViewAirtelDetails();
            return list;
        }

        //[HttpPost]
        //public ActionResult ExportData()  
        //{
        //    CCIRepository _repository=CCIRepository.CreateRepository();
        //    GridView _gridview = new GridView();
        //    _gridview.DataSource = _repository.ReportDetails();
        //    _gridview.DataBind();  
        //    //if(_gridview.Columns.Equals(""))
        //    //{
        //    //    _gridview.Columns[0].Visible = false;
        //    //}
        //    Response.ClearContent();
        //    Response.Buffer = true;
        //    Response.AddHeader("Content-disposition", "attachment;filename=AirtelDetails.xls");
        //    Response.ContentType = "application/ms-excel";
        //    Response.Charset = "";
        //    StringWriter _stringwriter = new StringWriter();
        //    HtmlTextWriter _textwriter = new HtmlTextWriter(_stringwriter);
        //    _gridview.RenderControl(_textwriter);
        //    Response.Output.Write(_stringwriter.ToString());
        //    Response.Flush();
        //    Response.End();
        //    return RedirectToAction("Success", "Success");
        //}
        public List<AirtelManagementModel> GetAirtelDetails()
        {

            CCIRepository _allData = CCIRepository.CreateRepository();
            List<AirtelManagementModel> _allAirtelData = new List<AirtelManagementModel>();
            _allAirtelData = _allData.ViewAirtelDetails();
            return _allAirtelData;
        }

        [HttpPost]
        public ActionResult ExportToExcel()
        {



            var grid = new System.Web.UI.WebControls.GridView();
            grid.DataSource = GetAirtelDetails();
            grid.DataBind();

            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment; filename=MyExcelFile.xls");
            Response.ContentType = "application/ms-excel";

            Response.Charset = "";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            grid.RenderControl(htw);

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();

            return View("Index");
        }
        [HttpPost]
        public ActionResult ExportToWord()
        {
            var grid = new System.Web.UI.WebControls.GridView();
            grid.DataSource = GetAirtelDetails();
            grid.DataBind();

            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment; filename=MyWordFile.doc");
            Response.ContentType = "application/vnd-word";

            Response.Charset = "";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            grid.RenderControl(htw);

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();

            return View("Index");
        }
        [HttpPost]
        public ActionResult ExportToPdf()
        {
            
            var grid = new System.Web.UI.WebControls.GridView();
            grid.DataSource = GetAirtelDetails(); 
            grid.DataBind();

            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment; filename=MyPdf.pdf");
            Response.ContentType = "application/pdf";

            Response.Charset = "";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            grid.RenderControl(htw);
            StringReader sr = new StringReader(sw.ToString());
            Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);
            HTMLWorker htmlparser = new HTMLWorker(pdfDoc);
            PdfWriter.GetInstance(pdfDoc, Response.OutputStream);
            pdfDoc.Open();
            htmlparser.Parse(sr);
            pdfDoc.Close();
            Response.Write(pdfDoc);

            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();

            return View("Index");
        } 
    
    }
}
