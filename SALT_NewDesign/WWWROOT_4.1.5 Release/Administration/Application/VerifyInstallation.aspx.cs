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
using System.Data.SqlClient;
using System.Configuration;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using System.IO;

namespace Bdw.Application.Salt.Web.Administration.Application
{
	/// <summary>
	/// Summary description for VerifyInstallation.
	/// </summary>
	public partial class VerifyInstallation : System.Web.UI.Page
	{
        /// <summary>
        /// Verification results
        /// </summary>
        protected System.Web.UI.WebControls.Table tblResults;
        
        private string m_strSuccess="Correctly Configured";
        private string m_strFailure="Not Configured Correctly";
        private bool m_bAlternateRow=false;

		protected void Page_Load(object sender, System.EventArgs e)
		{
            if (!(IsPostBack))
            {
                RenderPage();
            }
		}
        private void RenderPage ()
        {
            bool bToolBookXSD = this.Check_ToolBookXSD();
            bool bImportUsersXSD = this.Check_ImportUsersXSD();
            bool bToolBookDestinationDirectory = this.Check_ToolBookDestinationDirectory();
            bool bErrorLogFileName = this.Check_ErrorLogFileName();
            bool bUploadFilePath = this.Check_UploadedFilePath();
            bool bOrganisationImagesPath=this.Check_OrganisationImagesPath();
            bool bConnectionString = this.Check_ConnectionString();
        }
       
        private bool Check_ToolBookXSD()
        {
            string strFile = "";
            try
            {
                strFile = ConfigurationSettings.AppSettings["ToolBookXSD"].ToString();    
                strFile = WebTool.MapToPhysicalPath(strFile);

                this.Check_CanReadFile(strFile);

                this.AddMessage(true,"Toolbook XSD" + "<BR>" + strFile, "File Exists/Readable");
                return(true);
                
            }
            catch  (Exception ex)
            {
                this.AddMessage(false,"Toolbook XSD" + "<BR>" + strFile,ex.Message);
                return(false);
            }
        }
        private bool Check_ImportUsersXSD ()
        {
            string strFile = "";
            try
            {
                strFile = ConfigurationSettings.AppSettings["ImportUsersXSD"].ToString();    
                strFile = WebTool.MapToPhysicalPath(strFile);

                this.Check_CanReadFile(strFile);

                this.AddMessage(true,"Import Users XSD" + "<BR>" + strFile,"File Exists/Readable");
                return(true);
                
            }
            catch  (Exception ex)
            {
                this.AddMessage(false,"Import Users XSD" + "<BR>" + strFile,ex.Message);
                return(false);
            }
            
        }
        private bool Check_ErrorLogFileName()
        {
            string strFile ="";
            try
            {
                strFile = ConfigurationSettings.AppSettings["ErrorLogFileName"].ToString();    
                strFile = WebTool.MapToPhysicalPath(strFile);

                this.Check_CanWriteFile(strFile);

                this.AddMessage(true,"Error Log File Name" + "<BR>" + strFile,"File Exists/Writable");
                return(true);
                
            }
            catch  (Exception ex)
            {
                this.AddMessage(false,"Error Log File Name" + "<BR>" + strFile,ex.Message);
                return(false);
            }    
        }
        private bool Check_ToolBookDestinationDirectory()
        {
            string strDirectory ="";
            try
            {
                // Construct the path on the web server where the Toolbook files will be placed
                strDirectory = ConfigurationSettings.AppSettings["ImportToolBookDestinationDirectory"].ToString();    
                strDirectory = WebTool.MapToPhysicalPath(strDirectory);
                
                this.Check_ReadWriteFileToDirectory(strDirectory);
                
                this.AddMessage(true,"ToolBook Destination Directory" + "<BR>" + strDirectory,"Directory Exists/Writable");
                return (true);
            }
            catch (Exception ex)
            {
                this.AddMessage(false,"ToolBook Destination Directory" + "<BR>" + strDirectory,ex.Message);
                return (false);
            }
            
        }

        private bool Check_OrganisationImagesPath()
        {
            string strDirectory = "";
            try
            {
                // Construct the path on the web server where the organisation images will be written
                strDirectory = ConfigurationSettings.AppSettings["OrganisationImagesPath"].ToString();    
                strDirectory = WebTool.MapToPhysicalPath(strDirectory);
                
                this.Check_ReadWriteFileToDirectory(strDirectory);
                
                this.AddMessage(true,"Organisation Images Path" + "<BR>" + strDirectory,"Directory Exists/Writable");
                return (true);
            }
            catch (Exception ex)
            {
                this.AddMessage(false,"Organisation Images Path" + "<BR>" + strDirectory,ex.Message);
                return (false);
            }
            
        }

