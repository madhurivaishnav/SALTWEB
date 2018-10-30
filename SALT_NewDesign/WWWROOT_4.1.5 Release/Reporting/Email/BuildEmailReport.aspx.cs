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
using System.Text;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.ErrorHandler; 
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Web.Utilities;
using Uws.Framework.WebControl;
using System.Web.Mail;
using Localization;
using Bdw.Application.Salt.Utilities;
using tinyMCE;

namespace Bdw.Application.Salt.Web.Reporting.Email
{
	/// <summary>
	/// Summary description for BuildEmailReport.
	/// </summary>
	public partial class BuildEmailReport : System.Web.UI.Page
	{
	    #region Private Enumerations

		    /// <summary>
		    /// Enumeration of the Course Module Status
		    /// </summary>
		    private enum CourseModuleStatus
		    {
			    InComplete	= 0,
                Complete	= 1,
			    Failed		= 2,
			    NotStarted	= 3,
			    Expired_TimeLapsed	= 4,
				Expired_NewContent	= 5,
				Unknown = 6
		    }
		    private enum RecipientType
		    {
			    Administrators	= 1,
			    Users		= 2,
			    Unknown		= 3
		    }
	    #endregion

	    #region Protected Variables
    		
		// Criteria Page
        
        /// <summary>
        /// Treeview for selecting units
        /// </summary>
		protected Uws.Framework.WebControl.TreeView trvUnitsSelector;
        
        /// <summary>
        /// Drop down list to select course
        /// </summary>
		protected System.Web.UI.WebControls.ListBox cboCourses;

        /// <summary>
        /// Drop down list for custom classifications
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboCustomClassification;

        /// <summary>
        /// Label for displaying errors
        /// </summary>
		protected System.Web.UI.WebControls.Label lblError;

        /// <summary>
        /// Radio button list for selecting module status
        /// </summary>
		protected System.Web.UI.WebControls.RadioButtonList radCourseModuleStatus;

        /// <summary>
        /// Radio button list for selecting recipient type
        /// </summary>
		protected System.Web.UI.WebControls.RadioButtonList radRecipientType;

        /// <summary>
        /// Day Part of Date selector
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList lstToDay;
        
        /// <summary>
        /// Month Part of Date selector
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList lstToMonth;

        /// <summary>
        /// Year Part of Date selector
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList lstToYear;

        /// <summary>
        /// Day Part of Date selector
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList lstFromDay;

        /// <summary>
        /// Month Part of Date selector
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList lstFromMonth;

        /// <summary>
        /// Year Part of Date selector
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList lstFromYear;

        /// <summary>
        /// Button to generate email
        /// </summary>
		protected System.Web.UI.WebControls.Button btnEmailGenerate;

		// Results page	

        /// <summary>
        /// Placeholder surrounding search criteria
        /// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhSearchCriteria;

        /// <summary>
        /// Datagrid of results
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid dgrResults;

        /// <summary>
        /// Place holder surrounding results
        /// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhResults;

        /// <summary>
        /// Label showing total count of records
        /// </summary>
		protected System.Web.UI.WebControls.Label lblTotalRecordCount;

        /// <summary>
        /// Label showing number of records on current page
        /// </summary>
		protected System.Web.UI.WebControls.Label lblCurrentPageRecordCount;

        /// <summary>
        /// Label showing the number of pages
        /// </summary>
		protected System.Web.UI.WebControls.Label lblPageCount;

        /// <summary>
        /// Drop down list to jump to selected page
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboPage;

        /// <summary>
        /// Table surrounding pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTable tblPagination;

        /// <summary>
        /// Table row surrounding pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trPagination;

        /// <summary>
        /// Label for displaying status
        /// </summary>
		protected System.Web.UI.WebControls.Label lblStatus;

        /// <summary>
        /// Textbox containing user ids
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtUserIDs;

		/// <summary>
		/// Textbox containing user ids
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtMashup;

		/// <summary>
		/// Textbox containing admin ids
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtAdminIDs;

        /// <summary>
        /// Textbox containing email name
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtEmailFromName;

        /// <summary>
        /// Textbox containing from email name
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtEmailFromEmail;

        /// <summary>
        /// Textbox containing email subject
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtEmailSubject;

        /// <summary>
        /// Textbox containing email body
        /// </summary>
		protected TextEditor txtEmailBody;
    	
        /// <summary>
        /// User control for report criteria
        /// </summary>
        protected Bdw.Application.Salt.Web.General.UserControls.ReportCriteria ucCriteria;

        /// <summary>
        /// Placeholdering surrounding done section
        /// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhComplete;

		/// <summary>
		/// checkbox for include inactive
		/// </summary>
		protected System.Web.UI.WebControls.CheckBox chbInclInactiveUser;

	    #endregion

	    #region Constants
		    // ClassificationType Columns
		    private const string CTypeColumnName = "Name";
		    private const string CTypeColumnID = "ClassificationTypeID";

		    // classification Item columns
		    private const string CListColumnClassificationID = "ClassificationID";
		    private const string CListColumnClassificationTypeID = "ClassificationTypeID";
		    private const string CListColumnValue = "Value";
		    private const string CListColumnActive = "Active";
    			
		/// <summary>
		/// text box containing all user id's
		/// </summary>
        protected System.Web.UI.WebControls.TextBox txtAllUserIDs;
     
		    private const string cstrEmailUserCopySubject				= "Email Report Sent";
	    #endregion

	    #region Web Form Designer generated code

		    /// <summary>
		    /// 
		    /// </summary>
		    /// <param name="e"></param>
		    override protected void OnInit(EventArgs e)
		    {
			    //
			    // CODEGEN: This call is required by the ASP.NET Web Form Designer.
			    //
			    InitializeComponent();
			    base.OnInit(e);

				dgrResults.Columns[2].HeaderText = ResourceManager.GetString("UnitPathway");
				dgrResults.Columns[3].HeaderText = ResourceManager.GetString("cmnLastName");
				dgrResults.Columns[4].HeaderText = ResourceManager.GetString("cmnFirstName");

				radCourseModuleStatus.Items[0].Text = ResourceManager.GetString("radCourseModuleStatus.1");
				radCourseModuleStatus.Items[1].Text = ResourceManager.GetString("radCourseModuleStatus.2");
				radCourseModuleStatus.Items[2].Text = ResourceManager.GetString("radCourseModuleStatus.3");
				radCourseModuleStatus.Items[3].Text = ResourceManager.GetString("radCourseModuleStatus.4");
				radCourseModuleStatus.Items[4].Text = ResourceManager.GetString("radCourseModuleStatus.5");
				radCourseModuleStatus.Items[5].Text = ResourceManager.GetString("radCourseModuleStatus.6");

				radRecipientType.Items[0].Text = ResourceManager.GetString("radRecipientType.1");
				radRecipientType.Items[1].Text = ResourceManager.GetString("radRecipientType.2");
		    }
    		
    		
		    /// <summary>
		    /// Displays the appropriate form type when the page is loaded
		    /// </summary>
		    /// <param name="sender"></param>
		    /// <param name="e"></param>
		    protected void Page_Load(object sender, System.EventArgs e)
		    {
				pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			    // Put user code to initialize the page here
			    if (!(this.IsPostBack))
			    {
				    DisplayUnits();
				    DisplayCourses();
				    DisplayClassifications();
    					
				    SetupDateControl(lstToDay, lstToMonth, lstToYear, false);
				    SetupDateControl(lstFromDay, lstFromMonth, lstFromYear, false);
			    }
			    else
			    {
				    lblError.Text="";
			    }
		    }


