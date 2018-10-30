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

namespace Bdw.Application.Salt.Web.Administration.Application
{
    /// <summary>
    /// Application Email Default mimics the way Organisation Configuration works where the emails can be edited
    /// However this feature is for the site settings and can only be accessed by the Application Administrator
    /// </summary>
    public partial class EmailDefault : System.Web.UI.Page
    {
        protected System.Web.UI.WebControls.DataGrid dgrConfig;
        private System.Data.DataTable dtbConfig;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            ResourceManager.RegisterLocaleResource("ConfirmMessage.SaveValue");
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
                dtbConfig = objOrgConfig.GetList(0);
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
            dgrConfig.Columns[0].HeaderText = ResourceManager.GetString("cmnName");
            dgrConfig.Columns[1].HeaderText = ResourceManager.GetString("grid_Description");
            dgrConfig.Columns[2].HeaderText = ResourceManager.GetString("grid_Value");
        }

        private void Edit(DataGridCommandEventArgs e)
        {
            // Select the right row
            dgrConfig.EditItemIndex = (int)e.Item.ItemIndex;

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
            objOrgConfig.Update(0, strName, strDescription, strValue);

            // Done
            Response.Redirect("EmailDefault.aspx");
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

        private void dgrConfig_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.EditItem)
            {
                LinkButton lnkSaveButton = (LinkButton)e.Item.Cells[3].Controls[0];
                LinkButton lnkCancelButton = (LinkButton)e.Item.Cells[3].Controls[2];

                if (lnkCancelButton != null)
                    lnkCancelButton.Text = ResourceManager.GetString("cmnCancel");

                if (lnkSaveButton != null)
                {
                    lnkSaveButton.Text = ResourceManager.GetString("cmnSave");
                    lnkSaveButton.OnClientClick = "javascript:return SaveConfirm();";
                }
            }

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lnkCustomiseButton = (LinkButton)e.Item.Cells[3].Controls[0];

                if (lnkCustomiseButton != null)
                    lnkCustomiseButton.Text = ResourceManager.GetString("grid_lnkCustomiseButton");
            }
        }
    }
}
