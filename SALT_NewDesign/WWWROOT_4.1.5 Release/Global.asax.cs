#define debugMode 
using System;
using System.Collections;
using System.ComponentModel;
using System.Web;
using System.Web.SessionState;
using System.Web.Security;
using System.Security.Principal;
using System.Threading;
using System.Data;
using System.Configuration;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using System.Globalization;

namespace Bdw.Application.Salt.Web
{

	/// <summary>
	/// Summary description for Global.
	/// </summary>
	public class Global : System.Web.HttpApplication
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Default constructor
        /// </summary>
		public Global()
		{
			InitializeComponent();
		}	
		
        /// <summary>
        /// Application has started event
        /// </summary>
        /// <param name="sender">Object</param>
        /// <param name="e">EventArgs</param>
		protected void Application_Start(Object sender, EventArgs e)
		{
            try
            {
                SecurityHandler objSecurityHandler = new SecurityHandler();
                string strEncPassword = ConfigurationSettings.AppSettings["ConnectionStringPassword"];
                string strDecPassword = objSecurityHandler.Decrypt(strEncPassword);
                HttpContext.Current.Application["password"] = strDecPassword;

                // Get Application level Settings from database and store in the Application state
                ApplicationSettings.InitializeSettings();
            }
            catch
            {
                // Nothing can be done.
            }
		}
 
        /// <summary>
        /// Session has started event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
		protected void Session_Start(Object sender, EventArgs e)
		{

		}

        /// <summary>
        /// Application_BeginRequest event
        /// </summary>
        /// <param name="sender">Object</param>
        /// <param name="e">EventArgs</param>
		protected void Application_BeginRequest(Object sender, EventArgs e)
		{
			string cultureName = "en-AU";
			
			//-- Use value from QueryString
			if (Request.QueryString["l"] != null)
			{
				cultureName = Request.QueryString["l"].ToString();
			}
			//-- Use value from Cookie
			else if (Request.Cookies["currentCulture"] != null)
			{
				cultureName = Request.Cookies["currentCulture"].Value;
			}

			CultureInfo c = new CultureInfo("en-AU");
			System.Globalization.CultureInfo c2 = new System.Globalization.CultureInfo(cultureName);
			Thread.CurrentThread.CurrentCulture = c;
			Thread.CurrentThread.CurrentUICulture = c2;

			Response.Cookies["currentCulture"].Value = cultureName;
			Response.Cookies["currentCulture"].Expires = DateTime.Now.AddYears(1);
		}

        /// <summary>
        /// Application_EndRequest event
        /// </summary>
        /// <param name="sender">Object</param>
        /// <param name="e">EventArgs</param>
		protected void Application_EndRequest(Object sender, EventArgs e)
		{

		}
		/// <summary>
		/// //Load user data and set user role (login User type)
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Application_AuthenticateRequest(Object sender, EventArgs e)
		{
			if (HttpContext.Current.User != null)
			{
				if (HttpContext.Current.User.Identity.IsAuthenticated)
				{
					//Load user data and set user role (login User type)
					if (HttpContext.Current.User.Identity is FormsIdentity)
					{
						string strUserData;
						UserData objUserData;
						
						//1. Get Authentication Data
						strUserData = WebSecurity.GetAuthData();
						objUserData = new UserData(strUserData);

						//2. Check whether user role has been changed(only check administrator)
						//if changed, signout and redirect to login page
						if (objUserData.UserType!= UserType.User)
						{
                            UserType enmUserType = UserType.User;
							BusinessServices.User objUser = new BusinessServices.User();
                            //try
                            //{
                                int uid = UserContext.UserID;
                                enmUserType = objUser.GetUserType(uid);
                            //}
                            //catch (Exception ex)
                            //{
                            //     throw new ApplicationException("Convert UserID to int32 failed, UserID = '" + UserContext.UserID.ToString() + "'");
                            //}
							if (enmUserType != objUserData.UserType)
							{
								WebSecurity.SignOut();
							}
						}
					
						//3.Save the user data in the current context
						UserContext.UserData = objUserData;
						
						//4. Set User Roles (Login User type act as user role, they are: SaltAdmin = 1, OrgAdmin = 2, UnitAdmin = 3, User = 4
						string[] roles = new string[1];
						roles[0] = UserContext.UserData.UserType.ToString();
						HttpContext.Current.User = new GenericPrincipal(HttpContext.Current.User.Identity,roles);											}
				}
			}
		}

