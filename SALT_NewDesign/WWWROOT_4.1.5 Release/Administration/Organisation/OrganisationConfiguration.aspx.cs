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

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Web.Utilities;
using Localization;
using Uws.Framework.WebControl;
using Bdw.Application.Salt.Web.General.UserControls;
using tinyMCE;
using System.IO;

namespace Bdw.Application.Salt.Web.Administration.Organisation
{
	/// <summary>
	/// Summary description for Organisation Configuration.
	/// </summary>
	public partial class OrganisationConfiguration : System.Web.UI.Page
	{
        /// <summary>
        /// Data grid of configuration names and values
        /// </summary>
        protected System.Web.UI.WebControls.DataGrid dgrConfig;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;
        private System.Data.DataTable dtbConfig;

		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            GetData();

            if (!IsPostBack)
            {
                BindGrid();
            }
			
		}
       
        private void GetData()
        {
            if (dtbConfig == null)
            {
                OrganisationConfig objOrgConfig = new OrganisationConfig();
                dtbConfig = objOrgConfig.GetList(UserContext.UserData.OrgID);
            }
        }
        private void BindGrid()
        {
            dgrConfig.DataSource = dtbConfig;
            dgrConfig.DataBind();
        }

		#region Web Form Designer generated code
        /// <summary>
        /// Auto generated code
        /// </summary>
        /// <param name="e"></param>
		override protected void OnInit(EventArgs e)
		{
			InitializeComponent();
			base.OnInit(e);
			dgrConfig.Columns[0].HeaderText = ResourceManager.GetString("grid_UserDefault");
			dgrConfig.Columns[2].HeaderText = ResourceManager.GetString("cmnName" );
			dgrConfig.Columns[3].HeaderText = ResourceManager.GetString("grid_Description");
			dgrConfig.Columns[4].HeaderText = ResourceManager.GetString("grid_Value");
		}
        
        private void Edit(DataGridCommandEventArgs e)
        {
            
            // Select the right row
            dgrConfig.EditItemIndex = (int)e.Item.ItemIndex;

            // If its being edited then its no longer a default value.
            dtbConfig.Rows[(int)e.Item.ItemIndex]["Default"]=false;
            BindGrid();

            string strName = dtbConfig.Rows[e.Item.ItemIndex]["Name"].ToString();

            TextEditor richtext = (TextEditor)dgrConfig.Items[(int)e.Item.ItemIndex].FindControl("txtValue_Edit");
            TextBox multiline = (TextBox)dgrConfig.Items[(int)e.Item.ItemIndex].FindControl("txtValue_Edit2");
            
            bool noRichText = ((strName == "Number_Of_Quiz_Questions") || (strName == "css") || (strName == "ShowDetailedHelp") ||
                                (strName == "Student_Summary_Subject") || (strName == "Overdue_Summary_Subject"));

            if (noRichText)
            {
                richtext.Visible = false;
                multiline.Visible = true;
            }
            else
            {
                richtext.Visible = true;
                multiline.Visible = false;
            }
            
        }
        private void Update(DataGridCommandEventArgs e)
        {
            // Gather Values
           
                int intOrganisationID = UserContext.UserData.OrgID;
                string strName = dtbConfig.Rows[e.Item.ItemIndex]["Name"].ToString();
                string strDescription = dtbConfig.Rows[e.Item.ItemIndex]["Description"].ToString();

                bool noRichText = ((strName == "Number_Of_Quiz_Questions") || (strName == "css") || (strName == "ShowDetailedHelp") ||
                                    (strName == "Student_Summary_Subject") || (strName == "Overdue_Summary_Subject"));

                string strValue = null;
                if (noRichText)
                    strValue = ((TextBox)dgrConfig.Items[(int)e.Item.ItemIndex].FindControl("txtValue_Edit2")).Text;
                else
                    strValue = ((TextEditor)dgrConfig.Items[(int)e.Item.ItemIndex].FindControl("txtValue_Edit")).Text;

                // Perform business update
                OrganisationConfig objOrgConfig = new OrganisationConfig();
                objOrgConfig.Delete(intOrganisationID, strName);

                objOrgConfig.Update(intOrganisationID, strName, strDescription, strValue);

                // Done
                Response.Redirect("OrganisationConfiguration.aspx");
            
        }

