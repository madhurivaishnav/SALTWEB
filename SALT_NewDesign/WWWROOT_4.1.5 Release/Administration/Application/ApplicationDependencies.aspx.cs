using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Management;
using System.Configuration;
using System.Globalization;
using System.Web.Mail;


using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;

namespace Bdw.Application.Salt.Web.Administration.Application
{
	/// <summary>
	/// Summary description for ApplicationDependencies.
	/// </summary>
	public partial class ApplicationDependencies : System.Web.UI.Page
	{

        /// <summary>
        /// Label to display message
        /// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// Label to display database version
        /// </summary>
		protected System.Web.UI.WebControls.Label lblDatabaseVersion;

        /// <summary>
        /// Label to display operating system
        /// </summary>
		protected System.Web.UI.WebControls.Label lblOperatingSystem;

        /// <summary>
        /// Label to display computer system details
        /// </summary>
		protected System.Web.UI.WebControls.Label lblComputerSystem;

        /// <summary>
        /// Label to display processor type
        /// </summary>
		protected System.Web.UI.WebControls.Label lblSystemProcessor;

        /// <summary>
        /// Label to display version of the .net framework
        /// </summary>
		protected System.Web.UI.WebControls.Label lblFrameworkVersion;

        /// <summary>
        /// Label to display iis version
        /// </summary>
		protected System.Web.UI.WebControls.Label lblIISVersion;

        /// <summary>
        /// Label to display the email address of support
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtToEmail;

        /// <summary>
        /// Button to send email
        /// </summary>
		protected System.Web.UI.WebControls.Button btnSend;

        /// <summary>
        /// Validator for email
        /// </summary>
		protected System.Web.UI.WebControls.RegularExpressionValidator vldToEmail;

        /// <summary>
        ///  Validator for email
        /// </summary>
		protected System.Web.UI.WebControls.RequiredFieldValidator rvlToEmail;

        /// <summary>
        ///  Validator summary for email
        /// </summary>
		protected System.Web.UI.WebControls.ValidationSummary vldSummary;

        /// <summary>
        /// Label for from name
        /// </summary>
		protected System.Web.UI.WebControls.Label lblFromName;

        /// <summary>
        /// Label for from email
        /// </summary>
		protected System.Web.UI.WebControls.Label lblFromEmail;

        /// <summary>
        /// Textbox for body of email
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtBody;

        /// <summary>
        /// Label for mail server name
        /// </summary>
		protected System.Web.UI.WebControls.Label lblMailServer;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Label for email subject
        /// </summary>
		protected System.Web.UI.WebControls.Label lblSubject;
	
        /// <summary>
        /// Page load event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			if (!Page.IsPostBack) 
			{
				this.GetSystemVersion();
				this.GetMailSettings();
			}
		}

        /// <summary>
        /// Get the system version from the database
        /// </summary>
		private void GetSystemVersion()
		{
			//Get Database version
			BusinessServices.Application app= new BusinessServices.Application();
			this.lblDatabaseVersion.Text = app.GetDatabaseVersion().Replace("\n","<br>");
			
			ManagementObjectSearcher query;
			ManagementObjectCollection queryCollection;
			string strData;

			//Get operating system 
			query = new ManagementObjectSearcher("select * from win32_OperatingSystem");
			queryCollection = query.Get();
			
			strData ="";
			foreach ( ManagementObject mo in queryCollection)
			{
				strData =  "Operating System: " + mo["Caption"];
				strData +="<br>" + "Version: " + mo["Version"];
				strData +="<br>" + "Manufacturer : " + mo["Manufacturer"];
				strData +="<br>" + "Computer Name : " +mo["csname"];
				strData +="<br>" + "Windows Directory : " + mo["WindowsDirectory"];
				strData +="<br>" + "Serial Number : " + mo["SerialNumber"];
			}
			this.lblOperatingSystem.Text = strData;

			//Get Computer Information
			query = new ManagementObjectSearcher("select * from Win32_ComputerSystem");
			queryCollection = query.Get();

			foreach ( ManagementObject mo in queryCollection)
			{
				strData = "Computer Manufacturer Name: " + mo["Manufacturer"];
				strData +="<br>" + "Computer Model: " + mo["model"];
				strData +="<br>" + "System Type: " + mo["SystemType"];
				strData +="<br>" + "Total Physical Memory: " + FormatSize(Int64.Parse(mo["totalphysicalmemory"].ToString()), false);
				strData +="<br>" + "Domain: " + mo["Domain"];
				//strData +="<br>" + "User Name: " + mo["UserName"];
			}
			this.lblComputerSystem.Text = strData;

			//Get Processor Information
			query = new ManagementObjectSearcher("select * from Win32_processor");
			queryCollection = query.Get();
			foreach ( ManagementObject mo in queryCollection)
			{
				strData ="Manufacturer: " + mo["Manufacturer"];
				strData +="<br>" + "Computer Processor: " + mo["Caption"];
				strData +="<br>" + "CPU Speed: " + FormatSpeed(Int64.Parse(mo["MaxClockSpeed"].ToString()));
                if (!(null==mo["L2CacheSize"] ))
				    strData +="<br>" + "L2 Cache Size: " + FormatSize(Int64.Parse(mo["L2CacheSize"].ToString()), false);
			}

			this.lblSystemProcessor.Text = strData;

			//this.lblOSVersion.Text  = Environment.OSVersion.ToString();

			this.lblFrameworkVersion.Text = Environment.Version.ToString();

			this.lblIISVersion.Text = Request.ServerVariables["SERVER_SOFTWARE"];

		}