        private bool Check_UploadedFilePath()
        {
            string strDirectory = "";
            try
            {
                // Construct the path on the web server where the uploaded files will be written
                strDirectory = ConfigurationSettings.AppSettings["UploadedFilePath"].ToString();    
                strDirectory = WebTool.MapToPhysicalPath(strDirectory);
                
                this.Check_ReadWriteFileToDirectory(strDirectory);
                
                this.AddMessage(true,"Uploaded File Path" + "<BR>" + strDirectory,"Directory Exists/Writable");
                return (true);
            }
            catch (Exception ex)
            {
                this.AddMessage(false,"Uploaded File Path" + "<BR>" + strDirectory,ex.Message);
                return (false);
            }
            
        }

        private bool Check_ConnectionString()
        {
            try
            {
                using(StoredProcedure sp = new StoredProcedure("prcVersion_Get"))
                {
                    sp.ExecuteNonQuery();
                }
                this.AddMessage(true,"Connection String","Database Connection Successful");
                return(true);
            }
            catch (Exception ex)
            {
                this.AddMessage(false,"Connection String",ex.Message);
                return(false);
            }
        }

        private void AddMessage (bool success,string condition, string message)
        {
            // create new row with three columns
            TableRow tblRow = new TableRow();
            TableCell tblCellSuccess = new TableCell();
            TableCell tblCellCondition = new TableCell();
            TableCell tblCellMessage = new TableCell();

            // Adjust cell properties based on success value
            if (success)
            {
                tblCellSuccess.ForeColor=Color.Green;
                tblCellMessage.Text = m_strSuccess;
            }
            else
            {
                tblCellSuccess.ForeColor=Color.Red;
                tblCellMessage.Text = m_strFailure;                
            }

            // Add text to cells 
            tblCellMessage.Text += "<BR>" + message;
            tblCellSuccess.Text=success.ToString();
            tblCellCondition.Text = condition;

            // Add cells to row and row to table
            tblRow.Cells.Add(tblCellSuccess);
            tblRow.Cells.Add(tblCellCondition);
            tblRow.Cells.Add(tblCellMessage);

            tblRow.VerticalAlign=VerticalAlign.Top;
            if (m_bAlternateRow)
            {
                tblRow.BackColor = Color.FromName("d0d0d0");
                m_bAlternateRow = false;
            }
            else
            {
                m_bAlternateRow = true;
            }

            this.tblResults.Rows.Add(tblRow);

        }

        private void Check_CanReadFile (string fileName)
        {
            FileStream fsTemp = new FileStream(fileName,FileMode.Open,FileAccess.Read);
            if (!(fsTemp.CanRead))
            {
                throw new Exception("Cannot Read File." + "<BR>" + fileName);
            }
            fsTemp.Close();
        }
        private void Check_CanWriteFile (string fileName)
        {
            FileAttributes faTemp = File.GetAttributes(fileName);
            FileStream fsTemp = new FileStream(fileName,FileMode.Open,FileAccess.Write);
            if (!(fsTemp.CanWrite))
            {
                throw new Exception("Cannot Write File." + "<BR>" + fileName);
            }
            fsTemp.Close();
        }
        private void Check_ReadWriteFile (string fileName)
        {
            FileStream fsTemp = new FileStream(fileName,FileMode.Open,FileAccess.ReadWrite);
            if (!(fsTemp.CanRead))
            {
                throw new Exception("Cannot Read File." + "<BR>" + fileName);
            }
            if (!(fsTemp.CanWrite))
            {
                throw new Exception("Cannot Write File." + "<BR>" + fileName);
            }
            fsTemp.Close();
        }

        private void Check_ReadWriteFileToDirectory(string directoryName)
        {
            // Create a new file
            FileStream fNew = File.Create(directoryName + "\\VerifyInstallation.txt");
            // Close the file
            fNew.Close();
            fNew = null;

            FileStream fExisting = File.Open(directoryName + "\\VerifyInstallation.txt",FileMode.Open,FileAccess.ReadWrite);
            if (!(fExisting.CanRead))
            {
                throw new Exception("Cannot Read File after Creating File in Directory." + "<BR>" + directoryName);
            }
            if (!(fExisting.CanWrite))
            {
                throw new Exception("Cannot Write File after Creating File in Directory." + "<BR>" + directoryName);
            }
            fExisting.Close();
            fExisting = null;

            File.Delete(directoryName + "VerifyInstallation.txt");
        }
		#region Web Form Designer generated code
        /// <summary>
        /// Web Form Designer generated code
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
	}
}
