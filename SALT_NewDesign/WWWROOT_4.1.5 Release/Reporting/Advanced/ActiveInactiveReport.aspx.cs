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
namespace Bdw.Application.Salt.Web.Reporting.Advanced
{
    /// <summary>
    /// Business logic and presentation logic for the completed users report
    /// </summary>
    /// <remarks>
    /// Notes: 
    /// Author: Jack Liu
    /// Changes:
    /// </remarks>
	public partial class ActiveInactiveReport : System.Web.UI.Page
	{
		protected Bdw.Application.Salt.Web.General.UserControls.Navigation.HelpLink ucHelp;
		#region protected controls


		#endregion

		#region Event Handlers
		/// <summary>
		/// Event handler for the page load
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			ucHelp.Attributes["Desc"] = ResourceManager.GetString("ucHelp");
			// when the page loads for the first time hide the report results place holder.           
			if(!Page.IsPostBack)
			{
				
				this.plhSearchCriteria.Visible = true;
				this.plhReportResults.Visible = false;
				this.PaintCriteraPageState();
			}
		}


		protected void btnRunReport_Click(object sender, System.EventArgs e)
		{
			if(WebTool.ValidateHistoricDateControl(this.lstFromDay, this.lstFromMonth, this.lstFromYear)
				|| WebTool.ValidateDateControl(this.lstToDay, this.lstToMonth, this.lstToYear))
			{
				this.plhSearchCriteria.Visible = false;
				this.plhReportResults.Visible = true;
				this.plhTitle.Visible =false;
				this.lblError.Visible=false;
				this.ShowReport();
			}
			else
			{
				this.plhSearchCriteria.Visible = true;
				this.plhReportResults.Visible = false;
				this.plhTitle.Visible =true;
				this.lblError.Text=ResourceManager.GetString("lblError.Date");//"The date must be valid and from date cannot be greater than today";
				this.lblError.Visible=true; 
			}            
		}



		protected void btnReset_Click(object sender, System.EventArgs e)
		{
			// Re-call the same page so that the default search criteria values are shown
			Response.Redirect(Request.RawUrl);
		}

		protected void rvReport_PageIndexChanged(object sender, System.EventArgs e)
		{
			this.ShowReport();
		}



		#endregion

		#region private methods
		/// <summary>
		/// Paint Critera section of the page
		/// </summary>
		/// <remarks>
		/// </remarks>
		private void PaintCriteraPageState()
		{
			int intOrganisationID = UserContext.UserData.OrgID; // organisation ID
			BusinessServices.Course objCourse = new BusinessServices.Course(); //Course Object
			DataTable dtbCourses = objCourse.GetCourseListAccessableToOrg(intOrganisationID); // List of courses accesable to the organisation
			if (dtbCourses.Rows.Count==0)
			{
				this.plhSearchCriteria.Visible=false;
				this.lblError.Text=ResourceManager.GetString("lblError.NoCourse");//"No courses exist within this organisation.";
				this.lblError.CssClass = "FeedbackMessage";
				this.lblError.Visible=true;
				return;
			}
			cboCourse.DataSource = dtbCourses;
			cboCourse.DataValueField = "CourseID";
			cboCourse.DataTextField = "Name";
			cboCourse.DataBind();
			

			//3. setup date control
			WebTool.SetupHistoricDateControl(this.lstFromDay, this.lstFromMonth, this.lstFromYear);
			WebTool.SetupHistoricDateControl(this.lstToDay, this.lstToMonth, this.lstToYear);
		}

		private void ShowReport()
		{
			//1.Gather criteria
			// Get the selected units
			// string  strParentUnits  = String.Join(",",this.trvUnitsSelector.GetSelectedValues());
		
			// Get the selected course and Complete / Incomplete status
			string courseIDs = "" ;
			foreach( ListItem li in cboCourse.Items )
			{
				// if selection is made use only selected values
				if( cboCourse.SelectedItem != null )
				{
					if ( li.Selected == true )
						courseIDs += li.Value.ToString()+ ",";
				}
				else // use all values otherwise
				{					
					courseIDs += li.Value.ToString()+ ",";
				}
			}
			// remove last comma at the end of the string
			courseIDs.TrimEnd(',');

			// Gather date parts for historic date
			DateTime dtFrom;

			if ( (this.lstFromDay.SelectedValue.Length > 0) && (this.lstFromMonth.SelectedValue.Length > 0) && (this.lstFromYear.SelectedValue.Length > 0) )
			{
				dtFrom = new DateTime(int.Parse(this.lstFromYear.SelectedValue), int.Parse(this.lstFromMonth.SelectedValue), int.Parse(this.lstFromDay.SelectedValue));
			}
			else
			{
				dtFrom = System.Convert.ToDateTime("1/01/1997");
			}
			
			DateTime dtTo;

			if ( (this.lstToDay.SelectedValue.Length > 0) && (this.lstToMonth.SelectedValue.Length > 0) && (this.lstToYear.SelectedValue.Length > 0) )
			{
				dtTo = new DateTime(int.Parse(this.lstToYear.SelectedValue), int.Parse(this.lstToMonth.SelectedValue), int.Parse(this.lstToDay.SelectedValue));
			}
			else
			{
				dtTo = DateTime.Today;
			}

			int intIncludeInactive =0;
			if (chbInclInactiveUser.Checked)
			{
                intIncludeInactive =1;
			}

			//2. Add criteria to the report viewer
			Hashtable parameters = this.rvReport.Parameters;
			parameters["organisationID"] =  UserContext.UserData.OrgID;
			parameters["AdminUserID"] =  UserContext.UserID;

			parameters["courseIDs"] =  courseIDs;
			parameters["FromDate"] =  dtFrom.ToString("s");
			parameters["ToDate"] =  dtTo.ToString("s");
			parameters["IncludeInactive"] = intIncludeInactive;

			parameters["langCode"] = Request.Cookies["currentCulture"].Value;
			parameters["langInterfaceName"] = "Report.ActiveInactive";
		
		}
		#endregion

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
		}
		
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
