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

namespace Bdw.Application.Salt.Web.Administration.Organisation
{
	/// <summary>
	/// This class controls the page and business logic for the CourseAccess.aspx page.
	/// This page allows an administrator to set the course access for a particular organisation based on the available courses in the database.
	/// </summary>
	/// <remarks>
	/// Assumptions: This page should only be available to Salt and Organisation administrators.
	/// Notes: None.
	/// Author: Peter Vranich
	/// Date: 20/02/0/2004
	/// Changes:
	/// </remarks>
	public partial class CourseAccess : System.Web.UI.Page
	{
		#region Protected Variables
		/// <summary>
		/// The datagrid that will display all the courses available for this organisation.
		/// </summary>
		protected System.Web.UI.WebControls.DataGrid dtgCourse;
		
		/// <summary>
		/// The label to hold any messages that need to be displayed to the user.
		/// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;
		#endregion
		
		#region Private Event Handlers
		/// <summary>
		/// Event handler for the page load event.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			if (!Page.IsPostBack)
			{
				this.LoadData();
			}
		} // Page_Load
		
		/// <summary>
		/// Event handler for the save button.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			this.SaveData();
		} // btnSave_Click
		
		/// <summary>
		/// Event handler for Return to Admin homepage link button.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
        private void lnkReturnToAdminHomepage_Click(object sender, System.EventArgs e)
        {
				Response.Redirect("/Administration/Administration.aspx");
		} // lnkReturnToAdminHomepage_Click
		#endregion
		
		#region Private Methods
		/// <summary>
		/// Loads the data when the page is first loaded.
		/// </summary>
		private void LoadData()
		{
			//1.Load Course list that are assigned to this organisation.
			this.GetCourseList();
		} // LoadData
		
		/// <summary>
		/// Loads the course list that is assigned to this organisation.
		/// </summary>
		private void GetCourseList()
		{
            // Get the organisation 
			BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
			DataTable dtbCourses = objOrganisation.GetCourseAccessList(UserContext.UserData.OrgID);

            if (dtbCourses.Rows.Count > 0)
            {
                this.dtgCourse.DataKeyField = "CourseID";
                this.dtgCourse.DataSource = dtbCourses;
                this.dtgCourse.DataBind();
                this.btnSave.Visible = true;
            }
            else
            {
                this.btnSave.Visible = false;
                this.lblMessage.Text = ResourceManager.GetString("lblMessage.NoCourse");//"No courses were found";
                this.lblMessage.CssClass = "FeedbackMessage";
            }

		} // GetCourseList
		
		/// <summary>
		/// Saves the Organisation course access settings.
		/// </summary>
		private void SaveData()
		{
			try
			{
				string strGrantedCourseIDs;
				strGrantedCourseIDs = Request.Form["chkGrantedCourse"];
				

				if (strGrantedCourseIDs != null)
				{
					foreach (string courseID in strGrantedCourseIDs.Split(','))
					{
						if (courseID !=  string.Empty)
							BusinessServices.Unit.DenyAllForOrgCourse(UserContext.UserData.OrgID, Int32.Parse(courseID));
					}
				}

				BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
				objOrganisation.SaveCourseAccess(UserContext.UserData.OrgID, strGrantedCourseIDs);
				UpdateProfilePoints();
				this.GetCourseList();
				this.lblMessage.Text = ResourceManager.GetString("lblMessage.Success");//"Course Access has been saved successfully.";
                this.lblMessage.CssClass = "SuccessMessage";
			}
			catch(Exception ex)
			{
				throw new ApplicationException(ex.Message);
			}
		} // SaveData
		#endregion
		
		private void UpdateProfilePoints()
		{
			// Initialise parameters to be passed
			string ProfilePointsType;
			ProfilePointsType = "M";
			double Points = 0.0;
			int Active = 1;
			
			BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
			DataTable dtCourses = objOrganisation.GetCourseAccessList(UserContext.UserData.OrgID);

			foreach(DataRow drCourse in dtCourses.Rows)
			{
				int intCourseID = int.Parse(drCourse["CourseID"].ToString());
				BusinessServices.Module objModule = new BusinessServices.Module();
                DataTable dtModules = objModule.GetModuleListByCourse(intCourseID, UserContext.UserData.OrgID);
				foreach(DataRow drModule in dtModules.Rows)
				{
					int intModuleID = int.Parse(drModule["ModuleID"].ToString());
					BusinessServices.Profile objProfile = new BusinessServices.Profile();
					DataTable dtProfiles = objProfile.GetProfilesForCurrentOrg(UserContext.UserData.OrgID);
					foreach(DataRow drProfile in dtProfiles.Rows)
					{
						int intProfileID = int.Parse(drProfile["ProfileID"].ToString());
						int intProfilePeriodID = objProfile.GetProfilePeriodID(intProfileID);

						// Check if record already exists in tblProfilePoints - if not then add record
						if(!objProfile.CheckProfilePointsExist(intProfilePeriodID, intModuleID) && intProfilePeriodID != -1)
						{
                            objProfile.AddProfilePoints(ProfilePointsType, intModuleID, intProfilePeriodID, Points, Active, UserContext.UserData.OrgID);
						}
					}
				}
			}


		}

		#region Protected Methods		
		/// <summary>
		/// Converts the granted bit value to a string.
		/// </summary>
		/// <param name="granted"> Value to be converted to a string.</param>
		/// <returns> The string value of the granted Bit parameter.</returns>
		protected string GetGrantStatus(object granted)
		{
			if((int)granted == 1)
			{
				return "checked";
			}
			else
			{
				return "";
			}
		} // GetGrantStatus
		#endregion
		
		#region Web Form Designer generated code

        /// <summary>
        ///  This call is required by the ASP.NET Web Form Designer.
        /// </summary>
        /// <param name="e"></param>
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
			dtgCourse.Columns[0].HeaderText = ResourceManager.GetString("grid_CourseName");//"Course Name";
			dtgCourse.Columns[1].HeaderText = ResourceManager.GetString("grid_AllowAccess");//"Allow Access";
			

		} // OnInit
		
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