        private void Delete(DataGridCommandEventArgs e)
        {
            // Gather Values
            int intOrganisationID = UserContext.UserData.OrgID;
            string strName = dtbConfig.Rows[e.Item.ItemIndex]["Name"].ToString();
           
            // Perform business update
            OrganisationConfig objOrgConfig = new OrganisationConfig();
            objOrgConfig.Delete(intOrganisationID,strName);

            // Done
            Response.Redirect("OrganisationConfiguration.aspx");
        
        }
        private void Cancel()
        {
            dgrConfig.EditItemIndex = -1;
            BindGrid();
        }

        private void dgrConfig_ItemCommand(object source, DataGridCommandEventArgs e)
        {
             
            switch (e.CommandName.ToLower())
            {
                case "edit":
                {
                    Edit(e);
                    break;
                }
                case "update":
                {
                    Update(e);         
                    break;
                }
                case "delete":
                {
                    Delete(e);         
                    break;
                }
                case "cancel":
                {
                    Cancel();
                    break;
                }
            } //switch
           
        }
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {    
            this.dgrConfig.ItemCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.dgrConfig_ItemCommand);
            this.dgrConfig.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrConfig_ItemDataBound);
            SmartNav smartNav = new SmartNav();

            this.Controls.Add(smartNav);

        }
        #endregion

        private const int m_intColumnDefaultCheckbox=0;
        private const int m_intColumnDefault=1;
        private const int m_intColumnName=2;
        private const int m_intColumnDescription=3;
        private const int m_intColumnValue=4;
        private const int m_intColumnEdit=5;
        private const int m_intColumnDelete=6;

        private void dgrConfig_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
			if (e.Item.ItemType == ListItemType.EditItem)
			{
				LinkButton lnkSaveButton = (LinkButton)e.Item.Cells[5].Controls[0];
				LinkButton lnkCancelButton = (LinkButton)e.Item.Cells[5].Controls[2];

				LinkButton lnkDeleteButton = (LinkButton)e.Item.Cells[6].Controls[0];
				
				if (lnkDeleteButton != null)
					lnkDeleteButton.Text = ResourceManager.GetString("grid_lnkDeleteButton");

				if (lnkCancelButton != null)
					lnkCancelButton.Text = ResourceManager.GetString("cmnCancel");

				if (lnkSaveButton != null)
					lnkSaveButton.Text = ResourceManager.GetString("cmnSave" );
			}

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
				LinkButton lnkCustomiseButton = (LinkButton)e.Item.Cells[5].Controls[0];

				if (lnkCustomiseButton != null)
					lnkCustomiseButton.Text = ResourceManager.GetString("grid_lnkCustomiseButton");

				LinkButton lnkRevertButton = (LinkButton)e.Item.Cells[6].Controls[0];

				if (lnkRevertButton != null)
					lnkRevertButton.Text = ResourceManager.GetString("grid_lnkRevert");

				

                // If its a default value
                if (Convert.ToBoolean(dtbConfig.Rows[e.Item.ItemIndex][0]))
                {
                    // Cant delete default values
                    e.Item.Cells[m_intColumnDelete].Controls.Clear();
                }
                // Its a custom value
                else
                {
                    // Cant Edit Custom Values
                    // Allow to edit
                    //e.Item.Cells[m_intColumnEdit].Controls.Clear();
                }
            }
            if (e.Item.ItemType == ListItemType.EditItem)
            {
                // Cant delete default while editing
                e.Item.Cells[m_intColumnDelete].Controls.Clear();
            }
            
        }
    }
}
