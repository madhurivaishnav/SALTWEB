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
using System.IO;

using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Localization;
namespace Bdw.Application.Salt.Web.Administration.Application
{
	/// <summary>
	/// Summary description for ApplicationConfiguration.
	/// </summary>
	public partial class ApplicationConfiguration : System.Web.UI.Page
	{
        /// <summary>
        /// Datagrid for results
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid grdDataList;

        /// <summary>
        /// Page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Label for messages and errors etc.
        /// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;
		

        /// <summary>
        /// Page Load event
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">System.EventArgs</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{

			if (!Page.IsPostBack)
			{
				this.BindGrid();
			}
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
		}
		/// <summary>
		/// Get application settings
		/// </summary>
		private void BindGrid()
		{
			DataTable dt;
			
			AppConfig objAppConfig = new AppConfig();
			dt = objAppConfig.GetList();

			this.grdDataList.DataKeyField = "Name";
			this.grdDataList.DataSource = dt;
			this.grdDataList.DataBind();
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

			grdDataList.Columns[0].HeaderText = ResourceManager.GetString("cmnName" );
			grdDataList.Columns[1].HeaderText = ResourceManager.GetString("grid_Value");
			grdDataList.Columns[2].HeaderText = ResourceManager.GetString("grid_Action");
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
            this.grdDataList.CancelCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdDataList_CancelCommand);
            this.grdDataList.EditCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdDataList_EditCommand);
            this.grdDataList.UpdateCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdDataList_UpdateCommand);
			this.grdDataList.ItemDataBound+=new DataGridItemEventHandler(grdDataList_ItemDataBound);

        }
		#endregion

        /// <summary>
        /// Cancel has been clicked on
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
		private void grdDataList_CancelCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			this.grdDataList.EditItemIndex = -1;
			this.BindGrid();
		}

        /// <summary>
        /// Edit command has been issued
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
		private void grdDataList_EditCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			this.grdDataList.EditItemIndex = (int)e.Item.ItemIndex;
			this.BindGrid();
		}

        /// <summary>
        /// Update command has been issued
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
		private void grdDataList_UpdateCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			string strName, strValue;
			AppConfig objAppConfig = new AppConfig();


			strName  = (string)this.grdDataList.DataKeys[e.Item.ItemIndex];
			strValue = ((TextBox)e.Item.FindControl("txtValue")).Text;
            
			try 
			{
                if (ValidateNameValue(strName,strValue))
                {
                    //Update value	
                    objAppConfig.Update(strName,strValue);
                    //Change the application setting
                    ApplicationSettings.SetSetting(strName,strValue);

                    this.grdDataList.EditItemIndex = -1;
                    this.BindGrid();
                }
				
			}
			catch(BusinessServiceException ex)
			{
				this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
			}
		}
        /// <summary>
        /// Validates new new settings
        /// </summary>
        /// <param name="keyName">Name of the key to validate</param>
        /// <param name="keyValue">Value of the key to validate</param>
        /// <returns></returns>
        private bool ValidateNameValue(string keyName, string keyValue)
        {
            bool result = true;
            // the style sheet must exist
            if (keyName=="StyleSheet") 
            {
                if (File.Exists(Server.MapPath ("/general/css/" + keyValue)) == false)
                {
                    this.lblMessage.Text = ResourceManager.GetString("lblMessage.StyleSheet");
                    this.lblMessage.CssClass = "WarningMessage";  
                    result = false;
                }
            }
            // these field must contain positive integers
            if (        keyName=="PageSize" 
                    ||  keyName=="NumerOfQuestionsToAskInQuiz" 
                    ||  keyName=="ToolbookDelay"
                    ||  keyName=="CopyrightYear"
                )
            {
                try
                {
                    int intPageSize = Int32.Parse(keyValue);
                    if (intPageSize<=0)
                    {
                        throw new System.FormatException("Value must be positive");
                    }
                }
                catch (System.FormatException ex)
                {
                    this.lblMessage.Text = ResourceManager.GetString("lblMessage.Error") +  "<BR>" + ex.Message;
                    this.lblMessage.CssClass = "WarningMessage";  
                    result = false;
                }
                
               
            }
            return(result);
		}

		private void grdDataList_ItemDataBound(object sender, DataGridItemEventArgs e)
		{
			if(e.Item.ItemType == ListItemType.EditItem)
			{
				LinkButton lnkUpdateButton = (LinkButton)e.Item.Cells[2].Controls[0];
				if (lnkUpdateButton != null)
					lnkUpdateButton.Text = ResourceManager.GetString("grid_Update");

				LinkButton lnkCancelButton = (LinkButton)e.Item.Cells[2].Controls[2];
				if (lnkCancelButton != null)
					lnkCancelButton.Text = ResourceManager.GetString("cmnCancel");

			}

			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem)
			{
                LinkButton lnkModifyButton = (LinkButton)e.Item.Cells[2].Controls[0];

                DataRowView di =(DataRowView) e.Item.DataItem;
                if (di.Row.ItemArray[0].ToString() != "MailService_QueueMail" &&  di.Row.ItemArray[0].ToString() != "MailService_QueueReports" && di.Row.ItemArray[0].ToString() != "MailService_SendMail")
                {                    
                    if (lnkModifyButton != null)
                        lnkModifyButton.Text = ResourceManager.GetString("grid_Modify");
                }
                else
                {
                    if (lnkModifyButton != null)
                        lnkModifyButton.Text = ""; 
                }
			}
		}
	}
}
