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
using System.Text.RegularExpressions;

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.DataGridTemplate;

using Localization;

namespace Bdw.Application.Salt.Web.Administration.CPD
{
	/// <summary>
	/// Summary description for cpddetail.
	/// </summary>
	public partial class cpddetail : System.Web.UI.Page
	{
		protected Localization.LocalizedCheckBox chkEnabled;
		protected System.Web.UI.WebControls.Panel panFuture;
		protected Localization.LocalizedLabel lblFuturePeriod;
		protected Localization.LocalizedButton btnSave;
		protected Localization.LocalizedLabel lblPolicyName;
		protected Localization.LocalizedLabel lblPoints;
		protected Localization.LocalizedButton lblUnitSaveAll;


		private static string DisplayType = String.Empty;
		private static bool PoliciesExist = false;
		private static bool CoursesExist = false;
		private static bool blnViewUsers = false;

		private static bool InitialiseSession = false;
		private static string ProfileNameCheck = String.Empty;

		protected void Page_Load(object sender, System.EventArgs e)
		{
			BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
			if (objOrganisation.GetOrganisationCPDAccess(UserContext.UserData.OrgID))
			{
				//Response.AddHeader("Refresh", Convert.ToString((Session.Timeout*60)-10));

				//To get treeview to work correctly when not rendered until link clicked on
				Page.RegisterHiddenField("StaticPostBackScrollVerticalPosition", "0");
				Page.RegisterHiddenField("StaticPostBackScrollHorizontalPosition", "0");

				pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			
				//Append profile name to Page Title
				int ProfileID;
				int ProfilePeriodID;
				try
				{
					ProfileID = int.Parse(Session["ProfileID"].ToString());
				}
				catch
				{
					ProfileID = -1;
				}
				try
				{
					ProfilePeriodID = int.Parse(Session["ProfilePeriodID"].ToString());
				}
				catch
				{
					ProfilePeriodID = -1;
				}

				this.InitialisePage(ProfileID, ProfilePeriodID);

				if(!Page.IsPostBack)
				{
					InitialiseSession = true;
					Session["PageIndex"] = 0;
					PopulateDropdown(this.ddlCurrentDateStartDay, this.ddlCurrentDateStartMonth, this.ddlCurrentDateStartYear);
					PopulateDropdown(this.ddlCurrentDateEndDay, this.ddlCurrentDateEndMonth, this.ddlCurrentDateEndYear);
					PopulateDropdown(this.ddlFutureDateStartDay, this.ddlFutureDateStartMonth, this.ddlFutureDateStartYear);
					PopulateDropdown(this.ddlFutureDateEndDay, this.ddlFutureDateEndMonth, this.ddlFutureDateEndYear);

					//By default "No Action" radiobutton checked if a new profile
					if(ProfileID > 0) //Existing Profile
					{
						LoadProfile(ProfileID, ProfilePeriodID);
					}
					else //New Profile
					{
						this.rbNoAction.Checked = true;
					}
				
					//Show Parent Units tree
					BusinessServices.Unit objUnit= new  BusinessServices.Unit();
					DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'A',false);
					if (dstUnits.Tables[0].Rows.Count!=0)
					{
						string strUnits = UnitTreeConvert.ConvertXml(dstUnits);

						this.trvUnitsSelector.LoadXml(strUnits);
						this.trvUserUnitsSelector.LoadXml(strUnits);

					}

					// Initially hide all assignment panels until user clicks on them
					this.panAssignPoints.Visible = false;
					this.panAssignUnits.Visible = false;
					this.panUnitSelect.Visible = false;
					this.panAssign.Visible = false;
					this.panUserUnitSelect.Visible = false;
					this.panAssignUsers.Visible = false;
					this.panUserDetails.Visible = false;
					this.panSearchReset.Visible = false;
					this.panUserSearchResults.Visible = false;
					this.panViewUsers.Visible = false;
					this.panUserList.Visible = false;
					this.panUnitSaveAll.Visible = false;
					this.panUserSaveAll.Visible = false;
					this.panUserSearchMessage.Visible = false;

					SetSortOrder("LastName");
				}

				if(this.panPeriod.Visible == true)
				{
					DisplayCourseModules();
					ShowHideAssignPointControls();
				}	
			}
			else// dosnt have access to CPD 
			{	
				pagTitle.InnerText = ResourceManager.GetString("pagTitle");
				this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle");
				panCPD.Visible = false;
				lblMessage.Text = ResourceManager.GetString("NoAccess");
				lblMessage.CssClass = "WarningMessage";
			}
		}
	
		private void InitialisePage(int ProfileID, int ProfilePeriodID)
		{
			if(ProfileID > 0) //Existing Profile
			{
				DataTable dtProfile = GetProfile(ProfileID,ProfilePeriodID );
				this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle") + " - " + dtProfile.Rows[0]["ProfileName"].ToString();

				//TODO Determine if Current period or Future Period
				//Current
				if(IsCurrentPeriod(dtProfile))
				{
					this.lblMultiPeriod.Text = ResourceManager.GetString("Current") + " " + ResourceManager.GetString("lblPeriod");
					this.btnDeleteFuturePeriod.Visible = false;
					this.btnNewProfilePeriod.Visible = false;
					this.btnSaveProfile.Visible = true;
					this.panTabs.Visible = true;
				}
				else if (IsFuturePeriod(dtProfile))	//Future
				{
					this.lblMultiPeriod.Text = ResourceManager.GetString("Future") + " " + ResourceManager.GetString("lblPeriod");
					this.btnDeleteFuturePeriod.Visible = true;
					this.btnNewProfilePeriod.Visible = false;
					this.btnSaveProfile.Visible = true;
					this.panTabs.Visible = true;
				}	
				else // Profile with no periods
				{	
					this.lblMultiPeriod.Text = ResourceManager.GetString("New") + " " + ResourceManager.GetString("lblPeriod");
					this.panPeriod.Visible = false;
					this.panTabs.Visible = false;
					this.btnDeleteFuturePeriod.Visible = false;
					this.btnSaveProfile.Visible = false;
					this.btnNewProfilePeriod.Visible = true;
					this.lblNoPeriod.Text = ResourceManager.GetString("NoPeriod");
					this.lblNoPeriod.CssClass = "FeedbackMessage";
				}
				this.btnCancel.Visible = false;
				
			}
			else //New Profile
			{
				this.lblPageTitle.Text = ResourceManager.GetString("Create") + " " + ResourceManager.GetString("New") + " " + ResourceManager.GetString("lblPageTitle");
				this.lblMultiPeriod.Text = ResourceManager.GetString("New") + " " + ResourceManager.GetString("lblPeriod");

				this.btnDeleteFuturePeriod.Visible = false;
				this.btnNewProfilePeriod.Visible = false;
				this.btnCancel.Visible = true;
				this.panTabs.Visible = false;
			}
			
			this.lblCurrentTo.Text = ResourceManager.GetString("lblTo");
			this.lblFutureTo.Text = ResourceManager.GetString("lblTo");
		}

		private void ShowHideAssignPointControls()
		{
			if(!CoursesExist && !PoliciesExist)
			{	
				//Hide relevant controls
				this.panAssignQuizLesson.Visible = false;
				this.panAssignPointsTo.Visible = false;
				this.panSaveAll.Visible = false;
			}
			else
			{
				this.panAssignQuizLesson.Visible = true;
				this.panAssignPointsTo.Visible = true;
				this.panSaveAll.Visible = true;
			}
		}

		private bool IsCurrentPeriod(DataTable dtPeriod)
		{
			bool PeriodCurrent = false;
			if(dtPeriod.Rows[0]["datestart"] != System.DBNull.Value)
			{
				DateTime dtDateStart = (DateTime)dtPeriod.Rows[0]["datestart"];
				if (dtDateStart < DateTime.Now)
				{
					PeriodCurrent = true;
				}
			}
			return PeriodCurrent;
		}

