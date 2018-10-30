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
using System.Xml;

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Localization;
namespace Bdw.Application.Salt.Web.Administration.Unit
{
	/// <summary>
	/// Summary description for UnitModuleAccess.
	/// </summary>
	public partial class UnitModuleAccess : System.Web.UI.Page
	{
        /// <summary>
        /// Label for showing unit name
        /// </summary>
		protected System.Web.UI.WebControls.Label lblUnitName;

        /// <summary>
        /// Drop down list to select course
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboCourse;

        /// <summary>
        /// Datagrid of results
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid grdModules;

        /// <summary>
        /// Label for messages such as warnings etc
        /// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// Label for organisation name
        /// </summary>
		protected System.Web.UI.WebControls.Label lblOrganisation;

        /// <summary>
        /// Counter for alternating row in module list
        /// </summary>
        protected int rowModuleList;
	
        /// <summary>
        /// Unit ID from querystring
        /// </summary>
		protected int m_intUnitID;

		protected void Page_Load(object sender, System.EventArgs e)
		{
			ResourceManager.RegisterLocaleResource("ConfirmMessage");
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			this.m_intUnitID = int.Parse(Request.QueryString["UnitID"]);

			WebSecurity.CheckUnitAdministrator(this.m_intUnitID);

			if (!Page.IsPostBack)
			{
				LoadData();
			}
		}
		/// <summary>
		/// Load data the page is first loaded
		/// </summary>
		private void LoadData()
		{
			BusinessServices.Unit objUnit;
			DataTable dtbUnit;
			int intOrganisationID;

			objUnit = new BusinessServices.Unit();
			dtbUnit = objUnit.GetUnit(this.m_intUnitID);

			this.lblUnitName.Text = dtbUnit.Rows[0]["Pathway"].ToString();

			litMessage2.Text = String.Format(ResourceManager.GetString("litMessage"), dtbUnit.Rows[0]["Organisation"].ToString(), "<a href=\"UnitDetails.aspx?UnitID=" + m_intUnitID + "\">" + ResourceManager.GetString("lnkUnitDetails") + "</a>");

			intOrganisationID =(int) dtbUnit.Rows[0]["OrganisationID"];

			//1.Load Course list that are assigned to this organisation
			this.GetCourseList(intOrganisationID);
			
			if (this.cboCourse.Items.Count>0)
			{
				//2. Lists all modules in the selected course
				this.GetModuleAccess();
			
				//Show warning message
				this.btnSave.Attributes.Add("onclick","javascript:return SaveConfirm();");
			}
			else
			{
				this.cboCourse.Visible = false;
				this.grdModules.Visible = false;
				this.btnSave.Visible = false;
	
				this.lblMessage.Text = ResourceManager.GetString("lblMessage.NoCourseAccess");//"There is no course access";
                this.lblMessage.CssClass = "FeedbackMessage";
			}
		}
		/// <summary>
		/// Load Course list that are assigned to this organisation
		/// </summary>
		/// <param name="organisationID"></param>
		private void GetCourseList(int organisationID)
		{
			Course  objCourse = new Course();
			DataTable dtbCourses = objCourse.GetCourseListAccessableToOrg(organisationID);

			if (dtbCourses.Rows.Count>0)
			{
				cboCourse.DataSource =  dtbCourses;
				cboCourse.DataTextField = "Name";
				cboCourse.DataValueField = "CourseID";
				cboCourse.DataBind();
			}
		}
											  
		/// <summary>
		/// Lists all modules in the selected course 
		/// </summary>
		private void GetModuleAccess()
		{
			BusinessServices.Unit  objUnit = new BusinessServices.Unit();
			int intCourseID = int.Parse(this.cboCourse.SelectedValue);
			DataTable dtbModules = objUnit.GetModuleAccess(this.m_intUnitID,intCourseID);

			//this.grdModules.DataSource = dtbModules;
			//this.grdModules.DataBind();

            this.rptModuleList.DataSource = dtbModules;
            this.rptModuleList.DataBind();
		}

		/// <summary>
		/// Convert granted bit value to string
		/// </summary>
		/// <param name="granted"></param>
		/// <returns></returns>
		protected string GetGrantStatus(object granted)
		{
			if ((int)granted==1)
			{
				return "checked";
			}
			else
			{
				return "";
			}
		}
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
			//grdModules.Columns[0].HeaderText = ResourceManager.GetString("grid_ModuleName");
			//grdModules.Columns[1].HeaderText = ResourceManager.GetString("grid_GrantAccess");

		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
		}
		#endregion

		/// <summary>
		/// Change course
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void cboCourse_SelectedIndexChanged(object sender, System.EventArgs e)
		{
            this.lblMessage.Text = "";
			this.GetModuleAccess();
		}
		/// <summary>
		/// Save Unit module access settings
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			string strGrantedModuleIDs;
			strGrantedModuleIDs = Request.Form["chkGrantedModule"];
			int intCourseID = int.Parse(this.cboCourse.SelectedValue);

			BusinessServices.Unit  objUnit = new BusinessServices.Unit();
			objUnit.SaveModuleAccess(this.m_intUnitID, intCourseID,	strGrantedModuleIDs, chbIsInherit.Checked);

			this.GetModuleAccess();

			this.lblMessage.Text = ResourceManager.GetString("lblMessage.Saved");//"Unit Module Access has been saved successfully.";
            this.lblMessage.CssClass = "SuccessMessage";
		}
	}
}