		    /// <summary>
		    /// This methods handles the Initialise components event.
		    /// </summary>
		    private void InitializeComponent()
		    {    
				this.dgrResults.SortCommand += new System.Web.UI.WebControls.DataGridSortCommandEventHandler(this.dgrResults_SortCommand);
				this.dgrResults.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrResults_ItemDataBound);

			}

	    #endregion

	    #region Private Methods
		#region Stage One - Gathering Requirements

		/// <summary>
		/// This method displays all the units that the logged in use is an administrator of.
		/// </summary>
		private void DisplayUnits()
		{
			BusinessServices.Unit objUnit = new BusinessServices.Unit();
			DataSet dstUnits ;
    			
			// Get Units accessable to this user.
			try 
			{
				// Gets the units that the current user is an administrator of.
				dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID ,UserContext.UserID,'A');
				if (dstUnits.Tables[0].Rows.Count==0)
				{
					this.lblError.Text += "<BR>" + ResourceManager.GetString("lblError.NoUnit");
                    this.lblError.CssClass = "FeedbackMessage";
					this.plhSearchCriteria.Visible=false;
				}
				else
				{
					// Convert this to an xml string for rendering by the UnitTreeConverter.
					string strUnits = UnitTreeConvert.ConvertXml(dstUnits);
					// Change to the appropriate view and load the Units in
					this.trvUnitsSelector.LoadXml(strUnits);
				}
			}
			catch (Exception Ex)
			{
				// General Exception occured, log it
				ErrorLog objError = new ErrorLog(Ex,ErrorLevel.Medium,"BulkAssignUsers.aspx.cs","DisplayUnits","Displaying Units");
				throw (Ex);
			}
		}


		/// <summary>
		/// 
		/// </summary>
		private void DisplayCourses()
		{
			// Get Courses accessable to this organisation
			Course objCourse = new Course();
			try
			{
				DataTable dtbCourses = objCourse.GetCourseListAccessableToOrg(UserContext.UserData.OrgID);
				if (dtbCourses.Rows.Count==0)
				{
					lblError.Text +="<BR>" + ResourceManager.GetString("lblError.NoCourse");
                    this.lblError.CssClass = "WarningMessage";
					this.plhSearchCriteria.Visible=false;
				}
				else
				{
					// Bind data to the course control
					cboCourses.DataSource = dtbCourses;
					cboCourses.DataTextField = "Name";
					cboCourses.DataValueField ="CourseID";
					cboCourses.DataBind();
				}
			}
			catch (Exception ex)
			{
				ErrorLog objError = new ErrorLog(ex,ErrorLevel.High,"BuildEmailReport","DisplayCourses","Displaying Courses failed.");
				throw (ex);
			}
		}


		/// <summary>
		/// 
		/// </summary>
		private void DisplayClassifications()
		{
			try
			{
				// Get Classification Type for the dsiplayed user's organisation
				Classification objClassification = new BusinessServices.Classification();
				DataTable dtbClassificationType = objClassification.GetClassificationType(UserContext.UserData.OrgID);
            
				if (dtbClassificationType.Rows.Count > 0)
				{
					this.lblCustomClassification.Text = dtbClassificationType.Rows[0]["Name"].ToString();
					DataTable dtbClassificationList = objClassification.GetClassificationList((int) Convert.ToInt32(dtbClassificationType.Rows[0][CTypeColumnID].ToString()));
					// Add blank row to the datatable
					DataRow drwBlank;

					drwBlank = dtbClassificationList.NewRow();

					// Add a blank value
					drwBlank[CListColumnClassificationID] = 0;
					drwBlank[CListColumnClassificationTypeID] = 0;
					drwBlank[CListColumnValue] = ResourceManager.GetString("lblAny");
					drwBlank[CListColumnActive] = 1;

					dtbClassificationList.Rows.InsertAt(drwBlank, 0);
					this.cboCustomClassification.DataSource = dtbClassificationList;

					// Add blank item
					this.cboCustomClassification.DataTextField = CListColumnValue;
					this.cboCustomClassification.DataValueField = CListColumnClassificationID;
					this.cboCustomClassification.DataBind();
				}
				else
				{
					this.lblCustomClassification.Visible=false;
					this.cboCustomClassification.Visible=false;
				}
			}
			catch (Exception Ex)
			{
				ErrorLog objError = new ErrorLog (Ex,ErrorLevel.Medium,"BuildEmailReport.aspx.cs","DisplayClassifications","");
				throw (Ex);
			}
		}
    			

		/// <summary>
		/// This method setups up a date control to show todays date by default.
		/// </summary>
		/// <param name="objDayListbox">The listbox holding the Day part of the date</param>
		/// <param name="objMonthListbox">The listbox holding the Month part of the date</param>
		/// <param name="objYearListbox">The listbox holding the Year part of the date</param>
		/// <param name="bSetToStartOfYear">Boolean indicating if it should be set to select the start of the year</param>
		private void SetupDateControl(DropDownList objDayListbox, DropDownList objMonthListbox, DropDownList objYearListbox, bool bSetToStartOfYear)
		{
			objDayListbox.Items.Clear();
			objMonthListbox.Items.Clear();
			objYearListbox.Items.Clear();

			// Setup 'Effective' Date Controls
			objDayListbox.Items.Add("");
			for (int intDay=1; intDay<=31; intDay++)
			{
                objDayListbox.Items.Add (intDay.ToString());
            }
			objMonthListbox.Items.Add("");
			for (int intMonth=1; intMonth<=12; intMonth++)
			{
                objMonthListbox.Items.Add (intMonth.ToString());
            }
			objYearListbox.Items.Add("");
			for (int intYear=System.DateTime.Today.Year - 10; intYear!=System.DateTime.Today.Year + 1; intYear++)
			{
				ListItem itmEntry = new ListItem();
				itmEntry.Text = intYear.ToString();
				itmEntry.Value= intYear.ToString();

				objYearListbox.Items.Add (itmEntry);
				// Select the current year
				//if (intYear==System.DateTime.Today.Year)
				//{
					//itmEntry.Selected = true;
				//}
			}

			//Default date selection needs to be empty - Sushil
			objDayListbox.SelectedIndex = 0;
			objMonthListbox.SelectedIndex = 0;

			// Select the current Day and month
//            if (bSetToStartOfYear)
//            {
//                objDayListbox.SelectedIndex = 0;
//                objMonthListbox.SelectedIndex = 0;
//            }
//            else
//            {
//                objDayListbox.SelectedIndex = 0; //System.DateTime.Today.Day - 1;
//                objMonthListbox.SelectedIndex = 0; //System.DateTime.Today.Month - 1;
//            }
		}
    		

		
		/// <summary>
		/// This method will validate whether a part of dates is a valid range or not.
		/// </summary>
		/// <param name="objToDayListbox">The Day part of the upper daterange.</param>
		/// <param name="objToMonthListbox">The Month part of the upper daterange.</param>
		/// <param name="objToYearListbox">The Year part of the upper daterange.</param>
		/// <param name="objFromDayListbox">The Day part of the lower daterange.</param>
		/// <param name="objFromMonthListbox">The Month part of the lower daterange.</param>
		/// <param name="objFromYearListbox">The Year part of the lower daterange.</param>
		/// <returns></returns>
		private bool ValidateDateControl(DropDownList objToDayListbox,DropDownList objToMonthListbox,DropDownList objToYearListbox,DropDownList objFromDayListbox,DropDownList objFromMonthListbox,DropDownList objFromYearListbox)
		{
			string year, month,day;
			DateTime dtTo = DateTime.Today;
			DateTime dtFrom = new DateTime(1997,1,1);

			bool bRetVal = true;

		    try
		    {
				//Compose dtTo
				year = objToYearListbox.SelectedValue;
				month = objToMonthListbox.SelectedValue;
				day = objToDayListbox.SelectedValue;

//				if (year.Length ==0)
//					year = DateTime.Today.Year.ToString();
//				if (month.Length ==0)
//					month = DateTime.Today.Month.ToString();
//				if (day.Length==0)
//					day=DateTime.Today.Day.ToString();

				if (!(year.Length == 0 && month.Length == 0 && day.Length == 0))
				{
					try
					{
						dtTo = new DateTime(int.Parse(year), int.Parse(month), int.Parse(day));
					}
					catch
					{
						throw  new ArgumentOutOfRangeException();
					}					
				}

				year = objFromYearListbox.SelectedValue;
				month = objFromMonthListbox.SelectedValue;
				day = objFromDayListbox.SelectedValue;

//				if (year.Length ==0)
//					year = "1997";
//				if (month.Length ==0)
//					month = "1";
//				if (day.Length==0)
//					day="1";

				if (!(year.Length == 0 && month.Length == 0 && day.Length == 0))
				{
					try
					{
						dtFrom = new DateTime(int.Parse(year), int.Parse(month), int.Parse(day));
					}
					catch
					{
						throw new ArgumentOutOfRangeException();
					}					
				}

				//Cater for blank dates inputs - Sushil
				//-------------------------------------------------------------------------------
				//If no dates are specified, assume default dataes
//				if (objFromDayListbox.SelectedIndex=0 && objFromMonthListbox.SelectedIndex = 0 &&
//					objFromYearListbox.SelectedIndex = 0)
//				{
//					DateTime dtTo = new DateTime(1997,1,1);
//				}
//				else
//				{
//					// Gather date parts for To Day
//					int intToDay = Convert.ToInt32 (objToDayListbox.SelectedValue);
//					int intToMonth = Convert.ToInt32 (objToMonthListbox.SelectedValue);
//					int intToYear = Convert.ToInt32 (objToYearListbox.SelectedValue);
//					DateTime dtTo = new DateTime(intToYear, intToMonth, intToDay,23,59,29,999);
//				}
				//-------------------------------------------------------------------------------


			    // Gather date parts for FromDay
//			    int intFromDay = Convert.ToInt32 (objFromDayListbox.SelectedValue);
//			    int intFromMonth = Convert.ToInt32 (objFromMonthListbox.SelectedValue);
//			    int intFromYear = Convert.ToInt32 (objFromYearListbox.SelectedValue);
//			    DateTime dtFrom = new DateTime(intFromYear, intFromMonth, intFromDay,0,0,0,0);
        					
			    // Validate dates
			    if (dtTo.CompareTo(dtFrom) <= 0 )
			    {
				    // The 'To' date must be after the 'From' date
				    //throw  new ArgumentOutOfRangeException();
					bRetVal = false;
			    }
			    if (dtTo.Date.CompareTo(System.DateTime.Today.Date) >= 1)
			    {
				    // You cant report historically on the future
				    //throw  new ArgumentOutOfRangeException();
					bRetVal = false;
			    }
			    if (dtFrom.Date.CompareTo(System.DateTime.Today.Date) >= 1)
			    {
				    // You cant report historically on the future
				    //throw  new ArgumentOutOfRangeException();
					bRetVal = false;
			    }

			    return(bRetVal);
		    }
		    catch(System.ArgumentOutOfRangeException)
		    {
			    // The date is invalid
			    return (false);
		    }
		    catch(Exception Ex)
		    {
			    // Another error occurred, return false but also log it
			    lblError.Text=Ex.Message + Ex.StackTrace;
                this.lblError.CssClass = "WarningMessage";
			    ErrorLog Error = new ErrorLog(Ex,ErrorLevel.Medium,"BuildEmailReport.aspx.cs","ValidateDateControl","Date Invalid");
			    return (false);
		    }
	    }
    		
		/// <summary>
		/// This method captures the event associated with clicking the reset button.
		/// It returns the criteria form to its original state.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnReset_Click(object sender, System.EventArgs e)
		{
            // Re-call the same page so that the default search criteria values are shown
            Response.Redirect(Request.RawUrl);
        }

		/// <summary>
		/// This method generates the basic template for the email that is to be sent.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnGenerateEmail_Click(object sender, System.EventArgs e)
		{
			bool blnSuccess=true;
			string strUnitIDs="";
			string strEmailBody="";
    				
			lblError.Text="";
    	
			try
			{
				// Ensure that all will be selected initially
				ViewState["UserIDsHaveBeenPopulated"]=null;
				ViewState["MashupHasBeenPopulated"]=null;
				ViewState["AdminIDsHaveBeenPopulated"]=null;
				// Validate Units
                BusinessServices.Unit objUnit = new  BusinessServices.Unit();
                string[] astrUnitIDs = astrUnitIDs = objUnit.ReturnAdministrableUnitsByUserID( UserContext.UserID, UserContext.UserData.OrgID, trvUnitsSelector.GetSelectedValues() );
			
				// Comma seperate each Unit and put it into a single string.
				foreach (string strUnit in astrUnitIDs)
				{
					strUnitIDs+=strUnit + ",";
				}
                if (strUnitIDs.Length>0)
                {
                    strUnitIDs = strUnitIDs.Substring(0,strUnitIDs.Length-1);
                }
				
                ViewState["UnitIDs"] = strUnitIDs;
                
				
    				
				// Validate Dates
				if (!(ValidateDateControl(this.lstToDay,this.lstToMonth, this.lstToYear, this.lstFromDay, this.lstFromMonth, this.lstFromYear)))
				{
					blnSuccess=false;
					lblError.Text+="<BR>" + ResourceManager.GetString("lblError.InValidDate");
                    this.lblError.CssClass = "WarningMessage";
				}

				// Finished validating
				if (blnSuccess)
				{
					// Compile courseIDs list as CSV
					string courseIDs = "" ;
					foreach( ListItem li in cboCourses.Items )
					{
						if( cboCourses.SelectedItem != null )
						{
							if ( li.Selected == true )
								courseIDs += li.Value.ToString()+ ",";
						}
						else
						{					
							courseIDs += li.Value.ToString()+ ",";
						}
					}
					courseIDs.TrimEnd(',');

					// Get Courses and compile %COURSE_NAMES% string for substitution into email body (logged in user copy/email to admins)
					BusinessServices.Course objCourse = new BusinessServices.Course();
					ViewState["strCourseIDs"]= courseIDs;
                    DataTable dtbCourse = objCourse.GetSelectedCourses(courseIDs, UserContext.UserData.OrgID);
					string strCourseNames = "%COURSE_NAMES% as applicable from\n	";
					foreach(DataRow drwCourse in dtbCourse.Rows) 
						strCourseNames += drwCourse["Name"].ToString() + "\n	";
					strCourseNames = strCourseNames.Substring(0, strCourseNames.Length - 3);
					ViewState["strCourseNames"]= strCourseNames;
	
					// Get Custom Classifications
					if (cboCustomClassification.Visible==true)
					{
						// Classifications exist for this org
						ViewState["intCustomClassificationID"] = Convert.ToInt32(cboCustomClassification.SelectedValue);
					}
					else
					{
						// Classifications dont exist for this org
						ViewState["intCustomClassificationID"] = 0;
					}
    				
					// Get Course Module Status
					switch (radCourseModuleStatus.SelectedValue)
					{
						case "Complete":
						{
							ViewState["enuCourseModuleStatus"]=CourseModuleStatus.Complete;
							break;
						}
                       case "Incomplete":
                        {
                            ViewState["enuCourseModuleStatus"]=CourseModuleStatus.InComplete;
                            break;
                        }
						case "Failed":
						{
							ViewState["enuCourseModuleStatus"]=CourseModuleStatus.Failed;
							break;
						}
						case "Not Started":
						{
							ViewState["enuCourseModuleStatus"]=CourseModuleStatus.NotStarted;
							break;
						}
						case "Expired (Time Elapsed)":
						{
							ViewState["enuCourseModuleStatus"]=CourseModuleStatus.Expired_TimeLapsed;
							break;
						}
						case "Expired (New Content)":
						{
							ViewState["enuCourseModuleStatus"]=CourseModuleStatus.Expired_NewContent;
							break;
						}

					}
					// Get Recipient Type
					switch (radRecipientType.SelectedValue)
					{
						case "Administrators":
						{
							ViewState["enuRecipientType"] = RecipientType.Administrators;
							break;
						}
						case "Users":
						{
							ViewState["enuRecipientType"] = RecipientType.Users;
							break;
						}
					}
    				
					switch ((CourseModuleStatus)ViewState["enuCourseModuleStatus"])
					{
						case CourseModuleStatus.Complete:
						{
							if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Administrators)
							{
								strEmailBody = GetEmailBody(EmailReportType.Email_Report_Complete_To_Administrators);
							}
							if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Users)
							{
								strEmailBody =  GetEmailBody(EmailReportType.Email_Report_Complete_To_Users);
							}
							break;
						}
                        case CourseModuleStatus.InComplete:
                        {
                            if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Administrators)
                            {
                                strEmailBody = GetEmailBody(EmailReportType.Email_Report_InComplete_To_Administrators);
                            }
                            if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Users)
                            {
                                strEmailBody =  GetEmailBody(EmailReportType.Email_Report_InComplete_To_Users);
                            }
                            break;
                        }
						case CourseModuleStatus.Failed:
						{
							if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Administrators)
							{
								strEmailBody = GetEmailBody(EmailReportType.Email_Report_Failed_To_Administrators);
							}
							if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Users)
							{
								strEmailBody = GetEmailBody(EmailReportType.Email_Report_Failed_To_Users);
							}
							break;
						}
						case CourseModuleStatus.NotStarted:
						{
							if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Administrators)
							{
								strEmailBody = GetEmailBody(EmailReportType.Email_Report_Not_Started_Administrators);
							}
							if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Users)
							{
								strEmailBody =  GetEmailBody(EmailReportType.Email_Report_Not_Started_To_Users);
							}
							break;
						}
						case CourseModuleStatus.Expired_TimeLapsed:
						{
							if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Administrators)
							{
								strEmailBody = GetEmailBody(EmailReportType.Email_Report_Expired_Time_Elapsed_To_Administrators);
							}
							if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Users)
							{
								strEmailBody =  GetEmailBody(EmailReportType.Email_Report_Expired_Time_Elapsed_To_Users);
							}
							break;
						}
						case CourseModuleStatus.Expired_NewContent:
						{
							if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Administrators)
							{
								strEmailBody = GetEmailBody(EmailReportType.Email_Report_Expired_New_Content_To_Administrators);
							}
							if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Users)
							{
								strEmailBody =  GetEmailBody(EmailReportType.Email_Report_Expired_New_Content_To_Users);
							}
							break;
						}

					}
					// Get the date fields now that they are confirmed to be valid.
					ViewState["dtFrom"]=ConvertToDateTime(this.lstFromDay,this.lstFromMonth, this.lstFromYear,true);
					ViewState["dtTo"]= ConvertToDateTime(this.lstToDay,this.lstToMonth, this.lstToYear,false);
    				
					BusinessServices.User objUser = new BusinessServices.User();
					BusinessServices.Report objReport = new BusinessServices.Report();
					BusinessServices.AppConfig objAppConfig = new BusinessServices.AppConfig();

					// Get the application conffiguration details
					DataTable dtbAppConfig = objAppConfig.GetList();

					// Get the current users details.
                    DataTable dtbCurrentUserDetails = objUser.GetUser(UserContext.UserID);
    				
					// Setup email header
					string strEmailFromName = dtbCurrentUserDetails.Rows[0]["FirstName"].ToString() + " " + dtbCurrentUserDetails.Rows[0]["LastName"].ToString();
					string strEmailFromEmail =  dtbCurrentUserDetails.Rows[0]["Email"].ToString();
                    
					// Setup the email body
					string strAppName = "";
					foreach (DataRow drwAppConfig in dtbAppConfig.Rows)
					{
						if (drwAppConfig.ItemArray[0].ToString().ToUpper()=="APPNAME")
						{
							strAppName = drwAppConfig.ItemArray[1].ToString();
						}
					}
					strEmailBody = strEmailBody.Replace("%APP_NAME%", strAppName);
					strEmailBody = strEmailBody.Replace("%DATE_TO%",DateTime.Parse(ViewState["dtTo"].ToString()).ToLongTimeString() + " " + DateTime.Parse(ViewState["dtTo"].ToString()).ToString("dd/MM/yyyy"));
					strEmailBody = strEmailBody.Replace("%DATE_FROM%",DateTime.Parse(ViewState["dtFrom"].ToString()).ToLongTimeString() + " " + DateTime.Parse(ViewState["dtFrom"].ToString()).ToString("dd/MM/yyyy"));
					//strEmailBody = strEmailBody.Replace("%COURSE_NAME%", dtbCourse.Rows[0]["Name"].ToString());
					strEmailBody = strEmailBody.Replace("%ADMIN_NAME%",strEmailFromName);
    				
					// If user details were found
					if (dtbCurrentUserDetails.Rows.Count > 0)
					{
						// Salt administrators have no unit but other levels do
						// If the user has a unit
						if (dtbCurrentUserDetails.Rows[0]["UnitID"] != DBNull.Value)
						{
							// Get the unit details
							DataTable dtbCurrentUserUnit = objUnit.GetUnit(Int32.Parse(dtbCurrentUserDetails.Rows[0]["UnitID"].ToString()));
							if (dtbCurrentUserUnit.Rows.Count > 0)
							{
								strEmailBody = strEmailBody.Replace("%ADMIN_UNIT%",dtbCurrentUserUnit.Rows[0].ItemArray[1].ToString());
							}
						}
						else
						{
							strEmailBody = strEmailBody.Replace("%ADMIN_UNIT%","");
						}
					}	
					else
					{
						strEmailBody = strEmailBody.Replace("%ADMIN_UNIT%","");
					}
					// Populate the email fields
					this.txtEmailSubject.Text = strAppName + " Courses";
					this.txtEmailBody.Text = strEmailBody;
					this.txtEmailFromEmail.Text = strEmailFromEmail;
					this.txtEmailFromName.Text = strEmailFromName;
    			
					this.txtUserIDs.Text = "";
					this.txtAdminIDs.Text = "";
					this.txtMashup.Text = "";

					// start pagination of the data.
					StartPagination();					
				}
				else
				{
					// Search criteria must be shown again because validation failed
					this.plhSearchCriteria.Visible = true;
					this.plhResults.Visible = false;
				}
			}
			catch (Exception ex)
			{
				//Catch and throw error
				ErrorLog objError = new ErrorLog(ex,ErrorLevel.High,"BuildEmailReport.aspx.cs","btnGenerateEmail_Click","General error occurred attempting to generate email");
				throw (ex);
			}

    		
		}
		#endregion
    		
		#region State Two - Editing Email Template and Selecting Reciptients

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnBack_Click(object sender, System.EventArgs e)
		{
			Response.Redirect("BuildEmailReport.aspx");
		}

		#endregion
    	
		#region Stage Three - Sending Emails

		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnEmailSend_Click(object sender, EventArgs e)
		{
			// Email to the target user
			string strEmailToName="";
			string strEmailToEmail="";
			string strEmailFromName="";
			string strEmailFromEmail="";
			string strEmailSubject=this.txtEmailSubject.Text;
			string strUsers="";

            int userID = -1;
			this.lblError.Text="";
			// Email that goes to the currently logged in user
    		
			// Common to both email report types
			string strEmailUserCopyToEmail;
			string strEmailUserCopyToName;
			string strEmailUserCopyBody;
    		
			string strEmailUserCopySubject;

            // when its an administrative report only
			string strAdministratorsList="";

			BusinessServices.Email objEmail = new BusinessServices.Email();
			BusinessServices.Report objReport = new BusinessServices.Report();
			BusinessServices.Course objCourse = new BusinessServices.Course();
			// probably delete the next line
			BusinessServices.User objUser = new User();

            String strDateFrom = DateTime.Parse(ViewState["dtFrom"].ToString()).ToString("dd/MM/yyyy");
            String strDateTo = DateTime.Parse(ViewState["dtTo"].ToString()).ToString("dd/MM/yyyy");

			// Validate that the user has a valid recipient, subject and body.
			if ((((RecipientType) ViewState["enuRecipientType"] == RecipientType.Administrators && this.txtAdminIDs.Text.Length > 0) || ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Users && this.txtUserIDs.Text.Length > 0)) && this.txtEmailSubject.Text.Length > 0 && this.txtEmailBody.Text.Length > 0)
			{
				// For Users
				if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Users)
				{
					strEmailSubject = this.txtEmailSubject.Text;
					strEmailFromName = this.txtEmailFromName.Text;
					strEmailFromEmail = this.txtEmailFromEmail.Text;

					DataTable dtbEmailAddresses = objCourse.GetUserMashup(this.txtMashup.Text, this.txtUserIDs.Text);
    				
					// For each user in the table
					foreach(DataRow drwEmailAddress in dtbEmailAddresses.Rows)
					{
						// Get their Email Address
						strEmailToEmail = drwEmailAddress.ItemArray[3].ToString();

						// Get their Name
						strEmailToName = drwEmailAddress.ItemArray[0].ToString() + " " + drwEmailAddress.ItemArray[1].ToString();

                        userID = 0;
                        bool result = Int32.TryParse(drwEmailAddress.ItemArray[2].ToString(), out userID);

                        objEmail.SetEmailBody(this.txtEmailBody.Text, userID, "",strDateFrom, strDateTo, "", drwEmailAddress.ItemArray[4].ToString(), "", "", "");

                        strEmailSubject = objEmail.emailHeaderSub(strEmailSubject);
						// Attempt to send them an email
                        objEmail.SendEmail(strEmailToEmail, strEmailToName, strEmailFromEmail, strEmailFromName, null, null, strEmailSubject, ApplicationSettings.MailServer, UserContext.UserData.OrgID, userID);
						strUsers += "<BR>" + strEmailToName + "<BR>&nbsp;" + drwEmailAddress.ItemArray[4].ToString();
					}
    				
					// Send email to currently logged in user.
					strEmailUserCopyToEmail		= this.txtEmailFromEmail.Text;
					strEmailUserCopyToName		= this.txtEmailFromName.Text;
					strEmailUserCopyBody		= String.Format(ResourceManager.GetString("EmailUserCopyBody"), Utilities.ApplicationSettings.AppName, DateTime.Today.ToShortDateString(), this.txtEmailBody.Text, strUsers).Replace(@"\n", Environment.NewLine);
					strEmailUserCopySubject		= ResourceManager.GetString("EmailReportSent");

                    objEmail.setUserCopyEmailBody(strEmailUserCopyBody);
					objEmail.SendEmail(strEmailUserCopyToEmail, strEmailUserCopyToName,strEmailFromEmail, strEmailFromName,null,null,strEmailUserCopySubject,  ApplicationSettings.MailServer, UserContext.UserData.OrgID, UserContext.UserID);
					
					this.plhResults.Visible=false;
					this.plhComplete.Visible=true;
				}

				// For administrators
				if ((RecipientType) ViewState["enuRecipientType"] == RecipientType.Administrators)
				{
					string strUserList="";
					string strFirstName="";
					string strLastName="";
					bool bFirstTimeRound = true;
					int intCourseModuleStatus =(int)(CourseModuleStatus) ViewState["enuCourseModuleStatus"];
					int intCustomClassificationID =(int) ViewState["intCustomClassificationID"];
					int intIncludeInactive =(int) ViewState["intIncludeInactive"];
					DateTime dtTo = DateTime.Parse(ViewState["dtTo"].ToString());
					DateTime dtFrom = DateTime.Parse(ViewState["dtFrom"].ToString());
					DataTable dtbAdminMashup = objCourse.GetAdminMashup(UserContext.UserData.OrgID, ViewState["UnitIDs"].ToString(),ViewState["strCourseIDs"].ToString(), this.txtMashup.Text, this.txtAdminIDs.Text,intCustomClassificationID, intCourseModuleStatus, dtFrom,dtTo,intIncludeInactive);

					int intCurrentAdminUserID = -1;
					int intCurrentCourseID = -1;
					string strCurrentCourse = "";
					foreach (DataRow drwEntry in dtbAdminMashup.Rows)
					{
						if (bFirstTimeRound)
						{
							strEmailFromName = this.txtEmailFromName.Text;
							strEmailFromEmail = this.txtEmailFromEmail.Text;
							strEmailToName = drwEntry.ItemArray[2] + " " + drwEntry.ItemArray[3];
							strEmailToEmail = drwEntry.ItemArray[1].ToString(); // Administrators Email
							intCurrentAdminUserID = Int32.Parse(drwEntry.ItemArray[0].ToString());
							intCurrentCourseID = Int32.Parse(drwEntry.ItemArray[4].ToString());
							strCurrentCourse = drwEntry.ItemArray[5].ToString();
                            strFirstName = drwEntry.ItemArray[8].ToString();
                            strLastName = drwEntry.ItemArray[9].ToString();
                            userID = intCurrentAdminUserID;
                            bFirstTimeRound = false;
						}
						// Same Row - build user list
						if (intCurrentAdminUserID == Int32.Parse(drwEntry.ItemArray[0].ToString()) & intCurrentCourseID == Int32.Parse(drwEntry.ItemArray[4].ToString()))
						{
							strUserList += "<BR>&nbsp;" + drwEntry.ItemArray[6] + " " + drwEntry.ItemArray[7]  ;    
						}
						// Different Row - send email and reset user list
						if (intCurrentAdminUserID != Int32.Parse(drwEntry.ItemArray[0].ToString()) | intCurrentCourseID != Int32.Parse(drwEntry.ItemArray[4].ToString()))
						{
							strUserList += "<BR>";
							
                            bool result = Int32.TryParse(drwEntry.ItemArray[0].ToString(), out userID);
                            if(!result)
                            {
                                userID = intCurrentAdminUserID;
                            }

                            objEmail.SetEmailBody(this.txtEmailBody.Text, userID, strCurrentCourse, strDateFrom,strDateTo, strUserList, "", "", "", "");

                            strEmailSubject = objEmail.emailHeaderSub( this.txtEmailSubject.Text);
                            objEmail.SendEmail(strEmailToEmail, strEmailToName, strEmailFromEmail, strEmailFromName, null, null, strEmailSubject, ApplicationSettings.MailServer, UserContext.UserData.OrgID, userID);
    						
							// Save the name and email of this administrator for the copy that is sent
							// to the logged in user.
							strAdministratorsList += "<BR>" + strEmailToName + " (" + strCurrentCourse + ")";

							// Reset user list
                            strUserList = "<BR>&nbsp;";
                            strUserList += drwEntry.ItemArray[6] + " " + drwEntry.ItemArray[7] + "<BR>"; // FirstName + LastName
							// Get the next administrator/course combo
							intCurrentAdminUserID = Int32.Parse(drwEntry.ItemArray[0].ToString());
							intCurrentCourseID = Int32.Parse(drwEntry.ItemArray[4].ToString());
							strCurrentCourse = drwEntry.ItemArray[5].ToString();
							strEmailToName = drwEntry.ItemArray[2] + " " + drwEntry.ItemArray[3];
							strEmailToEmail = drwEntry.ItemArray[1].ToString(); // Administrators Email
                            strFirstName = drwEntry.ItemArray[8].ToString();
                            strLastName = drwEntry.ItemArray[9].ToString();

						}                        
					}
					
                    strEmailSubject = this.txtEmailSubject.Text;
                    
                    
                    // Send the email for the last row.
					if (strEmailToEmail != string.Empty)
					{
                        // Replace body content information
                        objEmail.SetEmailBody(this.txtEmailBody.Text, userID, strCurrentCourse,strDateFrom,strDateTo, strUserList, "", "", "", "");
                        strEmailSubject = objEmail.emailHeaderSub(strEmailSubject);
                        objEmail.SendEmail(strEmailToEmail, strEmailToName, strEmailFromEmail, strEmailFromName, null, null, strEmailSubject, ApplicationSettings.MailServer, UserContext.UserData.OrgID, userID);
    						
						// Save the name and email of this administrator for the copy that is sent
						// to the logged in user.
						strAdministratorsList += "<BR>" + strEmailToName + " (" + strCurrentCourse + ")";
					}

					strEmailUserCopyBody = String.Format(ResourceManager.GetString("EmailUserCopyBody"), Utilities.ApplicationSettings.AppName, DateTime.Today.ToShortDateString(), this.txtEmailBody.Text, strAdministratorsList).Replace(@"\\", @"\").Replace(@"\n", Environment.NewLine);
                    objEmail.setUserCopyEmailBody(strEmailUserCopyBody);
                    objEmail.SendEmail (this.txtEmailFromEmail.Text,this.txtEmailFromName.Text, this.txtEmailFromEmail.Text, this.txtEmailFromName.Text, null,null,ResourceManager.GetString("EmailReportSent"), ApplicationSettings.MailServer, UserContext.UserData.OrgID, UserContext.UserID);

					this.plhResults.Visible=false;
					this.plhComplete.Visible=true;
				}
    			
			}
			else
			{
				lblError.Text=ResourceManager.GetString("lblError.OneRecip");//"To send an email you must have at least one recipient, an email subject and an email body.";
				this.lblError.CssClass = "WarningMessage";
			}
		}


		/// <summary>
		/// 
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnBackToMain_Click(object sender, System.EventArgs e)
		{
			Response.Redirect("BuildEmailReport.aspx");
		}

		#endregion

        #region Other Methods
		/// <summary>
		/// Converts the selected date time into a datetime value
		/// </summary>
		/// <param name="objDayListbox">Listbox Containing the Day Values</param>
		/// <param name="objMonthListbox">Listbox Containing the Month Values</param>
		/// <param name="objYearListbox">Listbox Containing the Year Values</param>
		/// <param name="startOfDay">If true add the time 12:00AM otherwise 11:59PM</param>
		/// <returns></returns>
		private DateTime ConvertToDateTime(DropDownList objDayListbox, DropDownList objMonthListbox, DropDownList objYearListbox, bool startOfDay)
		{
			// Gather date parts for To Day
			int intDay = 0; //= Convert.ToInt16 (objDayListbox.SelectedValue);
			int intMonth= 0; //Convert.ToInt16 (objMonthListbox.SelectedValue);
			int intYear= 0; //Convert.ToInt16 (objYearListbox.SelectedValue);
			DateTime dtDateTime;
			if (startOfDay)
			{
				if (objDayListbox.SelectedValue.Length == 0)
					intDay = 1;
				else
					intDay = Convert.ToInt16 (objDayListbox.SelectedValue);

				if (objMonthListbox.SelectedValue.Length == 0)
					intMonth = 1;
				else
					intMonth = Convert.ToInt16 (objMonthListbox.SelectedValue);

				if (objYearListbox.SelectedValue.Length == 0)
					intYear = 1997;
				else
					intYear = Convert.ToInt16 (objYearListbox.SelectedValue);

				dtDateTime= new DateTime(intYear, intMonth, intDay,0,0,0,0);
			}
			else
			{
				if (objDayListbox.SelectedValue.Length == 0)
					intDay = DateTime.Today.Day;
				else
					intDay = Convert.ToInt16 (objDayListbox.SelectedValue);

				if (objMonthListbox.SelectedValue.Length == 0)
					intMonth = DateTime.Today.Month;
				else
					intMonth = Convert.ToInt16 (objMonthListbox.SelectedValue);

				if (objYearListbox.SelectedValue.Length == 0)
					intYear = DateTime.Today.Year;
				else
					intYear = Convert.ToInt16 (objYearListbox.SelectedValue);

				dtDateTime= new DateTime(intYear, intMonth, intDay,23,59,59,999);
			}
			return(dtDateTime);
		}

        #endregion
        #endregion
    	
	    #region Private Events

		    /// <summary>
		    /// 
		    /// </summary>
		    /// <param name="sender"></param>
		    /// <param name="e"></param>
		    private void dgrResults_ItemDataBound(object sender, DataGridItemEventArgs e)
		    {
			    // This event is triggered with ever row drawn by the datagrid
			    // but we only want to handle the data rows, not the headers etc. ********not sure about the new logic for admins
			    if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem || e.Item.ItemType == ListItemType.EditItem)
			    {
				    System.Web.UI.WebControls.CheckBox objCheckbox =(System.Web.UI.WebControls.CheckBox) e.Item.Cells[0].Controls[1];
					string[] astrUserIDs = txtUserIDs.Text.Split(',');
					if (radRecipientType.SelectedValue == "Administrators")
					{
						astrUserIDs = txtAdminIDs.Text.Split(',');
						objCheckbox.Attributes.Add("onClick","TreeView_ClickCheckBox('txtAdminIDs',this,'" + e.Item.Cells[1].Text +"');");
					}
					else
					{
						objCheckbox.Attributes.Add("onClick","TreeView_ClickCheckBox('txtUserIDs',this,'" + e.Item.Cells[1].Text +"');");
					}
				    objCheckbox.Checked=false;

				    foreach (string strUserID in astrUserIDs)
				    {
					    if (strUserID == e.Item.Cells[1].Text)
					    {
						    objCheckbox.Checked=true;
					    }
				    }
    				
			    }
		    }
    		

	    #endregion
    		
	   #region Pagination customisation (Change this section according to business logic)

		    /// <summary>
		    /// Start Pagination
		    /// </summary>
		    private void StartPagination()
		    {
			    //Initialize Pagination settings
			    ViewState["OrderByField"] = "";
			    ViewState["OrderByDirection"] = "";
			    this.SetPaginationOrder("UserName"); //this will be ignored

			    this.tblPagination.Visible = true;
			    this.ShowPagination(0);
		    }
    		

		    /// <summary>
		    /// Get Pagination Data
		    /// </summary>
		    /// <returns></returns>
		    private DataView GetPaginationData()
		    {
			    // Customize, and return DataView
			    // conduct search based on criteria
			    BusinessServices.Report objReport = new BusinessServices.Report();

			    string strUnitIDs = ViewState["UnitIDs"].ToString();
			    string strCourseIDs = ViewState["strCourseIDs"].ToString();
			    int intCustomClassificationID = Int32.Parse(ViewState["intCustomClassificationID"].ToString());
			    int intCourseModuleStatus =(int)(CourseModuleStatus) ViewState["enuCourseModuleStatus"];
			    DateTime dtTo = DateTime.Parse(ViewState["dtTo"].ToString());
			    DateTime dtFrom = DateTime.Parse(ViewState["dtFrom"].ToString());
				int intIncludeInactive =0;
				if (chbInclInactiveUser.Checked)
				{
					intIncludeInactive =1;
				}
				ViewState["intIncludeInactive"] = intIncludeInactive;
                /***********
                 * Update criteria tab.
                 * 
                 * *********/
                DataTable dtbUser = new User().GetUser(UserContext.UserID);
                if (dtbUser.Rows.Count>0)
                {
                    // Display Report Criteria
                    this.ucCriteria.Criteria.Add(ResourceManager.GetString("Reportrunby"),dtbUser.Rows[0]["LastName"].ToString()+ ", " + dtbUser.Rows[0]["FirstName"].ToString());
                    this.ucCriteria.Criteria.Add(ResourceManager.GetString("Reportrunat"),DateTime.Now.ToString("dd/MM/yyyy") + " " + DateTime.Now.ToLongTimeString());
                }
                if (trvUnitsSelector.GetSelectedValues().Length==0)
                {
                    this.ucCriteria.AddUnits(null); 
                }
                else
                {
                    this.ucCriteria.AddUnits(strUnitIDs);
                }
                this.ucCriteria.AddCourses(strCourseIDs); 
                this.ucCriteria.Criteria.Add(ResourceManager.GetString("CourseStatus"),radCourseModuleStatus.SelectedItem.Text);
                this.ucCriteria.Criteria.Add(ResourceManager.GetString("Recipients"), radRecipientType.SelectedValue);
                this.ucCriteria.Criteria.Add(ResourceManager.GetString("From"),dtFrom.ToString("dd/MM/yyyy"));
                this.ucCriteria.Criteria.Add(ResourceManager.GetString("To"), dtTo.ToString("dd/MM/yyyy"));
                this.ucCriteria.Render();

    			
    			
				if ((RecipientType)ViewState["enuRecipientType"] == RecipientType.Users)
				{
					DataTable dtbResults = objReport.GetEmailReportDistinctUsers(UserContext.UserData.OrgID, strUnitIDs,strCourseIDs, intCustomClassificationID, intCourseModuleStatus, dtFrom,dtTo,intIncludeInactive);
					// Only Populate it the first time
					if (ViewState["UserIDsHaveBeenPopulated"]==null)
					{
						foreach (DataRow drwUser in dtbResults.Rows)
						{
							this.txtUserIDs.Text += drwUser.ItemArray[0].ToString() + ",";
						}
						// remove trailing comma
						if (this.txtUserIDs.Text.Length > 0)
						{
							this.txtUserIDs.Text = this.txtUserIDs.Text.Substring(0,this.txtUserIDs.Text.Length-1);
						}
						ViewState["UserIDsHaveBeenPopulated"]="Yes";
					}
					DataTable dtbUsers = objReport.GetEmailReportUserSearch(UserContext.UserData.OrgID, strUnitIDs,strCourseIDs, intCustomClassificationID, intCourseModuleStatus, dtFrom,dtTo,intIncludeInactive);
					// Only Populate it the first time
					if (ViewState["MashupHasBeenPopulated"]==null)
					{
						foreach (DataRow drwMashup in dtbUsers.Rows)
						{
							this.txtMashup.Text += drwMashup.ItemArray[0].ToString() + ",";
						}
						// remove trailing comma
						if (this.txtMashup.Text.Length > 0)
						{
							this.txtMashup.Text = this.txtMashup.Text.Substring(0,this.txtMashup.Text.Length-1);
						}
						ViewState["MashupHasBeenPopulated"]="Yes";
					}
					lblError.Text=ResourceManager.GetString("lblError.Caution");;//"Caution: Sending many emails may impact server performance.";
					this.lblError.CssClass = "WarningMessage";
					return dtbResults.DefaultView;
				}
				else
				{
					DataTable dtbUsers = objReport.GetEmailReportUserSearch(UserContext.UserData.OrgID, strUnitIDs,strCourseIDs, intCustomClassificationID, intCourseModuleStatus, dtFrom,dtTo,intIncludeInactive);
					// Only Populate it the first time
					if (ViewState["MashupHasBeenPopulated"]==null)
					{
						foreach (DataRow drwMashup in dtbUsers.Rows)
						{
							this.txtMashup.Text += drwMashup.ItemArray[0].ToString() + ",";// + ":" + drwUser.ItemArray[6].ToString() + ",";
						}
						// remove trailing comma
						if (this.txtMashup.Text.Length > 0)
						{
							this.txtMashup.Text = this.txtMashup.Text.Substring(0,this.txtMashup.Text.Length-1);
						}
						ViewState["MashupHasBeenPopulated"]="Yes";
					}
					DataTable dtbResults = objReport.GetEmailReportToAdministrators(UserContext.UserData.OrgID, strUnitIDs,strCourseIDs, intCustomClassificationID, intCourseModuleStatus, dtFrom,dtTo,intIncludeInactive);
					// Only Populate it the first time
					if (ViewState["AdminIDsHaveBeenPopulated"]==null)
					{
						foreach (DataRow drwAdmin in dtbResults.Rows)
						{
							this.txtAdminIDs.Text += drwAdmin.ItemArray[0].ToString() + ",";
						}
						// remove trailing comma
						if (this.txtAdminIDs.Text.Length > 0)
						{
							this.txtAdminIDs.Text = this.txtAdminIDs.Text.Substring(0,this.txtAdminIDs.Text.Length-1);
						}
						ViewState["AdminIDsHaveBeenPopulated"]="Yes";
					}
					return dtbResults.DefaultView;
				}
		    }

	    #endregion 

	    #region Pagination Event Handlers (Don't make any changes to this section)	
    		
		    /// <summary>
		    /// Go to previous page.
		    /// </summary>
		    protected void btnPrev_Click(object sender, System.EventArgs e)
		    {
			    this.ShowPagination(this.dgrResults.CurrentPageIndex - 1);
		    }

		    /// <summary>
		    /// Go to next page.
		    /// </summary>
		    protected void btnNext_Click(object sender, System.EventArgs e)
		    {
			    this.ShowPagination(this.dgrResults.CurrentPageIndex + 1);
		    }

		    /// <summary>
		    /// Go to a specific page.
		    /// </summary>
		    protected void cboPage_SelectedIndexChanged(object sender, System.EventArgs e)
		    {
			    int intPageIndex;
			    intPageIndex = int.Parse(this.cboPage.SelectedValue);
			    this.ShowPagination(intPageIndex - 1);
		    }

		    /// <summary>
		    ///Sorts the data.
		    /// </summary>
		    private void dgrResults_SortCommand(object source, System.Web.UI.WebControls.DataGridSortCommandEventArgs e)
		    {
			    this.SetPaginationOrder(e.SortExpression);
			    this.ShowPagination(0);
		    }

		    /// <summary>
		    /// Sets the order by field.
		    /// </summary>
		    /// <param name="orderByField"> The field to order by.</param>
		    private void SetPaginationOrder(string orderByField)
		    {
			    string	strOldOrderByField, strOldOrderByDirection;
			    string  strOrderByDirection;

			    strOldOrderByField =(string)ViewState["OrderByField"];
			    strOldOrderByDirection =(string)ViewState["OrderByDirection"];
    			
			    //set the orderby direction.
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
		    /// <summary>
		    /// Show Paging Data.
		    /// </summary>
		    /// <param name="currentPageIndex"></param>
		    private void ShowPagination(int currentPageIndex)
		    {
			    //1. Get data
			    DataView  dvwPagination = this.GetPaginationData();

			    if (dvwPagination.Table.Rows.Count == 0)
			    {
				    this.lblError.Text=ResourceManager.GetString("lblError.NoUser");//"No users found.";
                    this.lblError.CssClass = "FeedbackMessage";
				    this.plhSearchCriteria.Visible=true;
				    this.plhResults.Visible=false;
			    }
			    else
			    {
				    this.plhSearchCriteria.Visible = false;
				    this.plhResults.Visible = true;
			    }
			    if(dvwPagination.Count <= ApplicationSettings.PageSize)
			    {
				    this.trPagination.Visible = false;
			    } 
			    else 
			    {
				    this.trPagination.Visible = true;
			    }
    			
			    if(dvwPagination.Count == 0)
			    {
				    this.tblPagination.Visible = false;
			    }

    			/*Requiring a multi-column sort in this instead,
				 *we let sql do it instead...
				 
			    //2. Sort Data
			    string strOrderByField;
			    string strOrderByDirection;
			    strOrderByField = (string)ViewState["OrderByField"];
			    strOrderByDirection = (string)ViewState["OrderByDirection"];

			    dvwPagination.Sort = strOrderByField + " " + strOrderByDirection;
				
				*/

			    //3. Set pagination panel
			    int intPageSize;
			    intPageSize = ApplicationSettings.PageSize ;
			    this.SetPaginationPanel(intPageSize, dvwPagination.Count, currentPageIndex);

			    //4. Bind Data
				// This is needed by the select all functionality
				if (this.txtAllUserIDs.Text.Length==0)
				{
					foreach (DataRow drwItem in dvwPagination.Table.Rows)
					{
						this.txtAllUserIDs.Text += drwItem.ItemArray[0].ToString() + ",";
					}
					if (this.txtAllUserIDs.Text.Length>0)
					{
						this.txtAllUserIDs.Text = (this.txtAllUserIDs.Text.Substring(0,this.txtAllUserIDs.Text.Length-1));
					}
				}

			    //5. Set the Key field for the DataGrid
			    dgrResults.DataKeyField = "UserID";
			    dgrResults.DataSource = dvwPagination;
			    dgrResults.PageSize = intPageSize;
			    dgrResults.CurrentPageIndex = currentPageIndex;
			    dgrResults.DataBind();
		    }

		    /// <summary>
		    /// Sets the pagination panel.
		    /// </summary>
		    /// <param name="pageSize"></param>
		    /// <param name="totalRecordCount"></param>
		    /// <param name="currentPageIndex"></param>
		    private void SetPaginationPanel(int pageSize, int totalRecordCount, int currentPageIndex)
		    {
			    //1. Get pagination info
			    int intPageSize;
			    int intTotalRecordCount;
			    int intPageCount;
			    int intCurrentPageStart;
			    int intCurrentPageEnd;
			    ListItem objItem;

			    intPageSize = pageSize;
			    intTotalRecordCount = totalRecordCount;
			    intPageCount = ((int)(intTotalRecordCount - 1) / intPageSize) + 1;
    			
			    //Page start record number
			    if(intTotalRecordCount!=0)
			    {
				    intCurrentPageStart = intPageSize * currentPageIndex + 1;
			    }
			    else
			    {
				    intCurrentPageStart = 0;
			    }
			    //Page end record number
			    if (currentPageIndex < intPageCount - 1)
			    {
				    intCurrentPageEnd =  intPageSize * (currentPageIndex + 1);
			    }
				    //Last page, the page record count is the remaining records
			    else
			    {
				    intCurrentPageEnd = intTotalRecordCount;
			    }		
			    //2. Set  pagination
			    //2.1 Set dropdown page selector
			    this.cboPage.Items.Clear();
			    for(int i = 1; i <=  intPageCount; i++)
			    {
				    objItem = new ListItem(i.ToString());
				    if (i == currentPageIndex + 1)
				    {
					    objItem.Selected = true;
				    }		
				    this.cboPage.Items.Add(objItem);
			    }
    			
			    //2.2 Set Page numbers
			    this.lblPageCount.Text = intPageCount.ToString();
			    this.lblCurrentPageRecordCount.Text = intCurrentPageStart.ToString() +" - " + intCurrentPageEnd.ToString();
			    this.lblTotalRecordCount.Text = intTotalRecordCount.ToString();
    			
			    //2.3 Disable prev, next buttons
			    this.btnPrev.Enabled = true;
			    this.btnNext.Enabled = true;
			    //First Page
			    if (currentPageIndex == 0)
			    {	
				    this.btnPrev.Enabled = false;
			    }
			    //Last Page
			    if (currentPageIndex == intPageCount - 1)
			    {	
				    this.btnNext.Enabled = false;
			    }
		    }
		    #endregion


		protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
		{
			if (chkSelectAll.Checked)
			{
				this.chkClearAll.Checked = false;
				this.txtUserIDs.Text = this.txtAllUserIDs.Text;
				StartPagination();
			}
			
		}


        private string GetEmailBody(EmailReportType emailReportType)
        {
            OrganisationConfig objOrgConfig = new OrganisationConfig();
            string strEmailBody="";

            switch (emailReportType)
            {
                case EmailReportType.Email_Report_Complete_To_Administrators:
                {
                    strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Report_Complete_To_Administrators");
                    break;
                }

                case EmailReportType.Email_Report_InComplete_To_Administrators:
                {
                    strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Report_InComplete_To_Administrators");
                    break;
                }

                case EmailReportType.Email_Report_Complete_To_Users:
                {
                    strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Report_Complete_To_Users");
                    break;
                }
                case EmailReportType.Email_Report_InComplete_To_Users:
                {
                    strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Report_InComplete_To_Users");
                    break;
                }
                case EmailReportType.Email_Report_Failed_To_Administrators:
                {
                    strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID, "Email_Report_Failed_To_Administrators");
                    break;
                }
                case EmailReportType.Email_Report_Failed_To_Users:
                {
                    strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Report_Failed_To_Users");
                    break;
                }
                case EmailReportType.Email_Report_Not_Started_Administrators:
                {
                    strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Report_Not_Started_Administrators");
                    break;
                }
                case EmailReportType.Email_Report_Not_Started_To_Users:
                {
                    strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Report_Not_Started_To_Users");
                    break;
                }

				case EmailReportType.Email_Report_Expired_Time_Elapsed_To_Administrators:
				{
					strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Report_Expired_Time_Elapsed_To_Administrators");
					break;
				}

				case EmailReportType.Email_Report_Expired_Time_Elapsed_To_Users:
				{
					strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Report_Expired_Time_Elapsed_To_Users");
					break;
				}

				case EmailReportType.Email_Report_Expired_New_Content_To_Administrators:
				{
					strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Report_Expired_New_Content_To_Administrators");
					break;
				}

				case EmailReportType.Email_Report_Expired_New_Content_To_Users:
				{
					strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Report_Expired_New_Content_To_Users");
					break;
				}

				case EmailReportType.Email_Report_Expired_To_Users:
				{
					strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Report_Expired_To_Users");
					break;
				}

            } // switch
            strEmailBody = strEmailBody.Replace("<BR>",Environment.NewLine);
            return (strEmailBody);
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

		protected void chkClearAll_CheckedChanged(object sender, System.EventArgs e)

		{
			if (chkClearAll.Checked)
			{
				this.chkSelectAll.Checked = false;
				this.txtUserIDs.Text = "";
				StartPagination();
			}
		
		}
	}
}