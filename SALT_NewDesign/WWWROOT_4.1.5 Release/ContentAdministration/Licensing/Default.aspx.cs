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

namespace Bdw.Application.Salt.Web.ContentAdministration.Licensing
{
	/// <summary>
	/// Summary description for _Default.
	/// </summary>
	public partial class _Default : System.Web.UI.Page
	{

		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");

			BusinessServices.Course objCourse = new BusinessServices.Course();
			DataTable dtCourses = objCourse.GetCourseListAccessableToOrg(UserContext.UserData.OrgID);
			rptLicense.DataSource = dtCourses;
			rptLicense.DataBind();

			panLicense.Visible = (dtCourses.Rows.Count > 0);

			if (dtCourses.Rows.Count == 0)
			{
				lblMessage.Text = ResourceManager.GetString("lblError.NoCourse");//"No courses exist within this organisation.";
				lblMessage.CssClass = "WarningMessage";
			}
		}

		protected void rptLicense_ItemDataBound(object sender, RepeaterItemEventArgs e)
		{
			if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				DataRowView drv = (DataRowView)e.Item.DataItem;
				int courseID = (int)drv["CourseID"];

				DataTable dtCurrent = BusinessServices.CourseLicensing.GetCurrentPeriod(UserContext.UserData.OrgID, courseID);
				DataTable dtFuture = BusinessServices.CourseLicensing.GetFuturePeriod(UserContext.UserData.OrgID, courseID);

				HtmlTableCell warningCell = (HtmlTableCell)e.Item.FindControl("warningCell");
				if (dtCurrent.Rows.Count > 0)
				{
					int courseLicensingID = Int32.Parse(dtCurrent.Rows[0]["CourseLicensingID"].ToString());

					Label lblDateCurrent = (Label)e.Item.FindControl("lblDateCurrent");
					lblDateCurrent.Text = 
						string.Format("{0:dd/MM/yyyy}", (DateTime)dtCurrent.Rows[0]["DateStart"]) 
						+ " - " + 
						string.Format("{0:dd/MM/yyyy}", (DateTime)dtCurrent.Rows[0]["DateEnd"]);
						
					warningCell.Attributes.Add("style", "background-color: #D2D2D2; width: 20px;");

					//-- Warning colours
					if (BusinessServices.CourseLicensing.IsExceed(courseLicensingID))
						warningCell.Attributes.Add("style", "background-color: red; width: 20px;");
					else if (BusinessServices.CourseLicensing.IsWarn(courseLicensingID))
						warningCell.Attributes.Add("style", "background-color: orange; width: 20px;");
					//-- /Warning colours
				}
				else
				{
					warningCell.InnerHtml = "X";
					warningCell.Attributes.Add("style", "background-color: #ffffff; font-weight: bold; width: 20px;");
				}

				if (dtFuture.Rows.Count > 0)
				{
					Label lblDateFuture = (Label)e.Item.FindControl("lblDateFuture");
					lblDateFuture.Text = 
						string.Format("{0:dd/MM/yyyy}", (DateTime)dtFuture.Rows[0]["DateStart"]) 
						+ " - " + 
						string.Format("{0:dd/MM/yyyy}", (DateTime)dtFuture.Rows[0]["DateEnd"]);
				}

			}
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
		}
		#endregion
	}
}
