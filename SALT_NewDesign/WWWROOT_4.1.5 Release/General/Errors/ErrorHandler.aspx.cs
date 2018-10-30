using System;
using System.Data;
using System.Configuration;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;
using System.Web;
using System.Web.Configuration;
using Localization;
namespace Bdw.Application.Salt.WebErrorHandler
{
	/// <summary>
	/// This page is just a static page used to inform the user that an error has occurred
	/// and that it has been logged.
	/// </summary>
	public partial class ErrorHandler : System.Web.UI.Page
	{
        /// <summary>
        /// Link to support location
        /// </summary>
		protected System.Web.UI.WebControls.HyperLink lnkSupport;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Label for error details
        /// </summary>
		protected System.Web.UI.WebControls.Label lblErrorDetails;
	
		/// <summary>
		/// Event handler for the Page_Load event
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            try
            {			
				// Support Email Address
				string supportEmail = ApplicationSettings.SupportEmail;
				this.lnkSupport.NavigateUrl ="mailto:" +  supportEmail;
				this.lnkSupport.Text = supportEmail;
				if (Convert.ToBoolean(Request.QueryString["LOGGED"]))
				{
					this.lblErrorDetails.Text = ResourceManager.GetString("lblErrorDetails4") + " " + (string)(Request.QueryString["message"]);
				}

				//Verify App connection
				if (VerifyAppConnectionsAvailability() == false ||
					VerifyRepConnectionsAvailability() == false)
				{
					this.lblErrorDetails.Text = ResourceManager.GetString("lblErrorDetails1");//"Error Details: Salt (or Reporting) is temporarily unavailable - please try again later.<P> We apologise for any inconvenience this may have caused.</P> <P>Your Salt Team</P>";
					this.lblErrorDetails.CssClass = "WarningMessage";
					//Server.Transfer("/general/errors/SqlConnectionException.aspx");
				}
				else
				{
					this.lblErrorDetails.Text = ResourceManager.GetString("lblErrorDetails2") + " " + (string)(Request.QueryString["message"]);
					this.lblErrorDetails.CssClass = "SuccessMessage";
				}
				
            }
            catch
            {
				if (VerifyAppConnectionsAvailability() == false ||
					VerifyRepConnectionsAvailability() == false)
				{
					this.lblErrorDetails.Text = ResourceManager.GetString("lblErrorDetails3");//"Error Details: Salt (or Reporting) is temporarily unavailable - please try again later.<P> We apologise for any inconvenience this may have caused.</P> <P>Your Salt Team</P>";
					this.lblErrorDetails.CssClass = "WarningMessage";
					//Server.Transfer("/general/errors/SqlConnectionException.aspx");
				}
            }
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
		/// <summary>
		/// Attempts to connect to the database
		/// </summary>
		/// <returns>boolean value indicating if database is available</returns>
		private bool VerifyDatabaseConnection()
		{
			try
			{
				string strTemp="";
				// Just call a stored procedure and discard its return value
				using(StoredProcedure sp = new StoredProcedure("prcVersion_Get"))
				{
					strTemp = sp.ExecuteScalar().ToString();
				}
				return (true);
			}
			catch 
			{
				return(false);
			}
		}
		#endregion

		#region Web Form Designer generated code

        /// <summary>
        /// This call is required by the ASP.NET Web Form Designer.
        /// </summary>
        /// <param name="e">EventArgs</param>
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    

        }
		#endregion
	}
}