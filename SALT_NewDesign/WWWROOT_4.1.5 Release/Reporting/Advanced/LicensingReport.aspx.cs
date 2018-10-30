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

namespace Bdw.Application.Salt.Web.Reporting
{
	/// <summary>
	/// Summary description for LicensingReport.
	/// </summary>
	public partial class LicensingReport : System.Web.UI.Page
	{
		protected LocalizedLinkButton lnkReportPeriod;
		


		protected void Page_Load(object sender, System.EventArgs e)
		{
			if (!this.IsPostBack)
			{
				panelReport.Visible = false;
				panelReportParams.Visible = true;
				pagTitle.InnerText = ResourceManager.GetString("pagTitle");
				
				BusinessServices.Organisation objOrg = new BusinessServices.Organisation();
				DataTable dtCoursesExist = objOrg.GetCourseAccessList(UserContext.UserData.OrgID);
				int rowCount = 0;
				DataRow[] drCoursesExist = dtCoursesExist.Select("Granted = 1");
				foreach (DataRow dr in drCoursesExist)
				{
					rowCount++;
				}
				if (rowCount == 0)
				{
					lblError.Text = ResourceManager.GetString("lblError.NoCourse");
					panCourse.Visible = false;
				}
				else
				{

					DataTable dtCourses = BusinessServices.CourseLicensing.GetCoursesWithPeriod(UserContext.UserData.OrgID); 
					rptList.DataSource = dtCourses;
					rptList.DataBind();

					if (dtCourses.Rows.Count == 0)
					{
						lblError.Text = ResourceManager.GetString("lblError.NoCoursePeriod");//"No courses exist with periods in this organisation."; //ResourceManager.GetString("msgNoCoursesExistInThisOrganisation");
						panCourse.Visible = false;
					}
				}
			}
		}

		private void rptList_ItemDataBound(object sender, RepeaterItemEventArgs e)
		{
			if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				DataRowView drv = (DataRowView)e.Item.DataItem;
				int courseID = Int32.Parse(drv["CourseID"].ToString());

				DropDownList ddlPeriod = (DropDownList)e.Item.FindControl("ddlPeriod");
				DataTable dtPeriodList = BusinessServices.CourseLicensing.GetPeriodList(courseID, UserContext.UserData.OrgID);
				foreach (DataRow dr in dtPeriodList.Rows)
				{
					string display = string.Format("{0:dd/MM/yyyy}", (DateTime)dr["DateStart"]) 
						+ " - " + 
						string.Format("{0:dd/MM/yyyy}", (DateTime)dr["DateEnd"]);

					string courseLicensingID = dr["CourseLicensingID"].ToString();
					ddlPeriod.Items.Add(new ListItem(display, courseLicensingID));
				}
			}
		}
		private void rptList_ItemCommand(object source, RepeaterCommandEventArgs e)
		{
			DropDownList ddl = (DropDownList)e.Item.FindControl("ddlPeriod");
			int courseLicensingID = Int32.Parse(ddl.SelectedValue);
			RunReport(courseLicensingID);
		}


		private void butRunAll_Click(object sender, EventArgs e)
		{
			RunReport(0);
		}

		private void RunReport(int courseLicensingID)
		{
			panelReport.Visible = true;
			panelReportParams.Visible = false;

			Hashtable parameters = this.rvReport.Parameters;
			parameters["organisationID"] = UserContext.UserData.OrgID;
			parameters["CourseLicensingID"] = courseLicensingID;
			parameters["AdminUserID"] = UserContext.UserID;
			parameters["effectiveDate"] = DateTime.Now.Date;

			parameters["langCode"] = Request.Cookies["currentCulture"].Value;
			parameters["langInterfaceName"] = "Report.Licensing";
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
			rptList.ItemDataBound +=new RepeaterItemEventHandler(rptList_ItemDataBound);
			butRunAll.Click+=new EventHandler(butRunAll_Click);
			rptList.ItemCommand+=new RepeaterCommandEventHandler(rptList_ItemCommand);

		}
		#endregion

	}
}
