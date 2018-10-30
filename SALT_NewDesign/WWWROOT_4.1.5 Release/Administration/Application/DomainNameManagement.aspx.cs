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

namespace Bdw.Application.Salt.Web.Administration.Application
{
	/// <summary>
	/// Summary description for DomainNameManagement.
	/// </summary>
	public partial class DomainNameManagement : System.Web.UI.Page
	{
	
		protected void Page_Load(object sender, System.EventArgs e)
		{
			if (!Page.IsPostBack)
			{
				this.BindGrid();
			}
		}
		/// <summary>
		/// Get Organisation List
		/// </summary>
		private void BindGrid()
		{
			DataTable dt;
			
			BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
			dt = objOrganisation.GetOrganisationList();

			this.grdDataList.DataKeyField = "OrganisationID";
			this.grdDataList.DataSource = dt;
			this.grdDataList.DataBind();
		}


		#region Web Form Designer generated code
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
			this.grdDataList.CancelCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdDataList_CancelCommand);
			this.grdDataList.EditCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdDataList_EditCommand);
			this.grdDataList.UpdateCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdDataList_UpdateCommand);

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
			int intOrganisationID;
			string strDomainName;
			BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();

			intOrganisationID  = (int)this.grdDataList.DataKeys[e.Item.ItemIndex];
			strDomainName = ((TextBox)e.Item.FindControl("txtDomainName")).Text;
            
			try 
			{
					//Update value	
					objOrganisation.UpdateDomainName(intOrganisationID,strDomainName);

					this.grdDataList.EditItemIndex = -1;
					this.BindGrid();
			}
			catch(BusinessServiceException ex)
			{
				this.lblMessage.Text = ex.Message;
				this.lblMessage.CssClass = "WarningMessage";
			}
		}
	}
}
