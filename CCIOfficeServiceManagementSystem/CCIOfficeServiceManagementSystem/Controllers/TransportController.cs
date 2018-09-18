using CCIOfficeServiceManagementSystem.Models;
using System;
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
namespace CCIOfficeServiceManagementSystem.Controllers
{
    [Authorize]
    public class TransportController : Controller
    {
        //
        // GET: /Transport/

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
        public ActionResult ImportExcelFile(HttpPostedFileBase file, FormCollection collection)
        {
            CCIRepository repository = CCIRepository.CreateRepository();
            if (Request.Files["FileUpload"].ContentLength > 0)
            {
                string fileExtension = System.IO.Path.GetExtension(Request.Files["FileUpload"].FileName);

                if (fileExtension == ".xls" || fileExtension == ".xlsx")
                {
                    string filename = Path.GetFileName(Request.Files["FileUpload"].FileName);
                    string fileLocation = string.Format("{0}{1}", Server.MapPath("/App_Data/ExcelFiles/"), filename);

                    if (System.IO.File.Exists(fileLocation))
                        System.IO.File.Delete(fileLocation);
                    Request.Files["FileUpload"].SaveAs(fileLocation);
                    string excelConnectionString = string.Empty;
                    if (fileExtension == ".xls")
                    {
                        excelConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + fileLocation + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"";
                    }
                    else if (fileExtension == ".xlsx")
                    {
                        excelConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fileLocation + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"";
                    }

                    OleDbConnection excelConnection = new OleDbConnection(excelConnectionString);
                    excelConnection.Open();
                    DataTable dt = new DataTable();
                    dt = excelConnection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                    if (dt == null)
                    {
                        return null;
                    }
                    String[] excelsheets = new String[dt.Rows.Count];
                    int t = 0;
                    foreach (DataRow row in dt.Rows)
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
                    Transport _model = new Transport();
                    _model.UploadedDate = DateTime.Now;
                    _model.DateOfCreation = Convert.ToDateTime(collection["DateOfCreation"].ToString());
                    var temp = repository.InsertTransImportDate(_model);
                    for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                    {
                        _model.PresentDate = Convert.ToDateTime(ds.Tables[0].Rows[i]["Date"]);
                        _model.Name = Convert.ToString(ds.Tables[0].Rows[i]["Name"]);
                        _model.Place = Convert.ToString(ds.Tables[0].Rows[i]["Place"]);
                        _model.Driver = Convert.ToString(ds.Tables[0].Rows[i]["Driver"]);
                        _model.VehicleNumber = Convert.ToInt32(ds.Tables[0].Rows[i]["Vehiclenumber"]);
                        _model.Amount = Convert.ToInt32(ds.Tables[0].Rows[i]["Amount"]);
                        _model.CostCentre = Convert.ToInt32(ds.Tables[0].Rows[i]["Cost centre"]);
                        _model.ImportDateId = temp;
                        repository.SaveTransData(_model);
                         
                    }
                }
                else
                {
                    ModelState.AddModelError("", "Please Select a excel file");
                    return null;
                }
            }
            return RedirectToAction("Success", "Transport");
        }
        public ActionResult ViewDataOfTransDatabase(string sortorder, string currentFilter, string MonthSearch, int? page, string YearSearch, string searchString)
        {
            CCIRepository repository = CCIRepository.CreateRepository();
            List<Transport> list = ViewDetails();
            ViewBag.CurrentSort = sortorder;

            ViewBag.PhoneSortParm = String.IsNullOrEmpty(sortorder) ? "Phone_desc" : "";
            if (searchString != null)
            {
                page = 1;
            }
            else
            {
                searchString = currentFilter;
            }
            
            ViewBag.CurrentFilter = searchString;
            var transportdetails = from _model in list
                                select _model;
            if (!String.IsNullOrEmpty(MonthSearch) && !String.IsNullOrEmpty(YearSearch))
            {
                transportdetails = repository.GetMnthAndYear(MonthSearch, YearSearch);
                //transportdetails = transportdetails.Where(A => A.PresentDate.ToString().Contains(MonthSearch.ToString()) && A.PresentDate.ToString().Contains(YearSearch.ToString()));

            }
            else if (!String.IsNullOrEmpty(searchString))
            {
                transportdetails = transportdetails.Where(A => A.Name.ToString().Contains(searchString.ToString()));
            }
            
            int pageSize = 5;
            int pageNumber = (page ?? 1);

            return View(transportdetails.ToPagedList(pageNumber, pageSize));
            
        }

        public List<Transport> ViewDetails()
        {
            CCIRepository _repository = CCIRepository.CreateRepository();
            List<Transport> list = new List<Transport>();
            list = _repository.ViewTransportDetails();
            return list;
        }

        public ActionResult Success()
        {
            return View();
        }

        [HttpPost]
        public ActionResult ExportToExcel()
        {



            var grid = new System.Web.UI.WebControls.GridView();
            grid.DataSource = ViewDetails();
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
    }



}
