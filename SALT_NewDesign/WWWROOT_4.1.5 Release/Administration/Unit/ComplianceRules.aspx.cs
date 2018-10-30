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
	/// Summary description for ComplianceRules.
	/// </summary>
	public partial class ComplianceRules : System.Web.UI.Page
	{
		/// <summary>
		/// Label for messages to user ie errors warnings
		/// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;

		/// <summary>
		/// Label for unit name
		/// </summary>
		protected System.Web.UI.WebControls.Label lblUnitName;

		/// <summary>
		/// Drop down list of courses
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList cboCourse;

		/// <summary>
		/// Drop down list of Lesson Frequencies
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList cboLessonFrequency;

		/// <summary>
		/// Drop down list of quiz Frequencies
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList cboQuizFrequency;

		/// <summary>
		/// Textbox for the quiz pass mark
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtQuizPassMark;

		/// <summary>
		/// Button to populate all modules
		/// </summary>
		protected System.Web.UI.WebControls.Button btnPopulateAll;

		/// <summary>
		/// Datagrid of modules
		/// </summary>
		protected System.Web.UI.WebControls.DataGrid grdModules;

		/// <summary>
		/// Label for page title
		/// </summary>
		protected System.Web.UI.WebControls.Label lblPageTitle;

		/// <summary>
		/// The unit id that is gathered from the querystring
		/// </summary>
		protected int m_intUnitID;
       
		/// <summary>
		/// Constant string indicating the passmark validation message
		/// </summary>
		private string c_strPassMarkValidation=ResourceManager.GetString("PassMarkError");//"Pass Mark must be integer, and between 1 to 100"; 

		/// <summary>
		/// Event handler for the Page Load event
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			// Get the unit id from the querystring
			this.m_intUnitID = int.Parse(Request.QueryString["UnitID"]);
			ResourceManager.RegisterLocaleResource("ConfirmMessage");

			// Verify the users permissions
			WebSecurity.CheckUnitAdministrator(this.m_intUnitID);

			if (!Page.IsPostBack)
			{
				Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(cboLCompletionDay, cboLCompletionMonth, cboLCompletionYear, System.DateTime.Today.Year, 5);
				Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(cboQCompletionDay, cboQCompletionMonth, cboQCompletionYear, System.DateTime.Today.Year, 5);
				LoadData();
			}
		}		

		/// <summary>
		/// Load data the page is first loaded
		/// </summary>
		private void LoadData()
		{
			
			BusinessServices.Unit objUnit;	// Used to gather the unit details
			DataTable dtbUnit;				// Holds the unit details
			int intOrganisationID;			// the organisation id of the unit

			objUnit = new BusinessServices.Unit();
			
			// Get unit details
			dtbUnit = objUnit.GetUnit(this.m_intUnitID);

			this.lblUnitName.Text = dtbUnit.Rows[0]["Pathway"].ToString();

			intOrganisationID =(int) dtbUnit.Rows[0]["OrganisationID"];
			
			// Emerging bug 7, 8
			DataTable dtLoadOrg;

			string strLangCode = Request.Cookies["currentCulture"].Value;

			Bdw.Application.Salt.BusinessServices.Organisation objOrganisation = new Bdw.Application.Salt.BusinessServices.Organisation();
			dtLoadOrg = objOrganisation.GetOrganisation(strLangCode, intOrganisationID);
			this.cboLessonFrequency.SelectedValue = dtLoadOrg.Rows[0]["DefaultLessonFrequency"].ToString();
			this.cboQuizFrequency.SelectedValue = dtLoadOrg.Rows[0]["DefaultQuizFrequency"].ToString();
			this.txtQuizPassMark.Text = dtLoadOrg.Rows[0]["DefaultQuizPassMark"].ToString();

			// Setup date dropdowns with value
			if (dtLoadOrg.Rows[0]["DefaultLessonCompletionDate"] != System.DBNull.Value)
			{
				DateTime defaultLessonCompletionDate = (DateTime)dtLoadOrg.Rows[0]["DefaultLessonCompletionDate"];
				cboLCompletionDay.SelectedValue = defaultLessonCompletionDate.Day.ToString();
				cboLCompletionMonth.SelectedValue = defaultLessonCompletionDate.Month.ToString();
				cboLCompletionYear.SelectedValue = defaultLessonCompletionDate.Year.ToString();
			}

			if (dtLoadOrg.Rows[0]["DefaultQuizCompletionDate"] != System.DBNull.Value)
			{
				DateTime defaultQuizCompletionDate = (DateTime)dtLoadOrg.Rows[0]["DefaultQuizCompletionDate"];
				cboQCompletionDay.SelectedValue = defaultQuizCompletionDate.Day.ToString();
				cboQCompletionMonth.SelectedValue = defaultQuizCompletionDate.Month.ToString();
				cboQCompletionYear.SelectedValue = defaultQuizCompletionDate.Year.ToString();
			}
			// emerging end

			//1.Load Course list that are assigned to this organisation
			this.GetCourseList(intOrganisationID);
			
			//2. Get Organisation Default Compliance Rules
			this.GetDefaultRules(intOrganisationID);

			if (this.cboCourse.Items.Count>0)
			{
				//3. Lists all modules in the selected course
				this.GetModuleRule();
			}
			else
			{
				this.cboCourse.Visible = false;
				this.grdModules.Visible = false;
				this.btnPopulateAll.Visible = false;

				this.lblMessage.Text = ResourceManager.GetString("lblMessage.NoCourseAccess");//"There is no course access.";
				this.lblMessage.CssClass = "FeedbackMessage";
			}

		}
		/// <summary>
		/// Load Course list that are assigned to this organisation
		/// </summary>
		/// <param name="organisationID"></param>
		private void GetCourseList(int organisationID)
		{
			// Course object used to get the course list
			Course  objCourse = new Course();
			DataTable dtbCourses = objCourse.GetCourseListAccessableToOrg(organisationID);

			// If rows returned
			if (dtbCourses.Rows.Count>0)
			{
				cboCourse.DataSource =  dtbCourses;
				cboCourse.DataTextField = "Name";
				cboCourse.DataValueField = "CourseID";
				cboCourse.DataBind();
			}
		}
		/// <summary>
		///  Get Organisation Default Compliance Rules
		/// </summary>
		/// <param name="organisationID"></param>
		private void GetDefaultRules(int organisationID)
		{
			// Organisation object used to get the organisation details
			BusinessServices.Organisation  objOrganisation;
			// Datatable containing the organisation details
			DataTable dtbOrganisation;
			int intDefaultLessonFrequency, intDefaultQuizFrequency, intDefaultQuizPassMark;
			string strLangCode = Request.Cookies["currentCulture"].Value;
			objOrganisation = new BusinessServices.Organisation();

			dtbOrganisation = objOrganisation.GetOrganisation(strLangCode, organisationID);
			
			// Gather details from the organisation details table
			intDefaultLessonFrequency =(int) dtbOrganisation.Rows[0]["DefaultLessonFrequency"];
			intDefaultQuizFrequency = (int) dtbOrganisation.Rows[0]["DefaultQuizFrequency"];
			intDefaultQuizPassMark = (int) dtbOrganisation.Rows[0]["DefaultQuizPassMark"];
				
			this.cboLessonFrequency.SelectedIndex = intDefaultLessonFrequency;
			this.cboQuizFrequency.SelectedIndex = intDefaultQuizFrequency;
			this.txtQuizPassMark.Text  = intDefaultQuizPassMark.ToString();

			//Show warning message
			this.btnPopulateAll.Attributes.Add("onclick","javascript:return PopulateAllConfirm();");
		}

		/// <summary>
		/// Lists all modules in the selected course 
		/// </summary>
		private DataTable GetModuleRule()
		{
			// Unit used to gather the module rules
			BusinessServices.Unit  objUnit = new BusinessServices.Unit();
			// Holds the selected course id
			int intCourseID = int.Parse(this.cboCourse.SelectedValue);
            DataTable dtbModules = objUnit.GetModuleRule(this.m_intUnitID, intCourseID);

			this.grdModules.DataSource = dtbModules;
			this.grdModules.DataKeyField = "ModuleID";
			this.grdModules.DataBind();

			return dtbModules;
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
			grdModules.Columns[0].HeaderText = ResourceManager.GetString("grid_ModuleName");
			grdModules.Columns[1].HeaderText = ResourceManager.GetString("grid_Default");
			grdModules.Columns[2].HeaderText = ResourceManager.GetString("grid_LessFreq");
			grdModules.Columns[3].HeaderText = ResourceManager.GetString("grid_QuizFreq");
			grdModules.Columns[4].HeaderText = ResourceManager.GetString("grid_LessDate");
			grdModules.Columns[5].HeaderText = ResourceManager.GetString("grid_QuizDate");
			grdModules.Columns[6].HeaderText = ResourceManager.GetString("grid_PassMark");
			grdModules.Columns[7].HeaderText = ResourceManager.GetString("grid_Action");
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.grdModules.CancelCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdModules_CancelCommand);
			this.grdModules.EditCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdModules_EditCommand);
			this.grdModules.UpdateCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdModules_UpdateCommand);
			grdModules.ItemDataBound+=new DataGridItemEventHandler(grdModules_ItemDataBound);

		}
		#endregion

		/// <summary>
		/// Event handler for the populate all button
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnPopulateAll_Click(object sender, System.EventArgs e)
		{
			// String that holds the error message
			string strErrorMessage="";
			
			// Integers holding the organisation properties
			int intCourseID;
			int intLessonFrequency, intQuizFrequency, intQuizPassMark;

			BusinessServices.Unit  objUnit = new BusinessServices.Unit();
			
			// Gather the selected values
			intCourseID = int.Parse(this.cboCourse.SelectedValue);
			intLessonFrequency = int.Parse(this.cboLessonFrequency.SelectedValue);
			intQuizFrequency  = int.Parse(this.cboQuizFrequency.SelectedValue);

			DateTime lessonCompletionDate = DateTime.Parse("1/1/1900");
			strErrorMessage = Bdw.Application.Salt.Web.General.Shared.Validation.Validate_Frequency_CompletionDates(ref lessonCompletionDate, cboLessonFrequency.SelectedValue, cboLCompletionDay.SelectedValue, cboLCompletionMonth.SelectedValue, cboLCompletionYear.SelectedValue);

			DateTime quizCompletionDate = DateTime.Parse("1/1/1900");
			strErrorMessage = Bdw.Application.Salt.Web.General.Shared.Validation.Validate_Frequency_CompletionDates(ref quizCompletionDate, cboQuizFrequency.SelectedValue, cboQCompletionDay.SelectedValue, cboQCompletionMonth.SelectedValue, cboQCompletionYear.SelectedValue);

			try
			{
				intQuizPassMark  = int.Parse(this.txtQuizPassMark.Text);
				if ((intQuizPassMark<1) || (intQuizPassMark>100))
				{
					strErrorMessage = c_strPassMarkValidation;
				}
			}
			catch
			{
				intQuizPassMark = 100;
				strErrorMessage = c_strPassMarkValidation;
			}
			
			if (strErrorMessage=="")
			{
				objUnit.SaveModuleRuleToAll(this.m_intUnitID,intCourseID,intLessonFrequency,intQuizFrequency,intQuizPassMark, lessonCompletionDate, quizCompletionDate, UserContext.UserID,UserContext.UserData.OrgID);

				this.GetModuleRule();

				this.lblMessage.Text = ResourceManager.GetString("lblMessage.Populated");//"The Compliance Rules have been populated to all the modules in the course.";
				this.lblMessage.CssClass = "SuccessMessage";
			}
			else
			{
				this.lblMessage.Text = strErrorMessage;
				this.lblMessage.CssClass = "WarningMessage";
			}
			// Reset the grid
			this.grdModules.EditItemIndex = -1;
		}


		/// <summary>
		/// Event handler for the course select box changing
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void cboCourse_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			grdModules.EditItemIndex = -1; // Emerging Bug Issue 2
			this.GetModuleRule();
		}

		/// <summary>
		/// Module edit command event handler
		/// </summary>
		/// <param name="source"></param>
		/// <param name="e"></param>
		private void grdModules_EditCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			// gather the selected index
			this.grdModules.EditItemIndex = (int)e.Item.ItemIndex;
			DataTable dtbModules = this.GetModuleRule();

			DropDownList cboLDay = (DropDownList)this.grdModules.Items[(int)e.Item.ItemIndex].FindControl("cboGridLCompletionDay");
			DropDownList cboLMonth = (DropDownList)this.grdModules.Items[(int)e.Item.ItemIndex].FindControl("cboGridLCompletionMonth");
			DropDownList cboLYear = (DropDownList)this.grdModules.Items[(int)e.Item.ItemIndex].FindControl("cboGridLCompletionYear");
			Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(cboLDay, cboLMonth, cboLYear, System.DateTime.Today.Year, 5);


			if (dtbModules.Rows[(int)e.Item.ItemIndex]["LessonCompletionDate"] != System.DBNull.Value)
			{
				DateTime dtmLesson = DateTime.Parse(dtbModules.Rows[(int)e.Item.ItemIndex]["LessonCompletionDate"].ToString());
				cboLDay.SelectedValue = dtmLesson.Day.ToString();
				cboLMonth.SelectedValue = dtmLesson.Month.ToString();
				cboLYear.SelectedValue = dtmLesson.Year.ToString();
			}

			DropDownList cboQDay = (DropDownList)this.grdModules.Items[(int)e.Item.ItemIndex].FindControl("cboGridQCompletionDay");
			DropDownList cboQMonth = (DropDownList)this.grdModules.Items[(int)e.Item.ItemIndex].FindControl("cboGridQCompletionMonth");
			DropDownList cboQYear = (DropDownList)this.grdModules.Items[(int)e.Item.ItemIndex].FindControl("cboGridQCompletionYear");
			Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(cboQDay, cboQMonth, cboQYear, System.DateTime.Today.Year, 5);
			if (dtbModules.Rows[(int)e.Item.ItemIndex]["QuizCompletionDate"] != System.DBNull.Value)
			{
				DateTime dtmQuiz = DateTime.Parse(dtbModules.Rows[(int)e.Item.ItemIndex]["QuizCompletionDate"].ToString());
				cboQDay.SelectedValue = dtmQuiz.Day.ToString();
				cboQMonth.SelectedValue = dtmQuiz.Month.ToString();
				cboQYear.SelectedValue = dtmQuiz.Year.ToString();
			}

			

            // See Bug-Tracker #162
            // If a user has selected modify then they must want other than the default value
            // This way setting it false is correct in both states.
            CheckBox chkModuleUsingDefault = (CheckBox) this.grdModules.Items[(int)e.Item.ItemIndex].FindControl("chkModuleUsingDefault");
            chkModuleUsingDefault.Checked=false;


		}

		/// <summary>
		/// Event handler for the cancel event on the datagrid
		/// </summary>
		/// <param name="source"></param>
		/// <param name="e"></param>
		private void grdModules_CancelCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			this.grdModules.EditItemIndex = -1;

			this.GetModuleRule();
		}


		/// <summary>
		/// Event handler of the update command on the datagrid
		/// </summary>
		/// <param name="source"></param>
		/// <param name="e"></param>
		private void grdModules_UpdateCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
		{
			string strErrorMessage="";
			int intModuleID;

			bool blnUsingDefault;
			int intLessonFrequency, intQuizFrequency, intQuizPassMark;
			BusinessServices.Unit  objUnit = new BusinessServices.Unit();
			
			intModuleID  = (int)this.grdModules.DataKeys[e.Item.ItemIndex];
			
			blnUsingDefault = ((CheckBox)e.Item.FindControl("chkModuleUsingDefault")).Checked;
			intLessonFrequency =int.Parse(((DropDownList)e.Item.FindControl("cboModuleLessonFrequency")).SelectedValue);
			intQuizFrequency =int.Parse(((DropDownList)e.Item.FindControl("cboModuleQuizFrequency")).SelectedValue);

			
			DropDownList cboLDay = (DropDownList)e.Item.FindControl("cboGridLCompletionDay");
			DropDownList cboLMonth = (DropDownList)e.Item.FindControl("cboGridLCompletionMonth");
			DropDownList cboLYear = (DropDownList)e.Item.FindControl("cboGridLCompletionYear");
			DateTime lessonCompletionDate = DateTime.Parse("1/1/1900");
			strErrorMessage += Bdw.Application.Salt.Web.General.Shared.Validation.Validate_Frequency_CompletionDates(ref lessonCompletionDate, intLessonFrequency.ToString(), cboLDay.SelectedValue, cboLMonth.SelectedValue, cboLYear.SelectedValue);

			
			DropDownList cboQDay = (DropDownList)e.Item.FindControl("cboGridQCompletionDay");
			DropDownList cboQMonth = (DropDownList)e.Item.FindControl("cboGridQCompletionMonth");
			DropDownList cboQYear = (DropDownList)e.Item.FindControl("cboGridQCompletionYear");
			DateTime quizCompletionDate = DateTime.Parse("1/1/1900");
			strErrorMessage += Bdw.Application.Salt.Web.General.Shared.Validation.Validate_Frequency_CompletionDates(ref quizCompletionDate, intQuizFrequency.ToString(), cboQDay.SelectedValue, cboQMonth.SelectedValue, cboQYear.SelectedValue);


			try
			{
				intQuizPassMark =int.Parse(((TextBox)e.Item.FindControl("txtModuleQuizPassMark")).Text);
				if ((intQuizPassMark<1) || (intQuizPassMark>100))
				{
					strErrorMessage +=c_strPassMarkValidation;
				}
			}
			catch
			{
				intQuizPassMark =100;
				strErrorMessage += c_strPassMarkValidation;
			}
			
			if (strErrorMessage=="")
			{
				try 
				{

					objUnit.SaveModuleRule(this.m_intUnitID,intModuleID, blnUsingDefault,intLessonFrequency,intQuizFrequency,intQuizPassMark, lessonCompletionDate, quizCompletionDate, UserContext.UserID, UserContext.UserData.OrgID);

					this.grdModules.EditItemIndex = -1;
					
					this.GetModuleRule();

					this.lblMessage.Text = ResourceManager.GetString("lblMessage.Updated");//"The Compliance Rules have been updated for the selected module.";
                    this.lblMessage.CssClass = "SuccessMessage";

				}
				catch(BusinessServiceException ex)
				{
					this.lblMessage.Text =  ex.Message;
                    this.lblMessage.CssClass = "WarningMessage";
				}		
			}
			else
			{
				this.lblMessage.Text = strErrorMessage;
                this.lblMessage.CssClass = "WarningMessage";
			}
		}

		private void grdModules_ItemDataBound(object sender, DataGridItemEventArgs e)
		{

			if(e.Item.ItemType == ListItemType.EditItem)
			{
				LinkButton lnkUpdateButton = (LinkButton)e.Item.Cells[7].Controls[0];
				if (lnkUpdateButton != null)
					lnkUpdateButton.Text = ResourceManager.GetString("grid_lnkUpdateButton");

				LinkButton lnkCancelButton = (LinkButton)e.Item.Cells[7].Controls[2];
				if (lnkCancelButton != null)
					lnkCancelButton.Text = ResourceManager.GetString("cmnCancel");
			}


			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				LinkButton lnkModifyButton = (LinkButton)e.Item.Cells[7].Controls[0];
				if (lnkModifyButton != null)
					lnkModifyButton.Text = ResourceManager.GetString("grid_lnkModifyButton");
				

				//-- Logic to hide the word months if lession frequency is 0 or empty.
				Label lblLessonFrequency = (Label)e.Item.Cells[2].Controls[1];
				LocalizedLiteral lblLessonMonths = (LocalizedLiteral)e.Item.Cells[2].Controls[3];
				if (lblLessonFrequency.Text == string.Empty || lblLessonFrequency.Text == "0")
				{
					lblLessonFrequency.Visible = false;
					lblLessonMonths.Visible = false;
				}

				//-- Logic to hide the word months if quiz frequency is 0 or empty.
				Label lblQuizFrequency = (Label)e.Item.Cells[3].Controls[1];
				LocalizedLiteral lblQuizMonths = (LocalizedLiteral)e.Item.Cells[3].Controls[3];
				if (lblQuizFrequency.Text == string.Empty || lblQuizFrequency.Text == "0")
				{
					lblQuizFrequency.Visible = false;
					lblQuizMonths.Visible = false;
				}
			}

		}
	}
}