        /// <summary>
        /// Application Error event. An error has occurred within the application and this
        /// method must handle it and attempt to log it to the database
        /// </summary>
        /// <param name="sender">Object</param>
        /// <param name="e">EventArgs</param>
		protected void Application_Error(Object sender, EventArgs e)
		{
			// Try and log error.
            try
			{

				Exception ex = HttpContext.Current.Error.GetBaseException();  
				if (VerifyAppConnectionsAvailability() == false ||
					VerifyRepConnectionsAvailability() == false)
				{
					//string strMessage = "SQL Connection Error";
					//ApplicationException SqlConnectionException = new ApplicationException(strMessage);
					//ErrorHandler.ErrorLog SecurityErrorLog = new ErrorHandler.ErrorLog(SqlConnectionException,ErrorLevel.High,"Global.asas","Application_Error","See previous exception");
#if !debugMode
                                    if (Request.Url.Host.ToLower().Equals("127.0.0.2"))
                {
                    Response.Redirect("https://"+Request.Url.Host+"/general/errors/SqlConnectionException.aspx");

                }
                else
                {
				    Response.Redirect("http://"+Request.Url.Host+"/general/errors/SqlConnectionException.aspx");
                }
                    	
#endif
                }
				else
				{
					if(ex.GetBaseException() is System.Web.HttpRequestValidationException )
					{
						// Log it as a regular errors
						ErrorHandler.ErrorLog ErrorLog = new ErrorHandler.ErrorLog(ex,ErrorLevel.High);  

						// Log security Errors differently
						string strMessage = "Security Error";
						strMessage += " User Host Address:" + Request.UserHostAddress.ToString();
						strMessage += " User Host Name:" + Request.UserHostName.ToString();
						strMessage += " User Agent:" + Request.UserAgent.ToString();
						strMessage += " User Request Type:" + Request.RequestType.ToString();
						strMessage += " User QueryString:" + Request.QueryString.ToString();

						ApplicationException SecurityException = new ApplicationException(strMessage);
                    
						ErrorHandler.ErrorLog SecurityErrorLog = new ErrorHandler.ErrorLog(SecurityException,ErrorLevel.High,"Global.asas","Application_Error","See previous exception");
                    
						Server.Transfer("/general/errors/ValidationException.aspx");
					}
					else
					{
						// Log all regular errors
                        new ErrorHandler.ErrorLog(ex, Bdw.Application.Salt.Data.ErrorLevel.Medium, "Global.asax.cs", "Application_Error", "Global.asax.cs");
                    }
				}
			}
			// Logging error failed
			catch(Exception ex)
			{
				string s = ex.Message;
			}
		}

        /// <summary>
        /// Session_End event
        /// </summary>
        /// <param name="sender">Object</param>
        /// <param name="e">EventArgs</param>
		protected void Session_End(Object sender, EventArgs e)
		{
			

		}

        /// <summary>
        /// Application_End event
        /// </summary>
        /// <param name="sender">Object</param>
        /// <param name="e">EventArgs</param>
		protected void Application_End(Object sender, EventArgs e)
		{

		}

		#region Private Methods
		private bool VerifyAppConnectionsAvailability()
		{
			System.Data.SqlClient.SqlConnection con = null;
			bool result = false;
			System.Data.SqlClient.SqlCommand cmd = null;

			try
			{
				con = new System.Data.SqlClient.SqlConnection();
				con.ConnectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
				con.Open();

				//Test app connnection
				cmd = new System.Data.SqlClient.SqlCommand("prcVersion_Get", con);
				String tmp = cmd.ExecuteScalar().ToString();

				result = true;
			}
			catch
			{
				result = false;
			}
			finally
			{
				if (con != null)
				{
					if (con.State != ConnectionState.Closed)
					{
						con.Close();
					}
				}

				con=null;
				cmd = null;
			}

			return result;
		}

		private bool VerifyRepConnectionsAvailability()
		{
			System.Data.SqlClient.SqlConnection con = null;
			bool result = false;
			System.Data.SqlClient.SqlCommand cmd = null;
			try
			{
				con = new System.Data.SqlClient.SqlConnection();				
				con.ConnectionString = ConfigurationSettings.AppSettings["RptConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
				con.Open();

				//Test app connnection
				cmd = new System.Data.SqlClient.SqlCommand("prcVersion_Get", con);
				String tmp = cmd.ExecuteScalar().ToString();
				
				result = true;
			}
			catch
			{
				result = false;
			}
			finally
			{
				if (con != null)
				{
					if (con.State != ConnectionState.Closed)
					{
						con.Close();
					}
				}

				con=null;
				cmd = null;
			}

			return result;
		}
		#endregion

		#region Web Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.components = new System.ComponentModel.Container();
		}
		#endregion
	}
}

