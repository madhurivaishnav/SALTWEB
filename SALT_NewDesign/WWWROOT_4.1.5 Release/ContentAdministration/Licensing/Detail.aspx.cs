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
	/// Summary description for Detail.
	/// </summary>
	public partial class Detail : System.Web.UI.Page
	{
		/* 
		TODO: Add field lengths, 
		add license usage labels, 
						add date sent labels (also for Never).
		*/

		#region "PROPERTIES"
		private int currentID
		{
			get
			{
				if (ViewState["currentID"] != null)
					return (int)ViewState["currentID"];

				return 0;
			}
			set
			{
				ViewState.Add("currentID", value);
			}
		}

		private int futureID
		{
			get
			{
				if (ViewState["futureID"] != null)
					return (int)ViewState["futureID"];

				return 0;
			}
			set
			{
				ViewState.Add("futureID", value);
			}
		}

		private BusinessServices.CourseLicensing clFuture = new BusinessServices.CourseLicensing();
		private BusinessServices.CourseLicensing clCurrent = new BusinessServices.CourseLicensing();

		private DataTable dtCurrent = null;
		private DataTable dtFuture = null;

		#endregion

		#region "DECLARE CONTROLS"


//		protected Button butNewPeriod;
//		protected Button butDeletePeriod;
//		protected Button butSaveAll;

		#region "VALIDATION CONTROLS"
		
		#endregion
		

		//-- FUTURE

			protected Label lblFutureExpiryWarnSent;






		//-- /FUTURE


		//-- CURRENT


			//-- Warning email





			protected DropDownList ddlCurrentDateStartDay;
			protected DropDownList ddlCurrentDateStartMonth;
			protected DropDownList ddlCurrentDateStartYear;
				

		//-- /CURRENT

		//localize validation error messages
		    //protected CustomValidator rvFutureLicenseWarnNumber;



			//protected CustomValidator rvCurrentLicenseWarnNumber;


		//-- localize validation error messages

		#endregion

		//-- EVENTS
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			int courseID = Int32.Parse(Request.QueryString["CourseID"].ToString());
			
			BusinessServices.Course objCourse = new BusinessServices.Course();
            DataTable dt = objCourse.GetCourse(courseID, UserContext.UserData.OrgID);

			lblCourseName.Text = " - " + dt.Rows[0]["Name"].ToString();

			if (!IsPostBack)
				LoadPeriods();

			btnDeleteFuturePeriod.Attributes.Add("onclick", "return confirm('Delete?');");
		}

		private void initializeLocalizedErrorMessages()
		{
			validationSummary.HeaderText = ResourceManager.GetString("msgValidationSummary");                   //"* Save Unsuccessful"

			rfvFutureLicenseNumber.ErrorMessage = ResourceManager.GetString("rfvFutureLicenseNumber");			//"[Future License Period] Number of Licenses is required"
			rvFutureLicenseNumber.ErrorMessage = ResourceManager.GetString("rvFutureLicenseNumber");			//"[Future License Period] Number of Licenses must be a valid number"
			rvFutureLicenseWarnNumber.ErrorMessage = ResourceManager.GetString("rvFutureLicenseWarnNumber");	//"[Future License Period] Warning must be a number"
																													
			rfvFutureRepNameSalt.ErrorMessage = ResourceManager.GetString("rfvFutureRepNameSalt");				//"[Future License Period] Salt Rep Name is required"
			rfvFutureRepEmailSalt.ErrorMessage = ResourceManager.GetString("rfvFutureRepEmailSalt");			//"[Future License Period] Salt Rep Email is required" 
			revFutureRepEmailSalt.ErrorMessage = ResourceManager.GetString("revFutureRepEmailSalt");			//"[Future License Period] Salt Rep Email address is not in the correct format."		
																													
			rfvFutureRepNameOrg.ErrorMessage = ResourceManager.GetString("rfvFutureRepNameOrg");				//"[Future License Period] Org Rep Name is required"
			rfvFutureRepEmailOrg.ErrorMessage = ResourceManager.GetString("rfvFutureRepEmailOrg");				//"[Future License Period] Org Rep Email is required"
			revFutureRepEmailOrg.ErrorMessage = ResourceManager.GetString("revFutureRepEmailOrg");				//"[Future License Period] Org Rep Email address is not in the correct format."
																													
			rfvCurrentLicenseNumber.ErrorMessage = ResourceManager.GetString("rfvCurrentLicenseNumber");		//"[Current License Period] Number of Licenses is required"
			rvCurrentLicenseNumber.ErrorMessage = ResourceManager.GetString("rvCurrentLicenseNumber");			//"[Current License Period] Number of Licenses must be a valid number"
			rvCurrentLicenseWarnNumber.ErrorMessage = ResourceManager.GetString("rvCurrentLicenseWarnNumber");	//"[Current License Period] Warning must be a number"

			rfvCurrentRepNameSalt.ErrorMessage = ResourceManager.GetString("rfvCurrentRepNameSalt");			//"[Current License Period] Salt Rep Name is required"
			rfvCurrentRepEmailSalt.ErrorMessage = ResourceManager.GetString("rfvCurrentRepEmailSalt");			//"[Current License Period] Salt Rep Email is required"
			revCurrentRepEmailSalt.ErrorMessage = ResourceManager.GetString("revCurrentRepEmailSalt");			//"[Current License Period] Salt Rep Email address is not in the correct format."
																													
			rfvCurrentRepNameOrg.ErrorMessage = ResourceManager.GetString("rfvCurrentRepNameOrg");				//"[Current License Period] Org Rep Name is required"
			rfvCurrentRepEmailOrg.ErrorMessage = ResourceManager.GetString("rfvCurrentRepEmailOrg");			//"[Current License Period] Org Rep Email is required"			
			revCurrentRepEmailOrg.ErrorMessage = ResourceManager.GetString("revCurrentRepEmailOrg");			//"[Current License Period] Org Rep Email address is not in the correct format."			
		}

		private void LoadPeriods()
		{
			initializeLocalizedErrorMessages();

			int courseID = Int32.Parse(Request.QueryString["CourseID"].ToString());

			dtCurrent = BusinessServices.CourseLicensing.GetCurrentPeriod(UserContext.UserData.OrgID, courseID);
			dtFuture = BusinessServices.CourseLicensing.GetFuturePeriod(UserContext.UserData.OrgID, courseID);
				
			lblNoLicenses.Visible = false;

			if (dtCurrent.Rows.Count != 0)
			{	
				RenderCurrent(dtCurrent);
			}
			else
			{
				//	lblMessage.Text = "No current period exists for this course.";
				//	lblMessage.CssClass = "WarningMessage";
			}

			if (dtFuture.Rows.Count != 0)
			{
				RenderFuture(dtFuture);
			}
			else
			{
				btnNewLicensePeriod.Visible = true;				
				panFuture.Visible = false;
			}


			if ( panCurrent.Visible==false && panFuture.Visible==false )
			{
				lblNoLicenses.Visible = true;
			}
		}
		
		private void btnNewLicensePeriod_Click(object sender, EventArgs e)
		{
			RenderFuture(null);
			btnNewLicensePeriod.Visible = false;
			lblNoLicenses.Visible = false;
		}

		private void btnDeleteFuturePeriod_Click(object sender, EventArgs e)
		{
			BusinessServices.CourseLicensing.Delete(this.futureID);

			this.futureID = 0;
			this.dtFuture = null;

			panFuture.Visible = false;
			btnNewLicensePeriod.Visible = true;

			if (panCurrent.Visible == false)
				btnSaveAll.Visible = false;
		}

		private void btnSaveAll_Click(object sender, EventArgs e)
		{   // how do we get this to show all error messages at once?

			setDependantValidations();
			Page.Validate();
			
			if (!this.IsValid) { return; }

			DateTime badDateTime = new DateTime(1900,1,1);

			if ( panFuture.Visible && clFuture.DateEnd.CompareTo(badDateTime)>0 )
			{
				BusinessServices.CourseLicensing.Save(clFuture);
				futureID = clFuture.CourseLicensingID;
			}

			if (panCurrent.Visible && clCurrent.DateEnd.CompareTo(badDateTime)>0)
			{
				BusinessServices.CourseLicensing.Save(clCurrent);
				currentID = clCurrent.CourseLicensingID;
			}

			BusinessServices.CourseLicensing.LicenseAuditByOrg(UserContext.UserData.OrgID);

			LoadPeriods();

			if (lblMessage.Text == string.Empty)
			{
				lblMessage.Text = "Save successful.";
				lblMessage.Attributes.Add("style", "color: #00cc00;");
			}
		}


		//-- RENDER
		private void RenderCurrent(DataTable dt)
		{
			if (dt != null && dt.Rows.Count> 0)
				this.currentID = (int)dt.Rows[0]["CourseLicensingID"];
			else
				this.currentID = 0;

			RenderPanel(dt, "Current");

			if (dt != null && dt.Rows.Count > 0)
			{

				DateTime dateLicenseWarnEmailSent = DateTime.Parse("1/1/1900");
				if ( ! DBNull.Value.Equals(dt.Rows[0]["DateLicenseWarnEmailSent"]) )
					dateLicenseWarnEmailSent = (DateTime)dt.Rows[0]["DateLicenseWarnEmailSent"];

				if (dateLicenseWarnEmailSent.CompareTo(DateTime.Parse("1/1/1900")) == 0)
					lblCurrentDateLicenseWarnEmailSent.Text = ResourceManager.GetString("msgNever");
				else
					lblCurrentDateLicenseWarnEmailSent.Text = string.Format("{0:dd/MM/yyyy}", dateLicenseWarnEmailSent);


				DateTime dateExpiryWarnEmailSent = DateTime.Parse("1/1/1900");
				if (dt.Rows[0]["DateExpiryWarnEmailSent"] != System.DBNull.Value)
					dateExpiryWarnEmailSent = (DateTime)dt.Rows[0]["DateExpiryWarnEmailSent"];


				if (dateExpiryWarnEmailSent.CompareTo(DateTime.Parse("1/1/1900")) == 0)
					lblCurrentDateExpiryWarnEmailSent.Text = ResourceManager.GetString("msgNever");
				else
					lblCurrentDateExpiryWarnEmailSent.Text = string.Format("{0:dd/MM/yyyy}", dateExpiryWarnEmailSent);
			}

			//-- Warning colours
			if (BusinessServices.CourseLicensing.IsExceed(this.currentID))
			{
				currentWarnCell.Attributes.Add("style", "background-color: red; width: 20px;");
			}
			else if (BusinessServices.CourseLicensing.IsWarn(this.currentID))
			{
				currentWarnCell.Attributes.Add("style", "background-color: orange; width: 20px;");
			}
			else
			{
				currentWarnCell.Attributes.Add("style", "background-color: #D2D2D2; width: 20px;");
			}
			//-- /Warning colours
			
			lblLicenseArchived.Text = BusinessServices.CourseLicensing.GetUsageArchived(this.currentID).ToString();
			lblLicenseUsed.Text = BusinessServices.CourseLicensing.GetUsage(this.currentID).ToString();
		}

		private void RenderFuture(DataTable dt)
		{
			RenderPanel(dt, "Future");

			if (dt != null && dt.Rows.Count> 0)
			{
				this.futureID = (int)dt.Rows[0]["CourseLicensingID"]; 
			}
			else
			{
				this.futureID = 0;
				//-- Clear controls and set the startdate to match end date of current, or todays date if there is no current!
				if (!panCurrent.Visible)
				{
					//-- Part clearing
					//ddlFutureDateStartDay.SelectedValue = ddlFutureDateStartMonth.SelectedValue = ddlFutureDateStartYear.SelectedValue = string.Empty;
					
					ddlFutureDateStartDay.SelectedValue  = DateTime.Now.Day.ToString();
					ddlFutureDateStartMonth.SelectedValue = DateTime.Now.Month.ToString();
					ddlFutureDateStartYear.SelectedValue = DateTime.Now.Year.ToString();
					
					txtFutureRepNameSalt.Text = txtFutureRepEmailSalt.Text = txtFutureRepNameOrg.Text = txtFutureRepEmailOrg.Text = string.Empty;
					
					//if (ddlFutureLangCode.Items.FindByValue("en-AU") != null)
					//{
					//	ddlFutureLangCode.SelectedValue = "en-AU";
					//}

					// Initially, try to use the current users language...
					if (ddlFutureLangCode.Items.FindByValue(Request.Cookies["currentCulture"].Value) != null)
					{
						ddlFutureLangCode.SelectedValue = Request.Cookies["currentCulture"].Value;
					}// if the current users language is not found, then try "en-AU"
					else if (ddlFutureLangCode.Items.FindByValue("en-AU") != null)
					{
						ddlFutureLangCode.SelectedValue = "en-AU";
					}// if en-AU is not found, then it will simply default 
					// to whatever is in the top of the list

					txtFutureLicenseNumber.Text = string.Empty;
					txtFutureLicenseWarnNumber.Text = string.Empty;
				}
				else
				{
					DateTime dt1 =GetDateFromDropDowns("Current","DateEnd");
					dt1 = dt1.AddDays(1); // dont do this //-> this reinstated as BD indicated behaviour they want
					//-- Prefilling from current period
					ddlFutureDateStartDay.SelectedValue = dt1.Day.ToString();
					ddlFutureDateStartMonth.SelectedValue = dt1.Month.ToString();
					ddlFutureDateStartYear.SelectedValue = dt1.Year.ToString();

					txtFutureRepNameSalt.Text = txtCurrentRepNameSalt.Text;
					txtFutureRepEmailSalt.Text = txtCurrentRepEmailSalt.Text;
					txtFutureRepNameOrg.Text = txtCurrentRepNameOrg.Text;
					txtFutureRepEmailOrg.Text = txtCurrentRepEmailOrg.Text;

					ddlFutureLangCode.SelectedValue = ddlCurrentLangCode.SelectedValue;

					txtFutureLicenseNumber.Text = txtCurrentLicenseNumber.Text;
					txtFutureLicenseWarnNumber.Text = txtCurrentLicenseWarnNumber.Text;
				}

				//-- Clear all other future controls
				ddlFutureDateEndDay.SelectedValue = ddlFutureDateEndMonth.SelectedValue = ddlFutureDateEndYear.SelectedValue = string.Empty;

				chkFutureLicenseWarnEmail.Checked = false;
				

				chkFutureExpiryWarnEmail.Checked = false;
				ddlFutureDateWarnDay.SelectedValue = ddlFutureDateWarnMonth.SelectedValue = ddlFutureDateWarnYear.SelectedValue = string.Empty;
			}
		}

		private void RenderPanel(DataTable dt, string currentFuture)
		{
			//-- Setup control visible and values
			((Panel)this.FindControl("pan" + currentFuture)).Visible = true;
			btnSaveAll.Visible = true;

			DropDownList ddlLangCode = (DropDownList)this.FindControl("ddl" + currentFuture + "LangCode");
			ddlLangCode.DataSource = Bdw.Application.Salt.App_Code.API.LangAPI.LanguageUserList();
			ddlLangCode.DataBind();
			

			DropDownList ddlDateStartDay = (DropDownList)this.FindControl("ddl" + currentFuture + "DateStartDay");
			DropDownList ddlDateStartMonth = (DropDownList)this.FindControl("ddl" + currentFuture + "DateStartMonth");
			DropDownList ddlDateStartYear = (DropDownList)this.FindControl("ddl" + currentFuture + "DateStartYear");

			if (ddlDateStartDay != null)
				Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(ddlDateStartDay, ddlDateStartMonth, ddlDateStartYear, System.DateTime.Today.Year, 5);

			DropDownList ddlDateEndDay = (DropDownList)this.FindControl("ddl" + currentFuture + "DateEndDay");
			DropDownList ddlDateEndMonth = (DropDownList)this.FindControl("ddl" + currentFuture + "DateEndMonth");
			DropDownList ddlDateEndYear = (DropDownList)this.FindControl("ddl" + currentFuture + "DateEndYear");
			Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(ddlDateEndDay, ddlDateEndMonth, ddlDateEndYear, System.DateTime.Today.Year, 5);

			DropDownList ddlDateWarnDay = (DropDownList)this.FindControl("ddl" + currentFuture + "DateWarnDay");
			DropDownList ddlDateWarnMonth = (DropDownList)this.FindControl("ddl" + currentFuture + "DateWarnMonth");
			DropDownList ddlDateWarnYear = (DropDownList)this.FindControl("ddl" + currentFuture + "DateWarnYear");
			Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(ddlDateWarnDay, ddlDateWarnMonth, ddlDateWarnYear, System.DateTime.Today.Year, 5);

			//-- Fill Values from DataTable
			if (dt != null && dt.Rows.Count > 0)
			{
				DataRow dr = dt.Rows[0];
				
				DateTime dateStart = (DateTime)dr["DateStart"];
				DateTime dateEnd = (DateTime)dr["DateEnd"];

				DateTime dateWarn = DateTime.Parse("1/1/1900");
				if (dr["DateWarn"] != System.DBNull.Value)
				{
					dateWarn = (DateTime)dr["DateWarn"];
					ddlDateWarnDay.SelectedValue = dateWarn.Day.ToString();
					ddlDateWarnMonth.SelectedValue = dateWarn.Month.ToString();
					ddlDateWarnYear.SelectedValue = dateWarn.Year.ToString();
				}

				((TextBox)this.FindControl("txt" + currentFuture + "LicenseNumber")).Text = dr["LicenseNumber"].ToString();
				

				//-- StartDate: StartDate for 'current', cannot be changed
				if (ddlDateStartDay == null)
					((Label)this.FindControl("lbl" + currentFuture + "DateStart")).Text = string.Format("{0:dd/MM/yyyy}", dateStart);
				else
				{
					ddlDateStartDay.SelectedValue = dateStart.Day.ToString();
					ddlDateStartMonth.SelectedValue = dateStart.Month.ToString();
					ddlDateStartYear.SelectedValue = dateStart.Year.ToString();
				}

				//-- End Date
				ddlDateEndDay.SelectedValue = dateEnd.Day.ToString();
				ddlDateEndMonth.SelectedValue = dateEnd.Month.ToString();
				ddlDateEndYear.SelectedValue = dateEnd.Year.ToString();

				//-- License Warning
				((CheckBox)this.FindControl("chk" + currentFuture + "LicenseWarnEmail")).Checked = (bool)dr["LicenseWarnEmail"];
				((TextBox)this.FindControl("txt" + currentFuture + "LicenseWarnNumber")).Text = dr["LicenseWarnNumber"].ToString();

				//-- Expiry Warning
				((CheckBox)this.FindControl("chk" + currentFuture + "ExpiryWarnEmail")).Checked = (bool)dr["ExpiryWarnEmail"];
				
				//-- Contact People
				((TextBox)this.FindControl("txt" + currentFuture + "RepNameSalt")).Text = dr["RepNameSalt"].ToString();
				((TextBox)this.FindControl("txt" + currentFuture + "RepEmailSalt")).Text = dr["RepEmailSalt"].ToString();

				((TextBox)this.FindControl("txt" + currentFuture + "RepNameOrg")).Text = dr["RepNameOrg"].ToString();
				((TextBox)this.FindControl("txt" + currentFuture + "RepEmailOrg")).Text = dr["RepEmailOrg"].ToString();

				// -- LangCode
				ddlLangCode.SelectedValue = dr["LangCode"].ToString();
			}
		}

		//-- VALIDATIONS

		private void setDependantValidations()
		{
			try 
			{
				if(  rfvFutureLicenseNumber.IsValid && rvFutureLicenseNumber.IsValid && Int32.Parse(txtFutureLicenseNumber.Text) >= 0) 
				{
					Int32.Parse(txtFutureLicenseNumber.Text);
					rvFutureLicenseWarnNumber.MaximumValue = txtFutureLicenseNumber.Text;
				}
			} 
			catch{}
			try 
			{
				if(  rfvCurrentLicenseNumber.IsValid && rvCurrentLicenseNumber.IsValid && Int32.Parse(txtCurrentLicenseNumber.Text) >= 0 ) 
				{
					rvCurrentLicenseWarnNumber.MaximumValue = Int32.Parse(txtCurrentLicenseNumber.Text).ToString();
				}
			} 
			catch{}
		}

		private void cvFutureValidation_ServerValidate(object sender, ServerValidateEventArgs value)
		{
			try {
				if(  rfvFutureLicenseNumber.IsValid && rvFutureLicenseNumber.IsValid && Int32.Parse(txtFutureLicenseNumber.Text) >= 0  ) {
					rvFutureLicenseWarnNumber.MaximumValue = Int32.Parse(txtFutureLicenseNumber.Text).ToString();
				}
			} catch	{}
			clFuture.CourseLicensingID = this.futureID;
			cvSharedValidation_ServerValidate(clFuture, "Future", sender, value);
		} 

		private void cvCurrentValidation_ServerValidate(object sender, ServerValidateEventArgs value)
		{
			try {
				if(  rfvCurrentLicenseNumber.IsValid && rvCurrentLicenseNumber.IsValid && Int32.Parse(txtCurrentLicenseNumber.Text) >= 0 ) {
					rvCurrentLicenseWarnNumber.MaximumValue = Int32.Parse(txtCurrentLicenseNumber.Text).ToString();
				}
			} catch{}
			clCurrent.CourseLicensingID = this.currentID;
			cvSharedValidation_ServerValidate(clCurrent, "Current", sender, value);
			clCurrent.DateStart = DateTime.Parse(this.lblCurrentDateStart.Text);
		}

		private void cvSharedValidation_ServerValidate(BusinessServices.CourseLicensing cl, string currentFuture, object sender, ServerValidateEventArgs value)
		{
			//-- Assign values
			cl.OrganisationID = UserContext.UserData.OrgID;
			cl.CourseID = Int32.Parse(Request.QueryString["CourseID"]);
			cl.RepNameSalt = ((TextBox)this.FindControl("txt" + currentFuture + "RepNameSalt")).Text;
			cl.RepEmailSalt = ((TextBox)this.FindControl("txt" + currentFuture + "RepEmailSalt")).Text;
			cl.RepNameOrg = ((TextBox)this.FindControl("txt" + currentFuture + "RepNameOrg")).Text;
			cl.RepEmailOrg = ((TextBox)this.FindControl("txt" + currentFuture + "RepEmailOrg")).Text;
			cl.LangCode = ((DropDownList)this.FindControl("ddl" + currentFuture + "LangCode")).SelectedValue;

			try { Int32.Parse(((TextBox)this.FindControl("txt" + currentFuture + "LicenseNumber")).Text); } 
			catch
			{ 
				value.IsValid = false; 
				return;  
			}
			cl.LicenseNumber = Int32.Parse(((TextBox)this.FindControl("txt" + currentFuture + "LicenseNumber")).Text);
			

			cl.LicenseWarnEmail = ((CheckBox)this.FindControl("chk" + currentFuture + "LicenseWarnEmail")).Checked;
 
			string currentFutureLicensePeriod = (currentFuture=="Current") ? ResourceManager.GetString("lblCurrentLicensePeriod") : ResourceManager.GetString("lblFutureLicensePeriod");

			string licenseWarnNumber = ((TextBox)this.FindControl("txt" + currentFuture + "LicenseWarnNumber")).Text;
			
			// If the warn licenses checkbox is checked, then can't have blank warning number.
			// also, dont need to recheck this, if it has been range (in)validated already.
			if( value.IsValid && cl.LicenseWarnEmail && licenseWarnNumber.Trim() == string.Empty )
			{
				((CustomValidator)sender).ErrorMessage = "[" + currentFutureLicensePeriod + "] " + ResourceManager.GetString("msgWarnEmailNumber"); 
				value.IsValid = false; 
				return;  
			}

// The range validator does part of the next bit already!
//			//If have a warning number, it must be between 1 and the number of licenses.
			if (value.IsValid && licenseWarnNumber.Trim() != string.Empty)
			{
				try 
				{
					if ( Int32.Parse(licenseWarnNumber) > 0 && Int32.Parse(licenseWarnNumber) <= cl.LicenseNumber)
					{
						cl.LicenseWarnNumber = Int32.Parse(licenseWarnNumber);
					}
					else
					{
						throw new Exception();
					}
				} 
				catch
				{ 
					
				}
			}


			//cl.ExpiryWarnEmail = chkFutureExpiryWarnEmail.Checked;
			CheckBox chkExpiryWarnEmail = (CheckBox)this.FindControl("chk" + currentFuture + "ExpiryWarnEmail");
			cl.ExpiryWarnEmail = chkExpiryWarnEmail.Checked;

			//-- startdate/enddate is a valid date
			DateTime todaysDate = new DateTime(DateTime.Now.Year,DateTime.Now.Month,DateTime.Now.Day);

			try 
			{ 
				cl.DateEnd = GetDateFromDropDowns(currentFuture, "DateEnd"); 
			}
			catch 
			{ 
				((CustomValidator)sender).ErrorMessage = "[" + currentFutureLicensePeriod + "] " + ResourceManager.GetString("msgEndDateFormat"); value.IsValid = false; return; 
			}

			// checking the start date only has to be done for future because you can not change current start date.
			if (currentFuture == "Future")
			{
				try { cl.DateStart = GetDateFromDropDowns(currentFuture, "DateStart"); }
				catch { ((CustomValidator)sender).ErrorMessage = "[" + currentFutureLicensePeriod + "] " + ResourceManager.GetString("msgStartDateFormat"); value.IsValid = false; return; }
				
				//-- future only, start date must be greater than or equal to todays date, and less than or equal to end date.
				if (!(cl.DateStart.CompareTo(todaysDate) >= 0 && cl.DateStart.CompareTo(cl.DateEnd) <= 0))
				{
					((CustomValidator)sender).ErrorMessage = "[" + currentFutureLicensePeriod + "] " + ResourceManager.GetString("msgStartDateAfterBefore"); 
					value.IsValid = false; return; 
				}
			}

			//end date must be greater than or equal to todays date.
			if (!(cl.DateEnd.CompareTo(todaysDate) >= 0))
			{
				((CustomValidator)sender).ErrorMessage = "[" + currentFutureLicensePeriod + "] " + ResourceManager.GetString("msgEndDateAfter"); 
				value.IsValid = false; 
				return; 
			}

			//-- if expiryWarningEmail checked, there must be a valid date for expiryDateWarn
			if ( chkExpiryWarnEmail.Checked
				|| ((DropDownList)this.FindControl("ddl" + currentFuture + "DateWarnYear")).SelectedValue != string.Empty
				|| ((DropDownList)this.FindControl("ddl" + currentFuture + "DateWarnMonth")).SelectedValue != string.Empty
				|| ((DropDownList)this.FindControl("ddl" + currentFuture + "DateWarnDay")).SelectedValue != string.Empty
				)
			{
                try 
				{
					DateTime dateNewWarn = GetDateFromDropDowns(currentFuture, "DateWarn"); 										
					cl.DateWarn = dateNewWarn;
				}
				catch { ((CustomValidator)sender).ErrorMessage = "[" + currentFutureLicensePeriod + "] " + ResourceManager.GetString("msgExpireEmailDateFormat"); value.IsValid = false; return; }

				//-- warn date must be greater than startdate, greater than todays date and less than end date if the warning checkbox is ticked.
		
				if ( currentFuture == "Future" || (currentFuture == "Current"  ) )
				{					
					if ( cl.DateWarn.CompareTo(cl.DateStart) < 0 || cl.DateWarn.CompareTo(cl.DateEnd) >= 0 || cl.DateWarn.CompareTo(DateTime.Now) < 0)
					{
						((CustomValidator)sender).ErrorMessage = "[" + currentFutureLicensePeriod + "] " + ResourceManager.GetString("msgExpireEmailDateBeforeAfter"); 
						value.IsValid = false; return; 
					}
				}
			}
		}

		private void cvFinalValidation_ServerValidate(object sender, ServerValidateEventArgs value)
		{
			//-- future.startdate must be greater than current.enddate
			if (panCurrent.Visible && panFuture.Visible && this.IsValid)
			{
				try 
				{ 
					DateTime currentEndDate = GetDateFromDropDowns("Current", "DateEnd"); 
					DateTime futureStartDate = GetDateFromDropDowns("Future", "DateStart");

					if (futureStartDate.CompareTo(currentEndDate) < 0)
					{	 
						((CustomValidator)sender).ErrorMessage = ResourceManager.GetString("msgStartEndDateOverlap"); value.IsValid = false; return;
					}
					else if (futureStartDate.CompareTo(currentEndDate) > 1)
					{
						lblMessage.Text += ResourceManager.GetString("msgStartEndDateGap");
						lblMessage.Attributes.Add("style", "color: orange;");
					}
				}
				catch 
				{
					//-- this should not happen as it is validated earlier in the validation order
					throw;
				}
			}
		}

		private DateTime GetDateFromDropDowns(string currentFuture, string controlSuffix)
		{
			return new DateTime(
				int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Year")).SelectedValue)
				, int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Month")).SelectedValue)
				, int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Day")).SelectedValue));
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
			this.btnNewLicensePeriod.Click+=new EventHandler(btnNewLicensePeriod_Click);
			this.btnDeleteFuturePeriod.Click+=new EventHandler(btnDeleteFuturePeriod_Click);
			this.btnSaveAll.Click+=new EventHandler(btnSaveAll_Click);

			this.cvFutureValidation.ServerValidate+=new ServerValidateEventHandler(cvFutureValidation_ServerValidate);
			this.cvCurrentValidation.ServerValidate+=new ServerValidateEventHandler(cvCurrentValidation_ServerValidate);
			this.cvFinalValidation.ServerValidate+=new ServerValidateEventHandler(cvFinalValidation_ServerValidate);
		}
		#endregion
	}
}
