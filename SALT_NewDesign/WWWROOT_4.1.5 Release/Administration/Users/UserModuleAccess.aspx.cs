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
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.Users
{
	/// <summary>
	/// Summary description for UserModuleAccess.
	/// </summary>
	public partial class UserModuleAccess : System.Web.UI.Page
	{

        /// <summary>
        /// Label for page title
        /// </summary>
		protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Label for messages and errors
        /// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// Label for name
        /// </summary>
		protected System.Web.UI.WebControls.Label lblName;

        /// <summary>
        /// Combo box for course selection
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboCourse;

        /// <summary>
        /// Datagrid of modules
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid grdModules;

        /// <summary>
        /// Button to save settings
        /// </summary>
		protected System.Web.UI.WebControls.Button btnSave;
	
        /// <summary>
        /// Users user id from querystring
        /// </summary>
		protected int m_intUserID;

        /// <summary>
        /// Counter for alternating row in module list
        /// </summary>
        protected int rowModuleList;




		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			this.m_intUserID = int.Parse(Request.QueryString["UserID"]);

			WebSecurity.CheckUserAdministrator(this.m_intUserID);

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

			BusinessServices.User objUser;
			DataTable dtbUser;
			string strName;
			int intOrganisationID;

			objUser = new BusinessServices.User();
            dtbUser = objUser.GetUser(this.m_intUserID);

			strName = dtbUser.Rows[0]["FirstName"].ToString() + " " + dtbUser.Rows[0]["LastName"].ToString();
			intOrganisationID = (int)dtbUser.Rows[0]["OrganisationID"];

			this.lblName.Text = strName;

			
			//1. Load Course list that are assigned to this User
			this.GetCourseList(intOrganisationID);
			
			if (this.cboCourse.Items.Count>0)
			{
				//2. Lists all modules in the selected course
				this.GetModuleAccess();
			}
			else
			{
				this.cboCourse.Visible = false;
				this.btnSave.Visible = false;
	
				this.lblMessage.Text = ResourceManager.GetString("lblMessage.NoCourse");
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
			BusinessServices.User  objUser = new BusinessServices.User();
			int intCourseID = int.Parse(this.cboCourse.SelectedValue);
			DataTable dtbModules = objUser.GetModuleAccess(this.m_intUserID,intCourseID);

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
			this.GetModuleAccess();
		}
		/// <summary>
		/// Save User module access settings
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			string strGrantedModuleIDs;
			strGrantedModuleIDs = Request.Form["chkGrantedModule"];
			int intCourseID = int.Parse(this.cboCourse.SelectedValue);

			BusinessServices.User  objUser = new BusinessServices.User();
			objUser.SaveModuleAccess(this.m_intUserID, intCourseID,	strGrantedModuleIDs);

			this.GetModuleAccess();

			this.lblMessage.Text = ResourceManager.GetString("lblMessage.Saved");
            this.lblMessage.CssClass = "SuccessMessage";

		}
	}
}
