using CRUD_MVC5.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Mvc;

namespace CRUD_MVC5.Controllers
{
    // Database Connection
    public class dbConnector
    {
        private SqlConnection SqlConn = null;

        public SqlConnection GetConnection
        {
            get { return SqlConn; }
            set { SqlConn = value; }
        }

        public dbConnector()
        {
            string ConnectionString = ConfigurationManager.ConnectionStrings["dbConn"].ConnectionString;
            SqlConn = new SqlConnection(ConnectionString);
        }
    }

    // Customer Controller 
    public class CustomerController : Controller
    {
        // GET: Customer
        public ActionResult Index()
        {
            return View();
        }

        // GET: Customer
        [HttpGet]
        public ActionResult GetCustomer(int RowCountPerPage)
        {
            try
            {
                int PageNo = 0;
                int IsPaging = 0;

                CrudDataService objCrd = new CrudDataService();
                List<tblCustomer> modelCust = objCrd.GetCustomerList(PageNo, RowCountPerPage, IsPaging);
                return PartialView("_ListCustomer", modelCust);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        // GET: Customer/InfinitScroll
        [HttpGet]
        public ActionResult GetCustomer_Scroll(int PageNo, int RowCountPerPage)
        {
            try
            {
                Thread.Sleep(2000);
                int IsPaging = 1;
                CrudDataService objCrd = new CrudDataService();
                List<tblCustomer> modelCust = objCrd.GetCustomerList(PageNo, RowCountPerPage, IsPaging);
                return PartialView("_ListCustomer", modelCust);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        // GET: Customer/Create
        public ActionResult Create()
        {
            return View();
        }

        // GET: Customer/Create
        [HttpPost]
        public JsonResult Create(tblCustomer objCust)
        {
            try
            {
                CrudDataService objCrd = new CrudDataService();
                Int32 message = 0;

                if ((objCust.CustName != null) && (objCust.CustEmail != null)) message = objCrd.InsertCustomer(objCust);
                else message = -1;
                return Json(new
                {
                    Success = true,
                    Message = message
                });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        // GET: Customer/Edit
        public ActionResult Edit()
        {
            return View();
        }

        // GET: Customer/Edit
        [HttpGet]
        public ActionResult Edit(long? id)
        {
            try
            {
                CrudDataService objCrd = new CrudDataService();
                tblCustomer modelCust = objCrd.GetCustomerDetails(id);
                return View(modelCust);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        // GET: Customer/Edit
        [HttpPost]
        public JsonResult Edit(tblCustomer objCust)
        {
            try
            {
                CrudDataService objCrd = new CrudDataService();
                Int32 message = 0;
                message = objCrd.UpdateCustomer(objCust);
                return Json(new
                {
                    Success = true,
                    Message = message
                });

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        // GET: Customer/Delete
        [HttpPost]
        public JsonResult Delete(long? id)
        {
            try
            {
                CrudDataService objCrd = new CrudDataService();
                Int32 message = 0;
                message = objCrd.DeleteCustomer(id);
                return Json(new
                {
                    Success = true,
                    Message = message
                });

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }

    // Database Service
    public class CrudDataService
    {
        public List<tblCustomer> GetCustomerList(int PageNo, int RowCountPerPage, int IsPaging)
        {
            dbConnector objConn = new dbConnector();
            SqlConnection Conn = objConn.GetConnection;
            Conn.Open();

            try
            {
                List<tblCustomer> _listCustomer = new List<tblCustomer>();
                //_listCustomer = null;

                if (Conn.State != System.Data.ConnectionState.Open)
                    Conn.Open();

                SqlCommand objCommand = new SqlCommand("READ_CUSTOMER", Conn);
                objCommand.CommandType = CommandType.StoredProcedure;
                objCommand.Parameters.AddWithValue("@PageNo", PageNo);
                objCommand.Parameters.AddWithValue("@RowCountPerPage", RowCountPerPage);
                objCommand.Parameters.AddWithValue("@IsPaging", IsPaging);
                SqlDataReader _Reader = objCommand.ExecuteReader();

                while (_Reader.Read())
                {
                    tblCustomer objCust = new tblCustomer();
                    objCust.CustID = Convert.ToInt32(_Reader["CustID"]);
                    objCust.CustName = _Reader["CustName"].ToString();
                    objCust.CustEmail = _Reader["CustEmail"].ToString();
                    objCust.CustAddress = _Reader["CustAddress"].ToString();
                    objCust.CustContact = _Reader["CustContact"].ToString();
                    _listCustomer.Add(objCust);
                }

                return _listCustomer;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (Conn != null)
                {
                    if (Conn.State == ConnectionState.Open)
                    {
                        Conn.Close();
                        Conn.Dispose();
                    }
                }
            }
        }

        public tblCustomer GetCustomerDetails(long? id)
        {

            dbConnector objConn = new dbConnector();
            SqlConnection Conn = objConn.GetConnection;
            Conn.Open();

            try
            {
                tblCustomer objCust = new tblCustomer();

                if (Conn.State != System.Data.ConnectionState.Open)
                    Conn.Open();

                SqlCommand objCommand = new SqlCommand("VIEW_CUSTOMER", Conn);
                objCommand.CommandType = CommandType.StoredProcedure;
                objCommand.Parameters.AddWithValue("@CustID", id);
                SqlDataReader _Reader = objCommand.ExecuteReader();

                while (_Reader.Read())
                {
                    objCust.CustID = Convert.ToInt32(_Reader["CustID"]);
                    objCust.CustName = _Reader["CustName"].ToString();
                    objCust.CustEmail = _Reader["CustEmail"].ToString();
                    objCust.CustAddress = _Reader["CustAddress"].ToString();
                    objCust.CustContact = _Reader["CustContact"].ToString();
                }

                return objCust;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (Conn != null)
                {
                    if (Conn.State == ConnectionState.Open)
                    {
                        Conn.Close();
                        Conn.Dispose();
                    }
                }
            }
        }

        public Int32 InsertCustomer(tblCustomer objCust)
        {
            dbConnector objConn = new dbConnector();
            SqlConnection Conn = objConn.GetConnection;
            Conn.Open();

            int result = 0;

            try
            {
                if (Conn.State != System.Data.ConnectionState.Open)
                    Conn.Open();

                SqlCommand objCommand = new SqlCommand("CREATE_CUSTOMER", Conn);
                objCommand.CommandType = CommandType.StoredProcedure;
                objCommand.Parameters.AddWithValue("@CustName", objCust.CustName);
                objCommand.Parameters.AddWithValue("@CustEmail", objCust.CustEmail);
                objCommand.Parameters.AddWithValue("@CustAddress", objCust.CustAddress);
                objCommand.Parameters.AddWithValue("@CustContact", objCust.CustContact);

                result = Convert.ToInt32(objCommand.ExecuteScalar());

                if (result > 0)
                {
                    return result;
                }
                else
                {
                    return 0;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (Conn != null)
                {
                    if (Conn.State == ConnectionState.Open)
                    {
                        Conn.Close();
                        Conn.Dispose();
                    }
                }
            }
        }

        public Int32 UpdateCustomer(tblCustomer objCust)
        {
            dbConnector objConn = new dbConnector();
            SqlConnection Conn = objConn.GetConnection;
            Conn.Open();

            int result = 0;

            try
            {
                if (Conn.State != System.Data.ConnectionState.Open)
                    Conn.Open();

                SqlCommand objCommand = new SqlCommand("UPDATE_CUSTOMER", Conn);
                objCommand.CommandType = CommandType.StoredProcedure;
                objCommand.Parameters.AddWithValue("@CustID", objCust.CustID);
                objCommand.Parameters.AddWithValue("@CustName", objCust.CustName);
                objCommand.Parameters.AddWithValue("@CustEmail", objCust.CustEmail);
                objCommand.Parameters.AddWithValue("@CustAddress", objCust.CustAddress);
                objCommand.Parameters.AddWithValue("@CustContact", objCust.CustContact);

                result = Convert.ToInt32(objCommand.ExecuteScalar());

                if (result > 0)
                {
                    return result;
                }
                else
                {
                    return 0;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (Conn != null)
                {
                    if (Conn.State == ConnectionState.Open)
                    {
                        Conn.Close();
                        Conn.Dispose();
                    }
                }
            }
        }

        public Int32 DeleteCustomer(long? id)
        {
            dbConnector objConn = new dbConnector();
            SqlConnection Conn = objConn.GetConnection;
            Conn.Open();

            int result = 0;

            try
            {
                if (Conn.State != System.Data.ConnectionState.Open)
                    Conn.Open();

                SqlCommand objCommand = new SqlCommand("DELETE_CUSTOMER", Conn);
                objCommand.CommandType = CommandType.StoredProcedure;
                objCommand.Parameters.AddWithValue("@CustID", id);
                result = Convert.ToInt32(objCommand.ExecuteScalar());

                if (result > 0)
                {
                    return result;
                }
                else
                {
                    return 0;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                if (Conn != null)
                {
                    if (Conn.State == ConnectionState.Open)
                    {
                        Conn.Close();
                        Conn.Dispose();
                    }
                }
            }
        }
    }
}