        /// <summary>
        /// Displays the application settings
        /// </summary>
		private void GetMailSettings()
		{
				this.txtToEmail.Text =  ApplicationSettings.SupportEmail;
				this.lblMailServer.Text =  ApplicationSettings.MailServer;
		}

		#region Web Form Designer generated code

        /// <summary>
        /// This call is required by the ASP.NET Web Form Designer.
        /// </summary>
        /// <param name="e"></param>
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

		protected void btnSend_Click(object sender, System.EventArgs e)
		{
			try
			{
                BusinessServices.Email objMail = new BusinessServices.Email();
				BusinessServices.User objUser = new BusinessServices.User();
					
                // Get the current users details.
                DataTable dtbCurrentUserDetails = objUser.GetUser(UserContext.UserID);
    				
                // Setup email header
                string strFromName = dtbCurrentUserDetails.Rows[0]["FirstName"].ToString() + " " + dtbCurrentUserDetails.Rows[0]["LastName"].ToString();
                string strFromEmail =  dtbCurrentUserDetails.Rows[0]["Email"].ToString();
                string strToEmail = txtToEmail.Text;
                string strToName = txtToEmail.Text;

                objMail.setUserCopyEmailBody(txtBody.Text);
                objMail.SendEmail(strToEmail, strToName, strFromEmail, strFromName,null,null,lblSubject.Text,lblMailServer.Text,UserContext.UserData.OrgID,0);
				
                this.lblMessage.Text="Email sent to " + strToName +". Please check!";
                this.lblMessage.CssClass = "SuccessMessage";
			}
			catch(Exception ex)
			{
				this.lblMessage.Text=ex.Message;
			}
		}
		/// <summary>
		/// formatnumber to KB
		/// </summary>
		/// <param name="lSize"></param>
		/// <param name="booleanFormatOnly"></param>
		/// <returns>stringSize + " KB"</returns>
		private string FormatSize(Int64 lSize, bool booleanFormatOnly)
		{
			//Format number to KB
			string stringSize = "";
			NumberFormatInfo myNfi = new NumberFormatInfo();

			Int64 lKBSize = 0;

			if (lSize < 1024 ) 
			{
				if (lSize == 0) 
				{
					//zero byte
					stringSize = "0";
				}
				else 
				{
					//less than 1K but not zero byte
					stringSize = "1";
				}
			}
			else 
			{
				if (booleanFormatOnly == false)
				{
					//convert to KB
					lKBSize = lSize / 1024;
				}
				else 
				{
					lKBSize = lSize;
				}

				//format number with default format
				stringSize = lKBSize.ToString("n",myNfi);
				//remove decimal
				stringSize = stringSize.Replace(".00", "");
			}

			return stringSize + " KB";

		}

		/// <summary>
		/// Formate speed to Hz
		/// </summary>
		/// <param name="lSpeed"></param>
		/// <returns>stringSpeed</returns>
		private string FormatSpeed(Int64 lSpeed)
		{
			//Format number to Hz
			float floatSpeed = 0;
			string stringSpeed = "";
			NumberFormatInfo myNfi = new NumberFormatInfo();

			if (lSpeed < 1000 ) 
			{
				//less than 1G Hz
				stringSpeed = lSpeed.ToString() + "M Hz";
			}
			else 
			{
				//convert to Giga Hz
				floatSpeed = (float) lSpeed / 1000;
				stringSpeed = floatSpeed.ToString() + "G Hz";
			}

			return stringSpeed;

		}
	}
}