		private bool IsFuturePeriod(DataTable dtPeriod)
		{
			bool PeriodFuture = false;
			if(dtPeriod.Rows[0]["datestart"] != System.DBNull.Value)
			{
				DateTime dtDateStart = (DateTime)dtPeriod.Rows[0]["datestart"];
				if(dtDateStart > DateTime.Now)
				{
					PeriodFuture = true;
				}
			}
			return PeriodFuture;
		}

		private void LoadProfile(int ProfileID, int ProfilePeriodID)
		{
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
            DataTable dtProfile = objProfile.GetProfile(ProfileID, ProfilePeriodID, UserContext.UserData.OrgID);
			this.txtProfileName.Text = dtProfile.Rows[0]["ProfileName"].ToString();
			ProfileNameCheck = dtProfile.Rows[0]["ProfileName"].ToString();
			if(this.panPeriod.Visible == true)
			{
				if(!dtProfile.Rows[0]["datestart"].Equals(System.DBNull.Value))
				{
					DateTime dtStart = (DateTime)dtProfile.Rows[0]["datestart"];
					this.ddlCurrentDateStartDay.SelectedValue = dtStart.Day.ToString();
					this.ddlCurrentDateStartMonth.SelectedValue = dtStart.Month.ToString();
					this.ddlCurrentDateStartYear.SelectedValue = dtStart.Year.ToString();
				}
				if(!dtProfile.Rows[0]["dateend"].Equals(System.DBNull.Value))
				{
					DateTime dtStart = (DateTime)dtProfile.Rows[0]["dateend"];
					this.ddlCurrentDateEndDay.SelectedValue = dtStart.Day.ToString();
					this.ddlCurrentDateEndMonth.SelectedValue = dtStart.Month.ToString();
					this.ddlCurrentDateEndYear.SelectedValue = dtStart.Year.ToString();
				}
				if(!dtProfile.Rows[0]["Points"].Equals(System.DBNull.Value))
				{
					this.txtCurrentPoints.Text = dtProfile.Rows[0]["Points"].ToString();
				}
				if(!dtProfile.Rows[0]["ApplyToQuiz"].Equals(System.DBNull.Value))
				{
					this.cmnQuiz.Checked = bool.Parse(dtProfile.Rows[0]["ApplyToQuiz"].ToString());
				}
				if(!dtProfile.Rows[0]["ApplyToLesson"].Equals(System.DBNull.Value))
				{
					this.cmnLesson.Checked = bool.Parse(dtProfile.Rows[0]["ApplyToLesson"].ToString());
				}
				string strEndOfPeriodAction = dtProfile.Rows[0]["EndOfPeriodAction"].ToString();
				switch (strEndOfPeriodAction)
				{
					case "1":
						this.rbNoAction.Checked = true;
						resetMonth();
						resetFuturePeriod();
						break;
					case "2":
						this.rbAutoIncrementAsCurrent.Checked = true;
						resetMonth();
						resetFuturePeriod();
						break;
					case "3":
						this.rbAutoIncrementByMonth.Checked = true;
						resetFuturePeriod();
						if (!dtProfile.Rows[0]["MonthIncrement"].Equals(System.DBNull.Value))
						{
							this.txtMonth.Text = dtProfile.Rows[0]["MonthIncrement"].ToString();
						}
						break;
					case "4":
						this.rbNewFuturePeriod.Checked = true;
						resetMonth();
						if(!dtProfile.Rows[0]["futuredatestart"].Equals(System.DBNull.Value))
						{
							DateTime dtStart = (DateTime)dtProfile.Rows[0]["futuredatestart"];
							this.ddlFutureDateStartDay.SelectedValue = dtStart.Day.ToString();
							this.ddlFutureDateStartMonth.SelectedValue = dtStart.Month.ToString();
							this.ddlFutureDateStartYear.SelectedValue = dtStart.Year.ToString();
						}
						if(!dtProfile.Rows[0]["futuredateend"].Equals(System.DBNull.Value))
						{
							DateTime dtStart = (DateTime)dtProfile.Rows[0]["futuredateend"];
							this.ddlFutureDateEndDay.SelectedValue = dtStart.Day.ToString();
							this.ddlFutureDateEndMonth.SelectedValue = dtStart.Month.ToString();
							this.ddlFutureDateEndYear.SelectedValue = dtStart.Year.ToString();
						}
						if (!dtProfile.Rows[0]["FuturePoints"].Equals(System.DBNull.Value))
						{
							this.txtFuturePoints.Text = dtProfile.Rows[0]["FuturePoints"].ToString();
						}
						break;
				}
			}
		}

		private void resetMonth()
		{
			this.txtMonth.Text = String.Empty;
		}

		private void resetFuturePeriod()
		{
			this.txtFuturePoints.Text = String.Empty;
			this.ddlFutureDateEndDay.SelectedIndex = -1;
			this.ddlFutureDateEndMonth.SelectedIndex = -1;
			this.ddlFutureDateEndYear.SelectedIndex = -1;
			this.ddlFutureDateStartDay.SelectedIndex = -1;
			this.ddlFutureDateStartMonth.SelectedIndex = -1;
			this.ddlFutureDateStartYear.SelectedIndex = -1;
		}

		private void PopulateDropdown(DropDownList Day, DropDownList Month, DropDownList Year)
		{
			Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(Day, Month, Year, 2006, (System.DateTime.Today.Year - 2006) + 5);
		}

		private DataTable GetProfile(int ProfileID,int  ProfilePeriodID)
		{
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
            DataTable dtProfile = objProfile.GetProfile(ProfileID, ProfilePeriodID, UserContext.UserData.OrgID);
			return dtProfile;
		}


		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
			grdPolicyPoints.Columns[2].HeaderText = ResourceManager.GetString("policy_name");
			grdPolicyPoints.Columns[3].HeaderText = ResourceManager.GetString("lblPoints");
			grdResults.Columns[0].HeaderText = ResourceManager.GetString("unit_pathway");
			grdResults.Columns[1].HeaderText = ResourceManager.GetString("last_name");
			grdResults.Columns[2].HeaderText = ResourceManager.GetString("first_name");
			grdResults.Columns[3].HeaderText = ResourceManager.GetString("assign");
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{  
			this.grdPolicyPoints.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.grdPolicyPoints_ItemDataBound);
			this.grdResults.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.grdResults_PageIndexChanged);
			this.grdResults.SortCommand += new System.Web.UI.WebControls.DataGridSortCommandEventHandler(this.grdResults_SortCommand);

		}
		#endregion


		protected void lnkAssignPoints_Click(object sender, System.EventArgs e)
		{
			DisplayCourseModules();
			BindPolicyPointsGrid();
			ShowHideAssignPointControls();
			this.panAssignPoints.Visible = true;

			this.panAssignUnits.Visible = false;
			this.panUnitSelect.Visible = false;
			this.panAssign.Visible = false;

			this.panAssignUsers.Visible = false;
			this.panUserUnitSelect.Visible = false;
			this.panUserDetails.Visible = false;
			this.panUserSearchResults.Visible = false;
			this.panSearchReset.Visible = false;
			this.panUserSaveAll.Visible = false;
			this.panUserSearchMessage.Visible = false;

			this.panViewUsers.Visible = false;
			this.panUserList.Visible = false;
			this.panUnitSaveAll.Visible = false;
			this.lblPointsAssignMessage.Text = String.Empty;
		}

		private void BindPolicyPointsGrid()
		{
			int OrganisationID = UserContext.UserData.OrgID;
			int ProfileID;
			try
			{
				ProfileID = int.Parse(Session["ProfileID"].ToString());
			}
			catch
			{
				ProfileID = -1;
			}
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			int ProfilePeriodID;
			if (ProfileID == -1)
			{
				ProfilePeriodID = -1;
			}
			else
			{
				try
				{
					ProfilePeriodID = int.Parse(Session["ProfilePeriodID"].ToString());
				}
				catch
				{
					ProfilePeriodID = -1;
				}
			}
			DataTable dtPolicyPoints = objProfile.GetProfilePolicyPoints(OrganisationID, ProfilePeriodID);
			
			if(dtPolicyPoints.Rows.Count == 0) //No policies exist - hide relevant controls and display message
			{
				PoliciesExist = false;
				this.lblNoPolicy.Visible = true;
				this.lblNoPolicy.Text = ResourceManager.GetString("NoPolicies");
				this.lblNoPolicy.CssClass = "FeedbackMessage";
				this.panPolicyPoints.Visible = false;
				
			}
			else //Bind to grid and calculate total points
			{
				PoliciesExist = true;
				this.panPolicyPoints.Visible = true;
				this.lblNoPolicy.Visible = false;
				this.grdPolicyPoints.DataSource = dtPolicyPoints;
				this.grdPolicyPoints.DataBind();
				PopulateTotalPointsPolicy();
			}
		}

		private void PopulateTotalPointsPolicy()
		{
			double TotalPoints = 0;
			//Iterate through Policy grid and add up points
			int policyCount = this.grdPolicyPoints.Items.Count;
			for(int i=0; i < policyCount; i++)
			{
				TextBox txtPolicyPoints = (TextBox)this.grdPolicyPoints.Items[i].FindControl("txtPolicyPoints");
				double PolicyPoints = double.Parse(txtPolicyPoints.Text);
				TotalPoints += PolicyPoints;
			}

			this.lblPolicyPointsTotal.Font.Bold = true;
			this.lblPolicyPointsTotal.Text = TotalPoints.ToString() + " " + ResourceManager.GetString("lblPoints");
		}

		private void DisplayCourseModules()
		{
			this.phCourseModuleList.Controls.Clear();
			double TotalModulePoints = 0;
			int ProfileID;
			try
			{
				ProfileID = int.Parse(Session["ProfileID"].ToString());
			}
			catch
			{
				ProfileID = -1;
			}
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			int ProfilePeriodID;
			if (ProfileID == -1)
			{
				ProfilePeriodID = -1;
			}
			else
			{
				try
				{
					ProfilePeriodID = int.Parse(Session["ProfilePeriodID"].ToString());
				}
				catch
				{
					ProfilePeriodID = -1;
				}
			}

			//Get course list
			int OrganisationID = UserContext.UserData.OrgID;			
			BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
			DataTable dtCourses = objOrganisation.GetCourseAccessList(OrganisationID);
			//Filter by granted courses for this organisation
			DataRow[] drCourses = dtCourses.Select("Granted=1");
			int Coursecount = drCourses.Length;

			if(Coursecount == 0) //No courses exist for this organisation - display message
			{
				CoursesExist = false;
				this.lblNoCourse.Visible = true;
				this.lblNoCourse.Text = ResourceManager.GetString("NoCourses");
				this.lblModulePoints.Visible = false;
				this.lblModulePointsTotal.Visible = false;
				this.lblNoCourse.CssClass = "FeedbackMessage";
			}
			else // Add the grids for courses/modules
			{
				CoursesExist = true;
				this.lblNoCourse.Visible = false;
				this.lblModulePoints.Visible = true;
				this.lblModulePointsTotal.Visible = true;
				int i = 0;
				// Add datagrids for modules of each course the organisation has access to
				foreach(DataRow dr in drCourses)
				{
					string CourseName = dr["Name"].ToString();
				
					Label lblCourseName = new Label();
					lblCourseName.ID = "lbl" + CourseName;
					lblCourseName.Text = CourseName;
					lblCourseName.Font.Bold = true;

					i++;
					HtmlGenericControl ctlBR1 = new HtmlGenericControl();
					ctlBR1.InnerHtml="<br>";
					ctlBR1.ID = "genBR" + i.ToString();

					i++;
					HtmlGenericControl ctlBR2 = new HtmlGenericControl();
					ctlBR2.InnerHtml="<br>";
					ctlBR2.ID = "genBR" + i.ToString();
	
					//Get modules for the course into a datatable
					int CourseID = Int32.Parse(dr["CourseID"].ToString());
				
					DataTable dtModules = objProfile.ProfileGetModulePoints(CourseID, ProfilePeriodID, OrganisationID);
				
					// Get points for the Course
					double CoursePoints = GetCoursePoints(dtModules);
					TotalModulePoints += CoursePoints;

					//Create datagrid
					DataGrid dgrCourseModules = new DataGrid();

					//Set properties
					dgrCourseModules.AutoGenerateColumns = false;
					dgrCourseModules.ItemStyle.CssClass = "tablerow2";
					dgrCourseModules.AlternatingItemStyle.CssClass = "tablerow1";
					dgrCourseModules.HeaderStyle.CssClass = "tablerowtop";
					dgrCourseModules.ID = "dgrCourse" + CourseID.ToString();
		
					//Set up templates for databinding
					TemplateColumn tcPolicyPointsID = new TemplateColumn();
					tcPolicyPointsID.HeaderText = "Policy Points ID";
					tcPolicyPointsID.ItemTemplate = Page.LoadTemplate("ProfilePointsIDTemplate.ascx");
					dgrCourseModules.Columns.Add(tcPolicyPointsID);

					TemplateColumn tcModuleID = new TemplateColumn();
					tcModuleID.HeaderText = "Module ID";
					tcModuleID.ItemTemplate = Page.LoadTemplate("ModuleIDTemplate.ascx");
					dgrCourseModules.Columns.Add(tcModuleID);

					TemplateColumn tcModuleName = new TemplateColumn();
					tcModuleName.HeaderText = ResourceManager.GetString("module_name");
					tcModuleName.ItemTemplate = Page.LoadTemplate("ModuleNameTemplate.ascx");
					dgrCourseModules.Columns.Add(tcModuleName);

					TemplateColumn tcModulePoints = new TemplateColumn();
					tcModulePoints.HeaderText = ResourceManager.GetString("lblPoints");
					tcModulePoints.ItemTemplate = Page.LoadTemplate("ModulePointsTemplate.ascx");
					dgrCourseModules.Columns.Add(tcModulePoints);
			
					//Event handler for datagrid
					dgrCourseModules.ItemDataBound += new DataGridItemEventHandler(dynamicDataGrid_ItemDataBound);

					//Bind data to datagrid
					dgrCourseModules.DataSource = dtModules;
					dgrCourseModules.DataBind();

					//Add the grid to the placeholder
					phCourseModuleList.Controls.Add(lblCourseName);					
					phCourseModuleList.Controls.Add(ctlBR1);
					phCourseModuleList.Controls.Add(dgrCourseModules);
					phCourseModuleList.Controls.Add(ctlBR2);				
				}
				//Populate the total points for all modules 
				this.lblModulePointsTotal.Text = TotalModulePoints.ToString() + " " + ResourceManager.GetString("lblPoints");
			}
		}

		private double GetCoursePoints(DataTable dtModules)
		{
			double CoursePoints = 0;
			foreach(DataRow dr in dtModules.Rows)
			{
				CoursePoints += double.Parse(dr["Points"].ToString());
			}
			return CoursePoints;
		}


		private void dynamicDataGrid_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			e.Item.Cells[0].Visible = false;
			e.Item.Cells[1].Visible = false;
			e.Item.Cells[2].Width = System.Web.UI.WebControls.Unit.Pixel(300);
			e.Item.Cells[3].Width = System.Web.UI.WebControls.Unit.Pixel(50);
		}

		protected void lnkAssignUnits_Click(object sender, System.EventArgs e)
		{
			// Get units which have already been assigned and set 
			// as checked on the treeview
			SetAssignedUnits();

			// Manipulation of panels so visible
			this.panAssignPoints.Visible = false;

			this.panAssignUnits.Visible = true;
			this.panUnitSelect.Visible = true;
			this.panAssign.Visible = true;

			this.panAssignUsers.Visible = false;
			this.panUserUnitSelect.Visible = false;
			this.panUserSearchResults.Visible = false;
			this.panUserDetails.Visible = false;
			this.panSearchReset.Visible = false;
			this.panUserSaveAll.Visible = false;
			this.panUserSearchMessage.Visible = false;

			this.panViewUsers.Visible = false;
			this.panUserList.Visible = false;
			this.panUnitSaveAll.Visible = false;
			this.lblUnitAssignMessage.Visible = false;			
			
		}

		private void SetAssignedUnits()
		{
			int ProfilePeriodID;
			try
			{
				ProfilePeriodID = int.Parse(Session["ProfilePeriodID"].ToString());
			}
			catch
			{
				ProfilePeriodID = -1;
			}

			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			DataTable dtAssignedUnits = objProfile.GetProfileUnitAccess(ProfilePeriodID);
			
			BusinessServices.Unit objUnit= new  BusinessServices.Unit();
			DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'A',false);

			if(dstUnits.Tables[0].Rows.Count > 0)
			{
				//Loop through and assign values to a string array
				string[] strAssignedUnits = new string[dtAssignedUnits.Rows.Count];
				for(int row = 0; row < dtAssignedUnits.Rows.Count; ++row)
				{
					strAssignedUnits[row] = dtAssignedUnits.Rows[row]["UnitID"].ToString();
				}
				this.trvUnitsSelector.SetSelectedValues(strAssignedUnits);
				this.lblSelectUnits.Visible = true;
				this.lblUnitMessage.Visible = false;
				this.btnAssign.Visible = true;
			}
			else
			{
				//No units exist - display message
				this.lblUnitMessage.Visible = true;
				this.lblSelectUnits.Visible = false;
				this.lblUnitMessage.Text = ResourceManager.GetString("NoUnits");
				this.lblUnitMessage.CssClass = "FeedbackMessage";
				this.btnAssign.Visible = false;
			}
		}

		protected void lnkAssignUsers_Click(object sender, System.EventArgs e)
		{
			int ProfileID;
			try
			{
				ProfileID = int.Parse(Session["ProfileID"].ToString());
			}
			catch
			{
				ProfileID = -1;
			}
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			DisplayType = "search";	

			BusinessServices.Unit objUnit= new  BusinessServices.Unit();
			DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'A',false);

			if (dstUnits.Tables[0].Rows.Count == 0)
			{
				//No Units and therefore no users - display message and hide controls
				this.panUserUnitSelect.Visible = false;
				this.panUserDetails.Visible = false;
				this.panSearchReset.Visible = false;
				this.lblUserMessage.Visible = true;
				this.lblUserMessage.Text = ResourceManager.GetString("NoUnits");
				this.lblUserMessage.CssClass = "FeedbackMessage";
			}
			else
			{
				this.panUserUnitSelect.Visible = true;
				this.panUserDetails.Visible = true;
				this.panSearchReset.Visible = true;
				this.lblUserMessage.Visible = false;
			}
			this.panAssignUsers.Visible = true;
			this.panAssignPoints.Visible = false;
			this.panAssignUnits.Visible = false;
			this.panUnitSelect.Visible = false;
			this.panAssign.Visible = false;
			this.panUserSearchResults.Visible = false;
			this.panUserSaveAll.Visible = false;
			this.panUserSearchMessage.Visible = false;
			this.panViewUsers.Visible = false;
			this.panUserList.Visible = false;
			this.panUnitSaveAll.Visible = false;
			this.lblUserAssignMessage.Text= String.Empty;
			blnViewUsers=false;

			
		}

		protected void lnkViewUsers_Click(object sender, System.EventArgs e)
		{
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			DisplayType = "view";

			this.panAssignPoints.Visible = false;

			this.panAssignUnits.Visible = false;
			this.panUnitSelect.Visible = false;
			this.panAssign.Visible = false;

			this.panAssignUsers.Visible = false;
			this.panUserUnitSelect.Visible = false;
			this.panUserDetails.Visible = false;
			this.panSearchReset.Visible = false;
			this.panUserSearchResults.Visible = false;
			this.panUserSaveAll.Visible = true;
			this.panUserSearchMessage.Visible = false;

			this.panViewUsers.Visible = true;
			this.panUserList.Visible = false;
			this.panUnitSaveAll.Visible = false;
			blnViewUsers = true;

			ShowData(0);

		}

		protected override void Render(HtmlTextWriter writer)
		{
			//-- Hack. Could not work out how to use the render event in the tree view, therefore this code is run on every page that has a tree view. Hope to refactor after discovering the solution.
			System.Text.StringBuilder sb = new System.Text.StringBuilder();
			System.IO.StringWriter sw = new System.IO.StringWriter(sb);
			HtmlTextWriter newWriter = new HtmlTextWriter(sw);
                  
			base.Render(newWriter);
                  
			sb.Replace("Clear All", ResourceManager.GetString("treeClearAll"));
			sb.Replace("Collapse All", ResourceManager.GetString("treeCollapseAll"));
			sb.Replace("Expand All", ResourceManager.GetString("treeExpandAll"));
			sb.Replace("class=\"TreeView_Node\">Help</a>", "class=\"TreeView_Node\">" + ResourceManager.GetString("treeHelp") + "</a>");
			sb.Replace("Select All", ResourceManager.GetString("treeSelectAll"));

			Response.Write(sb.ToString());
			// -End Hack
			
		}

		protected void btnCancel_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(@"\Administration\CPD\cpddefault.aspx");
		}

		protected void btnNewProfilePeriod_Click(object sender, System.EventArgs e)
		{
			this.lblNoPeriod.Text = String.Empty;
			this.panPeriod.Visible = true;
			this.rbNoAction.Checked = true;
			this.btnSaveProfile.Visible = true;
			this.btnNewProfilePeriod.Visible = false;
		}

		protected void btnSaveProfile_Click(object sender, System.EventArgs e)
		{

			this.cvCurrentPoints.Validate();
			this.cvCurrentDate.Validate();

			//Fix for issue BD 109
			int ProfileID;
			int ProfilePeriodID;
			try
			{
				ProfileID = int.Parse(Session["ProfileID"].ToString());				
			}
			catch
			{
				ProfileID = -1;				
			}
			try
			{
				ProfilePeriodID = int.Parse(Session["ProfilePeriodID"].ToString());
			}
			catch
			{
				ProfilePeriodID = -1;
			}

			if (!this.IsValid && (ProfileID < 0)) 
			{ 
				return; 
			}
			else if (!this.IsValid)
			{
				return;
			}
			
			this.lblNoPeriod.Text = String.Empty;
			// Get profile values
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			objProfile = GetProfileValues();

			int OrganisationID = UserContext.UserData.OrgID;			

			// check for overlaps in periods for this profile
			int overlap  = objProfile.CheckPeriodOverlap(objProfile);
			if (overlap>0)
			{
				this.lblMessage.Text += ResourceManager.GetString("PeriodOverlap");
				this.lblMessage.CssClass = "WarningMessage";
				return;
			}

			if(ProfileID > 0) //Existing profile - update
			{
				objProfile.UpdateProfile(objProfile);
				
				ProfilePeriodID = objProfile.GetProfilePeriodID(ProfileID);
				Session["ProfilePeriodID"] = ProfilePeriodID;

				objProfile.UpdateProfilePeriodAccess(OrganisationID, ProfilePeriodID);
				panPeriod.Visible = true;
				InitialisePage(ProfileID, ProfilePeriodID);
				LoadProfile(ProfileID,ProfilePeriodID);
			}
			else // New profile - Add
			{
				ProfileID = objProfile.AddProfile(objProfile);
				ProfilePeriodID = objProfile.ProfilePeriodID;
				// Assign the new values to session variables
				Session["ProfilePeriodID"] = ProfilePeriodID;
				Session["ProfileID"] = ProfileID;

				// Initialize all units and users granted access to 0
				objProfile.InitialiseProfilePeriodAccess(OrganisationID, ProfileID, ProfilePeriodID);
				InitialiseProfilePoints(ProfileID, ProfilePeriodID, OrganisationID);
				// Need to get new ProfilePeriodID for Profile				
								
				panPeriod.Visible = true;
				InitialisePage(ProfileID, ProfilePeriodID);
				LoadProfile(ProfileID, ProfilePeriodID);
			}
			this.lblMessage.Text += ResourceManager.GetString("SaveSuccess");
			this.lblMessage.CssClass = "SuccessMessage";
		}

		private void InitialiseProfilePoints(int ProfileID, int ProfilePeriodID, int OrganisationID)
		{
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			
			// Initialise parameters to be passed
			string ProfilePointsType;
			//int ProfilePeriodID = objProfile.GetProfilePeriodID(ProfileID);
			double Points = 0.0;
			int Active = 1;

			// Modules
			ProfilePointsType = "M";
			// Get courses for Org
			BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
			DataTable dtCourses = objOrganisation.GetCourseAccessList(OrganisationID);
			//Filter by granted courses for this organisation
			DataRow[] drCourses = dtCourses.Select("Granted=1");

			// Get Modules for Courses
			foreach(DataRow drCourse in drCourses)
			{
				//Get modules for the course into a datatable
				int CourseID = Int32.Parse(drCourse["CourseID"].ToString());

				BusinessServices.Module objModule = new BusinessServices.Module();
                DataTable dtModules = objModule.GetModuleListByCourse(CourseID, OrganisationID);
				DataRow[] drModules = dtModules.Select("Active=1");
				foreach(DataRow drModule in drModules)
				{
					int ModuleID = Int32.Parse(drModule["ModuleID"].ToString());
                    objProfile.AddProfilePoints(ProfilePointsType, ModuleID, ProfilePeriodID, Points, Active, UserContext.UserData.OrgID);
				}				
			}			

			// Policies
			ProfilePointsType = "P";
			DataTable dtPolicies = objOrganisation.GetOrganisationPolicyList(OrganisationID);
			foreach(DataRow drPolicy in dtPolicies.Rows)
			{
				int PolicyID = Int32.Parse(drPolicy["PolicyID"].ToString());
                objProfile.AddProfilePoints(ProfilePointsType, PolicyID, ProfilePeriodID, Points, Active, UserContext.UserData.OrgID);
			}

		}

		private BusinessServices.Profile GetProfileValues()
		{
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			int ProfileID;
			try
			{
				ProfileID = int.Parse(Session["ProfileID"].ToString());
			}
			catch
			{
				ProfileID = -1;
			}

			if(ProfileID > 0) // Set ProfileID if existing Profile
			{
				objProfile.ProfileID = ProfileID;
			}

			int ProfilePeriodID;
			try
			{
				ProfilePeriodID = int.Parse(Session["ProfilePeriodID"].ToString());
			}
			catch
			{
				ProfilePeriodID = -1;
			}
			if (ProfilePeriodID>0)
			{
				objProfile.ProfilePeriodID = ProfilePeriodID;
			}

			// Get values from controls

			objProfile.OrganisationID = UserContext.UserData.OrgID;
			objProfile.ProfileName = this.txtProfileName.Text.ToString();
			try
			{
				objProfile.DateStart = GetDateFromDropDowns("CurrentDate","Start");
			}
			catch
			{
				objProfile.DateStart = DateTime.Parse("1/1/1900");
			}
			try
			{
				objProfile.DateEnd = GetDateFromDropDowns("CurrentDate", "End");
			}
			catch
			{
				objProfile.DateEnd = DateTime.Parse("1/1/1900");
			}
			if(this.txtCurrentPoints.Text.Length > 0)
			{
				objProfile.Points = double.Parse(this.txtCurrentPoints.Text.ToString());
			}
			objProfile.EndOfPeriodAction = GetEndOfPeriodAction();
			switch(objProfile.EndOfPeriodAction)
			{
				case "1":
					//reset future period info
					objProfile.FutureDateStart = DateTime.Parse("1/1/1900");
					objProfile.FutureDateEnd = DateTime.Parse("1/1/1900");
					objProfile.FuturePoints = 0.0;
					objProfile.MonthIncrement = 0;
					break;
				case "2": //Automatic increment by current period duration
					//Get the duration of current period in days (End Date - Start Date)
					TimeSpan ts = objProfile.DateEnd - objProfile.DateStart;
					int differenceInDays = ts.Days;
					//Set Future Start Date to be day after Current Period End Date
					objProfile.FutureDateStart = objProfile.DateEnd.AddDays(1);
					//Set Future End Date to be Future Start Date + duration period
					objProfile.FutureDateEnd = objProfile.FutureDateStart.AddDays(Convert.ToDouble(differenceInDays));
					//Set Future Points value to equal Current Points Value
					objProfile.FuturePoints = objProfile.Points;
					break;
				case "3": //Automatic increment by set month period
					//Get month value specified by user
					int month = Convert.ToInt32(this.txtMonth.Text.ToString());
					//Set Future Start Date to be day after Current Period End Date
					objProfile.FutureDateStart = objProfile.DateEnd.AddDays(1);
					//Set Future End Date to be Future Start Date + month value specified by user
					objProfile.FutureDateEnd = objProfile.FutureDateStart.AddMonths(month);
					objProfile.FutureDateEnd = objProfile.FutureDateEnd.AddDays(-1);
					// Month increment value
					objProfile.MonthIncrement = Int32.Parse(this.txtMonth.Text);
					//Set Future Points value to equal Current Points Value
					objProfile.FuturePoints = objProfile.Points;
					break;
				case "4": //New user defined Future Period
					//Set Future Start Date to be date specified by user
					objProfile.FutureDateStart = GetDateFromDropDowns("FutureDate", "Start");
					//Set Future End Date to be date specified by user
					objProfile.FutureDateEnd = GetDateFromDropDowns("FutureDate", "End");
					//Set Future Points value to be value specified by user
					objProfile.FuturePoints = double.Parse(this.txtFuturePoints.Text.ToString());
					break;
			}

			return objProfile;
		}

		private string GetEndOfPeriodAction()
		{
			string EndOfPeriodAction = "1";

			if(this.rbNoAction.Checked){EndOfPeriodAction="1";}
			if(this.rbAutoIncrementAsCurrent.Checked){EndOfPeriodAction="2";}
			if(this.rbAutoIncrementByMonth.Checked){EndOfPeriodAction="3";}
			if(this.rbNewFuturePeriod.Checked){EndOfPeriodAction="4";}

			return EndOfPeriodAction;
		}

		private DateTime GetDateFromDropDowns(string currentFuture, string controlSuffix)
		{
			return new DateTime(
				int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Year")).SelectedValue)
				, int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Month")).SelectedValue)
				, int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Day")).SelectedValue));
		}

		protected void cvCurrentDate_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			ValidateDateControls(source, args, "CurrentDate");
		}

		protected void cvFutureDate_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			//If future radio button selected
			if (this.rbNewFuturePeriod.Checked)
			{
				ValidateDateControls(source, args, "CurrentDate");
				if (args.IsValid)
				{
					ValidateDateControls(source, args, "FutureDate");
				
					// If the above is all OK perform the following checks as well
					if(args.IsValid)
					{
						// Start Date is after end date of Previous Period
						DateTime dtFutureStart = GetDateFromDropDowns("FutureDate", "Start");
						DateTime dtCurrentEnd = GetDateFromDropDowns("CurrentDate", "End");
						if(dtFutureStart < dtCurrentEnd)
						{
							((CustomValidator)source).ErrorMessage = ResourceManager.GetString("PeriodOverlap");
							args.IsValid = false; 
							return; 
						}
						dtFutureStart = GetDateOnly(dtFutureStart);
						dtCurrentEnd = GetDateOnly(dtCurrentEnd);
						//Gap between end of current period and start of future period
						TimeSpan ts = dtFutureStart.Subtract(dtCurrentEnd);
						if(ts.Days > 1)
						{
							this.lblMessageGap.Text += ResourceManager.GetString("GapBetweenPeriods");
							this.lblMessageGap.CssClass = "FeedbackMessage";
						}
					}
				}
				else
				{
					//has failed because issue with currentdate
					args.IsValid = true;
					//revalidate to check if issue with future date
					ValidateDateControls(source, args, "FutureDate");
					return;
				}
			}			
		}

		private void ValidateDateControls(object source, System.Web.UI.WebControls.ServerValidateEventArgs args, string currentFuture)
		{
			DateTime dtStart;
			DateTime dtEnd;

			// Valid Start Date entered
			try
			{
				dtStart = GetDateFromDropDowns(currentFuture,"Start");
			}
			catch
			{ 
				try
				{
					dtEnd = GetDateFromDropDowns(currentFuture,"End");
				}
				catch
				{ 
					((CustomValidator)source).ErrorMessage = ResourceManager.GetString("ValidStartEndDate"); 
					args.IsValid = false; 
					return; 
				}
				((CustomValidator)source).ErrorMessage = ResourceManager.GetString("ValidStartDate"); 
				args.IsValid = false; 
				return; 
			}

			// Valid End Date entered
			try
			{
				dtEnd = GetDateFromDropDowns(currentFuture,"End");
			}
			catch
			{ 
				try
				{
					dtStart = GetDateFromDropDowns(currentFuture,"Start");
				}
				catch
				{ 
					
					((CustomValidator)source).ErrorMessage = ResourceManager.GetString("ValidStartEndDate"); 
					args.IsValid = false; 
					return; 
				}
				((CustomValidator)source).ErrorMessage = ResourceManager.GetString("ValidEndDate"); 
				args.IsValid = false; 
				return; 
			}

			// Start Date is after the End Date
			dtStart = GetDateFromDropDowns(currentFuture,"Start");
			dtEnd = GetDateFromDropDowns(currentFuture, "End");
			if(dtStart > dtEnd)
			{
				((CustomValidator)source).ErrorMessage = ResourceManager.GetString("StartDateAfterEndDate");
				args.IsValid = false;
				return;
			}
			
			dtEnd = GetDateOnly(dtEnd);
			DateTime dtNow = GetDateOnly(DateTime.Now);
			
			// End Date is today or before				
			if(dtEnd < dtNow)
			{
				((CustomValidator)source).ErrorMessage = ResourceManager.GetString("EndDateBeforeToday"); 
				args.IsValid = false; 
				return;
			}


		}

		private DateTime GetDateOnly(DateTime DateIn)
		{
			DateTime DateOut = new DateTime(DateIn.Year, DateIn.Month, DateIn.Day, 0, 0, 0, 0);
			return DateOut;
		}

		protected void cvProfileName_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			int ProfileID;
			try
			{
				ProfileID = int.Parse(Session["ProfileID"].ToString());
			}
			catch
			{
				ProfileID = -1;
			}

			int OrganisationID = UserContext.UserData.OrgID;
			string ProfileName = this.txtProfileName.Text;
			BusinessServices.Profile objProfile = new BusinessServices.Profile();

			DataTable dtProfileName = objProfile.CheckProfileName(ProfileName, OrganisationID);
			if (dtProfileName.Rows.Count > 0 && (ProfileNameCheck != ProfileName))
			{
				//Name already exists
				((CustomValidator)source).ErrorMessage = ResourceManager.GetString("ProfileExists");
				args.IsValid = false;
				return;
			}

			
			// No value entered for Profile Name
			string strProfileName = this.txtProfileName.Text;
			if(strProfileName.Equals(String.Empty))
			{
				((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvProfileName");
				args.IsValid = false;
				return;
			}
		}

		protected void cvFuturePoints_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			// Check that rbNewFuturePeriod checked
			bool IsFuturePointsChecked = this.rbNewFuturePeriod.Checked;
			if(IsFuturePointsChecked)
			{
				// Get value in txtFuturePoints
				string strFuturePoints = this.txtFuturePoints.Text;

				// If empty then return validation message
				if(strFuturePoints.Equals(String.Empty))
				{
					((CustomValidator)source).ErrorMessage = ResourceManager.GetString("FuturePointsNone");
					args.IsValid = false;
					return;
				}

				// If not numeric then return validation message
				if(!IsNumeric(strFuturePoints))
				{
					((CustomValidator)source).ErrorMessage = ResourceManager.GetString("FuturePointsNotNumeric");
					args.IsValid = false;
					return;
				}
			}
		}

		protected void cvCurrentPoints_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			// Get value in txtFuturePoints
			string strCurrentPoints = this.txtCurrentPoints.Text;

			// If empty then return validation message
			if(strCurrentPoints.Equals(String.Empty))
			{
				((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvCurrentPoints");
				args.IsValid = false;
				return;
			}

			// If not numeric then return validation message
			if(!IsNumeric(strCurrentPoints))
			{
				((CustomValidator)source).ErrorMessage = ResourceManager.GetString("revCurrentPoints");
				args.IsValid = false;
				return;
			}
		}

		protected void cvMonth_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			// Check that rbAutoIncrementByMonth checked
			bool IsMonthChecked = this.rbAutoIncrementByMonth.Checked;
			if(IsMonthChecked)
			{
				// Get value in txtMonth
				string strMonth = this.txtMonth.Text;

				// If empty then return validation message
				if(strMonth.Equals(String.Empty))
				{
					((CustomValidator)source).ErrorMessage = ResourceManager.GetString("MonthNone");
					args.IsValid = false;
					return;
				}

				// If not numeric then return validation message
				if(!IsIntNumeric(strMonth))
				{
					((CustomValidator)source).ErrorMessage = ResourceManager.GetString("MonthNotNumeric");
					args.IsValid = false;
					return;
				}
			}
		}

		private static bool IsNumeric(string strToCheck)
		{
			return Regex.IsMatch(strToCheck,"^\\d+(\\.\\d+)?$");
		}

		private static bool IsIntNumeric(string strToCheck)
		{
			return Regex.IsMatch(strToCheck,@"^[+]?[1-9]\d*\.?[0]*$");
		}

		protected void btnUserSaveAll_Click(object sender, System.EventArgs e)
		{
			int ProfileID;
			try
			{
				ProfileID = int.Parse(Session["ProfileID"].ToString());
			}
			catch
			{
				ProfileID = -1;
			}
			
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			// Update each user in the datagrid
			GetCheckBoxValues();
			RePopulateCheckBoxes();
			DataView dvwPagination;
			dvwPagination	= GetData();

			ArrayList CheckedItems = new ArrayList();

			foreach(DataRow dr in dvwPagination.Table.Rows)
			{
				int AssignUserAccess = 0;
				int UserID = int.Parse(dr["UserID"].ToString());
				CheckedItems = (ArrayList)Session["CheckedItems"];
				if(CheckedItems.Contains(UserID.ToString()))
				{
					AssignUserAccess = 1;
				}
				int Granted = Convert.ToInt32(Convert.ToBoolean(dr["Granted"].ToString()));
				objProfile.SetProfileUserAccessByUser(ProfileID, UserID, AssignUserAccess);
				// Only update points if User was previously not granted access and now has been granted
				if(AssignUserAccess == 1 && Granted == 0)
				{
                    objProfile.UpdateUserCPDPoints(ProfileID, UserID, UserContext.UserData.OrgID);
				}
			}
			
			this.lblUserAssignMessage.Visible = true;
			this.lblUserAssignMessage.Text = ResourceManager.GetString("lblMessage.SaveUsers");
			this.lblUserAssignMessage.CssClass = "SuccessMessage";

			ShowData(int.Parse(Session["PageIndex"].ToString()));
		}

		protected void btnAssign_Click(object sender, System.EventArgs e)
		{
			int ProfileID;
			try
			{
				ProfileID = int.Parse(Session["ProfileID"].ToString());
			}
			catch
			{
				ProfileID = -1;
			}
			string[] selectedUnits;
			selectedUnits = this.trvUnitsSelector.GetSelectedValues();
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			objProfile.ResetProfileUnitAccess(ProfileID);
			//objProfile.ResetProfileUserAccess(ProfileID);
			if(selectedUnits.Length > 0)
			{
				foreach(string strUnitID in selectedUnits)
				{
					objProfile.SetProfileUnitAccess(ProfileID, Int32.Parse(strUnitID));
					objProfile.SetProfileUserAccessByUnit(ProfileID, Int32.Parse(strUnitID));
				}
			}

			this.lblUnitAssignMessage.Visible = true;
			this.lblUnitAssignMessage.Text = ResourceManager.GetString("lblMessage.SaveUnits");
			this.lblUnitAssignMessage.CssClass = "SuccessMessage";
		}

		protected void btnReset_Click(object sender, System.EventArgs e)
		{
			this.trvUserUnitsSelector.ClearSelection();
			this.txtFirstName.Text = String.Empty;
			this.txtLastName.Text = String.Empty;
			this.txtUserName.Text = String.Empty;
			this.txtEmail.Text = String.Empty;
			this.txtExternalId.Text = String.Empty;
			this.lblUserAssignMessage.Text= String.Empty;
			this.panUserSearchResults.Visible = false;
			this.panUserSaveAll.Visible = false;
		}

		private void ShowData(int pageIndex)
		{
			DataView dvwPagination;
			this.lblNoUsers.Text = String.Empty;
			
			dvwPagination	= GetData();

			if(InitialiseSession)
			{
				// First time through populate Session with
				// Arraylist of checked items from database
				ArrayList CheckedItems = new ArrayList();
				foreach(DataRow dr in dvwPagination.Table.Rows)
				{
					bool IsGranted = bool.Parse(dr["Granted"].ToString());
					int ChkBxIndex = int.Parse(dr["UserID"].ToString());
					if(IsGranted)
					{						
						if(!CheckedItems.Contains(ChkBxIndex.ToString()))
						{
							CheckedItems.Add(ChkBxIndex.ToString());
						}
					}
					else
					{
						CheckedItems.Remove(ChkBxIndex.ToString());
					}
				}
				Session["CheckedItems"] = CheckedItems;

				InitialiseSession = false;
			}

			int intRowCount = dvwPagination.Table.Rows.Count; 
			if (intRowCount > 0)
			{
				//2. Use pagination if necessary
				if (intRowCount > ApplicationSettings.PageSize)
				{
					grdResults.AllowPaging=true;
					grdResults.CurrentPageIndex = pageIndex;
				}
				else
				{
					grdResults.AllowPaging=false;
				}
				if (intRowCount > 1)
				{
					//3. Sort Data
					grdResults.AllowSorting=true;
					dvwPagination.Sort = (string)ViewState["OrderByField"] + " " + (string)ViewState["OrderByDirection"];
				}
				else
				{
					grdResults.AllowSorting=false;
				}
                
				//4. Bind Data
				grdResults.DataSource = dvwPagination;
				grdResults.DataBind();
				lblUserCount.Text = String.Format(ResourceManager.GetString("lblUserCount"), intRowCount.ToString());
				this.panUserSearchResults.Visible = true;
				this.panUserSearchMessage.Visible = false;
			}
			else
			{
				lblNoUsers.Text = ResourceManager.GetString("NoUsersFound");
				lblNoUsers.CssClass = "FeedbackMessage";
				this.panUserSearchMessage.Visible = true;
				this.panUserSearchResults.Visible = false;
				this.panUserSaveAll.Visible = false;
			}
			
		}

		private DataView GetData()
		{
			string strParentUnits ="";

			if (!blnViewUsers )
			{
				strParentUnits = String.Join(",", this.trvUserUnitsSelector.GetSelectedValues());
			}
			
			int OrganisationID = UserContext.UserData.OrgID;
			int ProfileID;
			int ProfilePeriodID;
			try
			{
				ProfileID = int.Parse(Session["ProfileID"].ToString());
			}
			catch
			{
				ProfileID = -1;
			}
			try
			{
				ProfilePeriodID = int.Parse(Session["ProfilePeriodID"].ToString());
			}
			catch
			{
				ProfilePeriodID = -1;
			}
            
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			DataTable dtSearchResults = objProfile.ProfileUserSearch(OrganisationID, ProfileID, ProfilePeriodID, strParentUnits,
				this.txtFirstName.Text, this.txtLastName.Text, this.txtUserName.Text, this.txtEmail.Text,
				this.txtExternalId.Text, UserContext.UserID, DisplayType);
			
			return dtSearchResults.DefaultView;
		}

		protected void btnSearch_Click(object sender, System.EventArgs e)
		{
			ShowData(0);
			this.lblUserAssignMessage.Text= String.Empty;			
			this.panUserSaveAll.Visible = true;
		}

		private void grdResults_SortCommand(object source, System.Web.UI.WebControls.DataGridSortCommandEventArgs e)
		{
			SetSortOrder(e.SortExpression);
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			ShowData(0);
		}

		private void grdResults_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
		{
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			GetCheckBoxValues();
			ShowData(e.NewPageIndex
				);
			Session["PageIndex"] = e.NewPageIndex;
			RePopulateCheckBoxes();
		}

		private void GetCheckBoxValues()
		{
			ArrayList CheckedItems = new ArrayList();
			// Loop through DataGrid Items
			foreach(DataGridItem dgItem in grdResults.Items)
			{
				int ChkBxIndex = int.Parse(dgItem.Cells[4].Text);
				CheckBox chkAssign = (CheckBox)dgItem.FindControl("chkAssign");
				//Add ArrayList to Session if it doesn't exist
				if(Session["CheckedItems"] != null)
				{
					CheckedItems = (ArrayList)Session["CheckedItems"];
				}
				if(chkAssign.Checked)
				{
					if(!CheckedItems.Contains(ChkBxIndex.ToString()))
					{
						CheckedItems.Add(ChkBxIndex.ToString());
					}
				}
				else
				{
					CheckedItems.Remove(ChkBxIndex.ToString());
				}
			}
			Session["CheckedItems"] = CheckedItems;
		}

		private void RePopulateCheckBoxes()
		{
			ArrayList CheckedItems = new ArrayList();
			CheckedItems = (ArrayList)Session["CheckedItems"];
			if(CheckedItems != null)
			{
				foreach(DataGridItem dgItem in grdResults.Items)
				{
					int ChkBxIndex = int.Parse(dgItem.Cells[4].Text);
					if(CheckedItems.Contains(ChkBxIndex.ToString()))
					{
						CheckBox chkAssign = (CheckBox)dgItem.FindControl("chkAssign");
						chkAssign.Checked = true;
					}
				}
			}
		}

		private void SetSortOrder(string orderByField)
		{
			string	strOldOrderByField, strOldOrderByDirection;
			string  strOrderByDirection;

			// Get from viewstate
			strOldOrderByField =(string)ViewState["OrderByField"];
			strOldOrderByDirection =(string)ViewState["OrderByDirection"];

			// Compare to desired sort field
			if(strOldOrderByField == orderByField)
			{
				switch(strOldOrderByDirection.ToUpper())
				{
					case "ASC":
						strOrderByDirection = "DESC";
						break;
					case "DESC":
						strOrderByDirection = "ASC";
						break;
					default:
						strOrderByDirection = "ASC";
						break;
				}
			}
			else
			{
				strOrderByDirection = "ASC";
			}

			//save the order by direction and field to the view state.
			ViewState["OrderByField"] = orderByField;
			ViewState["OrderByDirection"] = strOrderByDirection;
		}

		protected void btnDeleteFuturePeriod_Click(object sender, System.EventArgs e)
		{
			// Delete future period
			int ProfileID;
			try
			{
				ProfileID = int.Parse(Session["ProfileID"].ToString());
			}
			catch
			{
				ProfileID = -1;
			}
			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			objProfile.DeleteFuturePeriod(ProfileID);
			Response.Redirect(@"\Administration\CPD\cpddefault.aspx");
		}

		protected void btnSavePoints_Click(object sender, System.EventArgs e)
		{
			string ProfilePointsType;
			int ApplyToQuiz;
			int ApplyToLesson;
			int Active = 1;

			this.cvModulePoints.Validate();
			if(!cvModulePoints.IsValid)
			{
				return;
			}
			this.cvPolicyPoints.Validate();
			if(!cvPolicyPoints.IsValid)
			{
				return;
			}
			
			
			// Value for profileperiodID
			int ProfileID;
			int ProfilePeriodID;
			try
			{
				ProfileID = int.Parse(Session["profileid"].ToString());
			}
			catch
			{
				ProfileID = -1;
			}

			BusinessServices.Profile objProfile = new BusinessServices.Profile();
			try
			{
				ProfilePeriodID = int.Parse(Session["profileperiodid"].ToString());
			}
			catch
			{
				ProfilePeriodID = -1;
			}

			// Iterate through module grids and update values
			// Get values for quiz and lesson check boxes
			ApplyToQuiz = Convert.ToInt32(this.cmnQuiz.Checked);
			ApplyToLesson = Convert.ToInt32(this.cmnLesson.Checked);

			// Update the profileperiod ApplyToQuiz and ApplyToLesson Fields
			objProfile.UpdateProfilePeriodQuizLessonStatus(ProfilePeriodID, ApplyToQuiz, ApplyToLesson);

			ProfilePointsType = "M";
			// Iterate through all controls on page - get those that begin with dgrCourse
			// and update profilepoints for modules in course
			IterateThroughControls(Page, ProfilePointsType, ProfilePeriodID, Active);
			
			// Iterate through policy grid and update values
			ProfilePointsType = "P";
			foreach(DataGridItem dgiPolicy in this.grdPolicyPoints.Items)
			{
				TextBox txtPolicyPoints = (TextBox)dgiPolicy.FindControl("txtPolicyPoints");
				double PolicyPoints = double.Parse(txtPolicyPoints.Text);
				int PolicyID = Int32.Parse(dgiPolicy.Cells[1].Text);
				
				if (dgiPolicy.Cells[0].Text=="&nbsp;")
				{
                    objProfile.AddProfilePoints(ProfilePointsType, PolicyID, ProfilePeriodID, PolicyPoints, Active, UserContext.UserData.OrgID);
				}
				else
				{
					int ProfilePointsID = Int32.Parse(dgiPolicy.Cells[0].Text);
                    objProfile.UpdateProfilePoints(ProfilePointsID, ProfilePointsType, PolicyID, ProfilePeriodID, PolicyPoints, Active, UserContext.UserData.OrgID);
				}
			}

			// update users that have completed the course with points.
			if (rbAllUsersIncluding.Checked)
			{
                objProfile.ProfileAssignModulePoints(ProfileID, UserContext.UserData.OrgID);
			}
			if (rbAllUsersExcluding.Checked)
			{
				objProfile.ProfileExclude(ProfilePeriodID);
			}
			
			//Refresh Grids			
			DisplayCourseModules();
			BindPolicyPointsGrid();
			ShowHideAssignPointControls();
			this.lblPointsAssignMessage.Visible = true;
			this.lblPointsAssignMessage.Text = ResourceManager.GetString("lblMessage.SavePoints");
			this.lblPointsAssignMessage.CssClass = "SuccessMessage";
		}


		protected void cvModulePoints_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			IterateThroughModuleGrids(Page, source, args);
		}

		private void IterateThroughModuleGrids(Control parent, object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			foreach(Control ctrl in parent.Controls)
			{
				// Check if dgrCourse control and update database with new values
				if (!(ctrl.ID == null))
				{
					if (ctrl.ID.StartsWith("dgrCourse"))
					{
						DataGrid dgrCourse = (DataGrid)ctrl;
						foreach(DataGridItem dgiModule in dgrCourse.Items)
						{
							TextBox txtModulePoints = (TextBox)dgiModule.Cells[3].Controls[0].FindControl("txtModulePoints");
							try
							{
								double ModulePoints = double.Parse(txtModulePoints.Text);
							}
							catch
							{
								((CustomValidator)source).ErrorMessage = ResourceManager.GetString("InvalidPoints");
								args.IsValid = false;
								return;
							}
						}
					}
				}
				// Check if this control has sub controls - if so then call this function passing in the control
				if (ctrl.Controls.Count > 0)
				{
					IterateThroughModuleGrids(ctrl, source, args);
				}
			}

		}

		protected void cvPolicyPoints_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			IterateThroughPolicyGrid(Page, source, args);
		}

		private void IterateThroughPolicyGrid(Control parent, object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			foreach(Control ctrl in parent.Controls)
			{
				// Check if dgrCourse control and update database with new values
				if (!(ctrl.ID == null))
				{
					if (ctrl.ID.StartsWith("grdPolicy"))
					{
						DataGrid dgrPolicy = (DataGrid)ctrl;
						foreach(DataGridItem dgiModule in dgrPolicy.Items)
						{
							TextBox txtPolicyPoints = (TextBox)dgiModule.Cells[3].Controls[0].FindControl("txtPolicyPoints");
							try
							{
								double PolicyPoints = double.Parse(txtPolicyPoints.Text);
							}
							catch
							{
								((CustomValidator)source).ErrorMessage = ResourceManager.GetString("InvalidPoints");
								args.IsValid = false;
								return;
							}
						}
					}
				}
				// Check if this control has sub controls - if so then call this function passing in the control
				if (ctrl.Controls.Count > 0)
				{
					IterateThroughPolicyGrid(ctrl, source, args);
				}
			}
		}

		private void IterateThroughControls(Control parent, string ProfilePointsType, int ProfilePeriodID, int Active)
		{
			foreach(Control ctrl in parent.Controls)
			{
				// Check if dgrCourse control and update database with new values
				if (!(ctrl.ID == null))
				{
					if (ctrl.ID.StartsWith("dgrCourse"))
					{
						DataGrid dgrCourse = (DataGrid)ctrl;
						foreach(DataGridItem dgiModule in dgrCourse.Items)
						{
							Label lblModuleID = (Label)dgiModule.Cells[1].Controls[0].FindControl("lblModuleID");
							int ModuleID = Int32.Parse(lblModuleID.Text);
							TextBox txtModulePoints = (TextBox)dgiModule.Cells[3].Controls[0].FindControl("txtModulePoints");
							double ModulePoints = double.Parse(txtModulePoints.Text);
							BusinessServices.Profile objProfile = new BusinessServices.Profile();

							Label lblProfilePointsID = (Label)dgiModule.Cells[0].Controls[0].FindControl("lblProfilePointsID");
							// check if profilepoints is "" then add else update
							if (lblProfilePointsID.Text =="")
							{
                                objProfile.AddProfilePoints(ProfilePointsType, ModuleID, ProfilePeriodID, ModulePoints, 1, UserContext.UserData.OrgID);
							}
							else
							{
								int ProfilePointsID = Int32.Parse(lblProfilePointsID.Text);
                                objProfile.UpdateProfilePoints(ProfilePointsID, ProfilePointsType, ModuleID, ProfilePeriodID, ModulePoints, Active, UserContext.UserData.OrgID);
							}							
						}
					}
				}
				// Check if this control has sub controls - if so then call this function passing in the control
				if (ctrl.Controls.Count > 0)
				{
					IterateThroughControls(ctrl, ProfilePointsType, ProfilePeriodID, Active);
				}
			}
		}

		
		private void grdPolicyPoints_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
		{
			e.Item.Cells[2].Width = System.Web.UI.WebControls.Unit.Pixel(300);
			e.Item.Cells[3].Width = System.Web.UI.WebControls.Unit.Pixel(50);
		}

	}
}
