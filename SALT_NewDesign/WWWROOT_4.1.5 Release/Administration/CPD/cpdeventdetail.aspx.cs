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
using System.Linq;
using System.IO;

namespace Bdw.Application.Salt.Web.Administration.CPD
{
    public partial class cpdeventdetail : System.Web.UI.Page
    {
        protected Localization.LocalizedCheckBox chkEnabled;
        protected System.Web.UI.WebControls.Panel panFuture;
        protected Localization.LocalizedLabel lblFuturePeriod;
        protected Localization.LocalizedButton btnSave;
        protected Localization.LocalizedLabel lblPolicyName;
        protected Localization.LocalizedLabel lblPoints;
        protected Localization.LocalizedButton lblUnitSaveAll;
        private static string DisplayType = String.Empty;
        private static string EventNameCheck = String.Empty;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            try
            {
                BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
                if (objOrganisation.GetOrganisationCPDAccess(UserContext.UserData.OrgID))
                {

                    pagTitle.InnerText = ResourceManager.GetString("pagTitle");

                    int EventID;
                    int EventPeriodID;
                    try
                    {
                        EventID = int.Parse(Session["EventID"].ToString());
                    }
                    catch
                    {
                        EventID = -1;
                    }
                    try
                    {

                        EventPeriodID = int.Parse(Session["EventPeriodID"].ToString());
                    }
                    catch
                    {
                        EventPeriodID = -1;
                    }

                    this.InitialisePage(EventID, EventPeriodID);

                    if (!Page.IsPostBack)
                    {

                        Session["PageIndex"] = 0;
                        PopulateDropdown(this.ddlCurrentDateStartDay, this.ddlCurrentDateStartMonth, this.ddlCurrentDateStartYear);
                        PopulateDropdown(this.ddlCurrentDateEndDay, this.ddlCurrentDateEndMonth, this.ddlCurrentDateEndYear);
                        PopulateDropdown(this.ddlFutureDateStartDay, this.ddlFutureDateStartMonth, this.ddlFutureDateStartYear);
                        PopulateDropdown(this.ddlFutureDateEndDay, this.ddlFutureDateEndMonth, this.ddlFutureDateEndYear);

						this.ddlCurrentDateStartDay.SelectedValue = System.DateTime.Today.Day.ToString();
                        this.ddlCurrentDateStartMonth.SelectedValue = System.DateTime.Today.Month.ToString();
                        this.ddlCurrentDateStartYear.SelectedValue = System.DateTime.Today.Year.ToString();


                        this.ddlCurrentDateEndDay.SelectedValue = System.DateTime.Today.Day.ToString();
                        this.ddlCurrentDateEndMonth.SelectedValue = System.DateTime.Today.Month.ToString();
                        this.ddlCurrentDateEndYear.SelectedValue = System.DateTime.Today.Year.ToString();
                        //By default "No Action" radiobutton checked if a new Event
                        if (EventID > 0) //Existing Event
                        {
                            LoadEvent(EventID, EventPeriodID);
                        }
                        else //New Event
                        {
                            this.rbNoAction.Checked = true;
                        }
                        SetSortOrder("LastName");
                        BindCPDProfile();
                        EventType();

                        var hours = Enumerable.Range(0, 24).Select(i => i.ToString());
                        var minutes = Enumerable.Range(0, 60).Select(i => i.ToString());
                        ddlCurrentDateStartHour.DataSource = hours;
                        ddlCurrentDateStartHour.DataBind();
                        ddlCurrentDateStartMinute.DataSource = minutes;
                        ddlCurrentDateStartMinute.DataBind();
                        ddlCurrentDateEndHour.DataSource = hours;
                        ddlCurrentDateEndHour.DataBind();
                        ddlCurrentDateEndMinute.DataSource = minutes;
                        ddlCurrentDateEndMinute.DataBind();
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

            catch (Exception ex)
            {
                //log exception to event log
                ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "cpdeventdetail.aspx.cs", "Page_Load", ex.Message);
            }
        }


        private void InitialisePage(int EventID, int EventPeriodID)
        {
            if (EventID > 0) //Existing Event
            {
                DataTable dtEvent = GetEvent(EventID, EventPeriodID);
                this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle") + " - " + dtEvent.Rows[0]["EventName"].ToString();


                if (IsCurrentPeriod(dtEvent))
                {
                    this.lblMultiPeriod.Text = ResourceManager.GetString("Current") + " " + ResourceManager.GetString("lblPeriod");
                    this.btnDeleteFuturePeriod.Visible = false;
                    this.btnNewEventPeriod.Visible = false;
                    this.btnSaveEvent.Visible = true;

                }
                else if (IsFuturePeriod(dtEvent))	//Future
                {
                    this.lblMultiPeriod.Text = ResourceManager.GetString("Future") + " " + ResourceManager.GetString("lblPeriod");
                    this.btnDeleteFuturePeriod.Visible = true;
                    this.btnNewEventPeriod.Visible = false;
                    this.btnSaveEvent.Visible = true;

                }
                else // Event with no periods
                {
                    this.lblMultiPeriod.Text = ResourceManager.GetString("New") + " " + ResourceManager.GetString("lblPeriod");
                    this.panPeriod.Visible = false;
                    this.btnDeleteFuturePeriod.Visible = false;
                    this.btnSaveEvent.Visible = false;
                    this.btnNewEventPeriod.Visible = true;
                    this.lblNoPeriod.Text = ResourceManager.GetString("NoPeriod");
                    this.lblNoPeriod.CssClass = "FeedbackMessage";
                }
                this.btnCancel.Visible = true;

            }
            else //New Event
            {
                this.lblPageTitle.Text = ResourceManager.GetString("Create") + " " + ResourceManager.GetString("New") + " " + ResourceManager.GetString("lblPageTitle");
                this.lblMultiPeriod.Text = ResourceManager.GetString("New") + " " + ResourceManager.GetString("lblPeriod");

                this.btnDeleteFuturePeriod.Visible = false;
                this.btnNewEventPeriod.Visible = false;
                this.btnCancel.Visible = true;

            }

            this.lblCurrentTo1.Text = ResourceManager.GetString("lblTo");
            this.lblFutureTo1.Text = ResourceManager.GetString("lblTo");
        }
        private void LoadEvent(int EventID, int EventPeriodID)
        {
            try
            {
                BusinessServices.Event objEvent = new BusinessServices.Event();
                DataTable dtEvent = objEvent.GetEvent(EventID, EventPeriodID, UserContext.UserData.OrgID);
                this.txtEventName.Text = dtEvent.Rows[0]["EventName"].ToString();
                EventNameCheck = dtEvent.Rows[0]["EventName"].ToString();

                this.txtEventLocation.Text = dtEvent.Rows[0]["EventLocation"].ToString();
                this.txtEventProvider.Text = dtEvent.Rows[0]["EventProvider"].ToString();
                this.ddlEventType.SelectedValue = dtEvent.Rows[0]["EventType"].ToString();
                this.chkstatus.Checked = Boolean.Parse(dtEvent.Rows[0]["RegisterPoint"].ToString());
                this.chkallowuser.Checked = Boolean.Parse(dtEvent.Rows[0]["AllowUser"].ToString());
                this.ddlCPDProfile.SelectedValue = dtEvent.Rows[0]["ProfileID"].ToString();
                ViewState["EventID"] = EventID;
                ViewState["EventPeriodID"] = EventPeriodID;
                if (Request.QueryString["IsCopy"] != "copy")
                    EventFileList();

                if (this.panPeriod.Visible == true)
                {
                    if (!dtEvent.Rows[0]["datestart"].Equals(System.DBNull.Value))
                    {
                        DateTime dtStart = (DateTime)dtEvent.Rows[0]["datestart"];
                        this.ddlCurrentDateStartDay.SelectedValue = dtStart.Day.ToString();
                        this.ddlCurrentDateStartMonth.SelectedValue = dtStart.Month.ToString();
                        this.ddlCurrentDateStartYear.SelectedValue = dtStart.Year.ToString();
                        this.ddlCurrentDateStartHour.SelectedValue = dtStart.Hour.ToString();
                        this.ddlCurrentDateStartMinute.SelectedValue = dtStart.Minute.ToString();
                    }
                    if (!dtEvent.Rows[0]["dateend"].Equals(System.DBNull.Value))
                    {
                        DateTime dtStart = (DateTime)dtEvent.Rows[0]["dateend"];
                        this.ddlCurrentDateEndDay.SelectedValue = dtStart.Day.ToString();
                        this.ddlCurrentDateEndMonth.SelectedValue = dtStart.Month.ToString();
                        this.ddlCurrentDateEndYear.SelectedValue = dtStart.Year.ToString();
                        this.ddlCurrentDateEndHour.SelectedValue = dtStart.Hour.ToString();
                        this.ddlCurrentDateEndMinute.SelectedValue = dtStart.Minute.ToString();
                    }
                    if (!dtEvent.Rows[0]["Points"].Equals(System.DBNull.Value))
                    {
                        this.txtCurrentPoints.Text = dtEvent.Rows[0]["Points"].ToString();
                    }

                    string strEndOfPeriodAction = dtEvent.Rows[0]["EndOfPeriodAction"].ToString();
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
                            if (!dtEvent.Rows[0]["MonthIncrement"].Equals(System.DBNull.Value))
                            {
                                this.txtMonth.Text = dtEvent.Rows[0]["MonthIncrement"].ToString();
                            }
                            break;
                        case "4":
                            this.rbNewFuturePeriod.Checked = true;
                            resetMonth();
                            if (!dtEvent.Rows[0]["futuredatestart"].Equals(System.DBNull.Value))
                            {
                                DateTime dtStart = (DateTime)dtEvent.Rows[0]["futuredatestart"];
                                this.ddlFutureDateStartDay.SelectedValue = dtStart.Day.ToString();
                                this.ddlFutureDateStartMonth.SelectedValue = dtStart.Month.ToString();
                                this.ddlFutureDateStartYear.SelectedValue = dtStart.Year.ToString();
                            }
                            if (!dtEvent.Rows[0]["futuredateend"].Equals(System.DBNull.Value))
                            {
                                DateTime dtStart = (DateTime)dtEvent.Rows[0]["futuredateend"];
                                this.ddlFutureDateEndDay.SelectedValue = dtStart.Day.ToString();
                                this.ddlFutureDateEndMonth.SelectedValue = dtStart.Month.ToString();
                                this.ddlFutureDateEndYear.SelectedValue = dtStart.Year.ToString();
                            }
                            if (!dtEvent.Rows[0]["FuturePoints"].Equals(System.DBNull.Value))
                            {
                                this.txtFuturePoints.Text = dtEvent.Rows[0]["FuturePoints"].ToString();
                            }
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "cpdeventdetail.aspx.cs", "LoadEvent", ex.Message);
            }
        }
        protected void btnSaveEvent_Click(object sender, System.EventArgs e)
        {
            try
            {

                this.cvCurrentPoints.Validate();
                this.cvCurrentDate.Validate();


                int EventID;

                int EventPeriodID;
                try
                {
                    EventID = int.Parse(Session["EventID"].ToString());
                }
                catch
                {
                    EventID = -1;
                }
                try
                {
                    EventPeriodID = int.Parse(Session["EventPeriodID"].ToString());
                }
                catch
                {
                    EventPeriodID = -1;
                }
                if (Request.QueryString["IsCopy"] == "copy")
                {
                    EventID = -1;
                    EventPeriodID = -1;
                }
                if (!this.IsValid && (EventID < 0))
                {
                    return;
                }
                else if (!this.IsValid)
                {
                    return;
                }

                this.lblNoPeriod.Text = String.Empty;
                BusinessServices.Event objEvent = new BusinessServices.Event();
                objEvent = GetEventValues();

                int OrganisationID = UserContext.UserData.OrgID;
                string ProfileName = this.txtEventName.Text;

                DataTable dtEventName = objEvent.CheckEventName(objEvent.EventName, OrganisationID, int.Parse(ddlCPDProfile.SelectedValue), EventPeriodID);
                //if (dtProfileName.Rows.Count > 0 && (ProfileNameCheck != ProfileName))
                if (dtEventName.Rows.Count > 0)
                {
                    this.lblMessage.Text += ResourceManager.GetString("EventExists");
                    this.lblMessage.CssClass = "WarningMessage";
                    return;

                }

                int CheckRowCount = 0;
                bool flagCanUpload = true;
                HttpFileCollection hfc = Request.Files;
                for (int i = 0; i < hfc.Count; i++)
                {
                    HttpPostedFile hpf = hfc[i];
                    if (hpf.ContentLength > 0)
                    {
                        DataTable dt = objEvent.CheckFileName(OrganisationID, hpf.FileName);
                        CheckRowCount = dt.Rows.Count;
                        if (CheckRowCount != 0)
                        {
                            // File with this name already exists for this organisation                           
                            flagCanUpload = false;

                            lblMessage.Text = ResourceManager.GetString("FileExists");
                            lblMessage.CssClass = "WarningMessage";
                            return;
                        }
                    }
                }
                if (Request.QueryString["IsCopy"] == "copy")
                {
                    EventID = 0;
                }
                if (EventID > 0) //Existing Event - update
                {
                    if (flagCanUpload)
                    {
                        objEvent.UpdateEvent(objEvent);
                        // EventPeriodID = objProfile.GetEventPeriodID(EventID);
                        Session["EventPeriodID"] = EventPeriodID;
                        UploadEventFile(EventPeriodID, true);
                        // objEvent.UpdateEventPeriodAccess(OrganisationID, EventPeriodID, objEvent.EventID);
                        panPeriod.Visible = true;
                        InitialisePage(EventID, EventPeriodID);
                        LoadEvent(EventID, EventPeriodID);
                        this.lblMessage.Text += ResourceManager.GetString("SaveSuccess");
                        this.lblMessage.CssClass = "SuccessMessage";
                    }
                }
                else // New Event - Add
                {
                    if (flagCanUpload)
                    {
                        EventID = objEvent.AddEvent(objEvent);
                        EventPeriodID = objEvent.EventPeriodID;

                        UploadEventFile(EventPeriodID, true);

                        // Assign the new values to session variables
                        Session["EventPeriodID"] = EventPeriodID;
                        Session["EventID"] = EventID;

                        // Initialize all units and users granted access to 0
                        //objEvent.InitialiseEventPeriodAccess(OrganisationID, objEvent.EventID, EventPeriodID);

                        panPeriod.Visible = true;
                        InitialisePage(EventID, EventPeriodID);
                        LoadEvent(EventID, EventPeriodID);

                        this.lblMessage.Text += ResourceManager.GetString("SaveSuccess");
                        this.lblMessage.CssClass = "SuccessMessage";

                    }
                }
            }
            catch (Exception ex)
            {

                ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "cpdeventdetail.aspx.cs", "btnSaveEvent_Click", ex.Message);
            }

        }
        private string GetFileName()
        {
            string FileName = Path.GetFileName(UploadFile.PostedFile.FileName);
            return FileName;
        }
        private long GetFileSize()
        {
            long lngFileLength = UploadFile.PostedFile.ContentLength;
            return lngFileLength;
        }
        private bool UploadEventFile(int EventPeriodID, bool checkFile)
        {
            int FileId;
            bool UploadStatus = false;
            if ((UploadFile.PostedFile != null) && (UploadFile.PostedFile.ContentLength > 0))
            {

                BusinessServices.Event objEvent = new BusinessServices.Event();

                int OrganisationID = UserContext.UserData.OrgID;
                string SaveDir = Server.MapPath(@"\General") + @"\CPDEvent\" + UserContext.UserData.OrgID.ToString();


                //Check that the directory exists - if it doesn't then create it
                if (!Directory.Exists(SaveDir))
                {
                    Directory.CreateDirectory(SaveDir);
                }

                try
                {

                    HttpFileCollection hfc = Request.Files;
                    for (int i = 0; i < hfc.Count; i++)
                    {
                        HttpPostedFile hpf = hfc[i];
                        if (hpf.ContentLength > 0)
                        {

                            System.IO.FileInfo file = new System.IO.FileInfo(hpf.FileName);
                            string fname = file.Name.Remove((file.Name.Length - file.Extension.Length));
                            objEvent.FileName = fname;
                            fname = fname + file.Extension;
                            hpf.SaveAs(SaveDir + @"\" + fname);
                            objEvent.EventPeriodID = EventPeriodID;
                            objEvent.FileName = fname;
                            FileId = objEvent.AddEventFile(objEvent);


                        }
                    }
                }
                catch (Exception ex)
                {
                    //log exception to event log
                    ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "cpdeventdetail.aspx.cs", "UploadEventFile", ex.Message);

                    //display friendly message to user
                    lblMessage.Text = ResourceManager.GetString("UploadFail");
                    lblMessage.CssClass = "WarningMessage";
                }


            }
            else
            {
                lblMessage.Text = ResourceManager.GetString("NoUploadFile");
                lblMessage.CssClass = "WarningMessage";
            }
            return UploadStatus;
        }
        protected void btnCancel_Click(object sender, System.EventArgs e)
        {
            Response.Redirect(@"\Administration\CPD\cpdevent.aspx");
        }
        private BusinessServices.Event GetEventValues()
        {
            BusinessServices.Event objEvent = new BusinessServices.Event();
            int EventID;
            try
            {
                EventID = int.Parse(Session["EventID"].ToString());
            }
            catch
            {
                EventID = -1;
            }

            if (EventID > 0) // Set EventID if existing Event
            {
                objEvent.EventID = EventID;
            }

            int EventPeriodID;
            try
            {
                EventPeriodID = int.Parse(Session["EventPeriodID"].ToString());
            }
            catch
            {
                EventPeriodID = -1;
            }
            if (EventPeriodID > 0)
            {
                objEvent.EventPeriodID = EventPeriodID;
            }

            // Get values from controls

            objEvent.UserID = 0;
            objEvent.OrganisationID = UserContext.UserData.OrgID;
            objEvent.EventName = this.txtEventName.Text.ToString();
            objEvent.ProfileID = int.Parse(ddlCPDProfile.SelectedValue);
            objEvent.EventProvider = this.txtEventProvider.Text.ToString();
            objEvent.EventType = int.Parse(ddlEventType.SelectedValue);
            objEvent.EventLocation = this.txtEventLocation.Text.ToString();
            objEvent.RegisterPoint = this.chkstatus.Checked;
            objEvent.AllowUser = this.chkallowuser.Checked;
			objEvent.EventItem = "";
            objEvent.UserType = 0;
            try
            {
                objEvent.DateStart = GetDateFromDropDowns("CurrentDate", "Start");


            }
            catch
            {
                objEvent.DateStart = DateTime.Parse("1/1/1900");
            }
            try
            {
                objEvent.DateEnd = GetDateFromDropDowns("CurrentDate", "End");
            }
            catch
            {
                objEvent.DateEnd = DateTime.Parse("1/1/1900");
            }
            if (this.txtCurrentPoints.Text.Length > 0)
            {
                objEvent.Points = double.Parse(this.txtCurrentPoints.Text.ToString());
            }
            objEvent.EndOfPeriodAction = GetEndOfPeriodAction();
            switch (objEvent.EndOfPeriodAction)
            {
                case "1":
                    //reset future period info
                    objEvent.FutureDateStart = DateTime.Parse("1/1/1900");
                    objEvent.FutureDateEnd = DateTime.Parse("1/1/1900");
                    objEvent.FuturePoints = 0.0;
                    objEvent.MonthIncrement = 0;
                    break;
                case "2": //Automatic increment by current period duration
                    //Get the duration of current period in days (End Date - Start Date)
                    TimeSpan ts = objEvent.DateEnd - objEvent.DateStart;
                    int differenceInDays = ts.Days;
                    //Set Future Start Date to be day after Current Period End Date
                    objEvent.FutureDateStart = objEvent.DateEnd.AddDays(1);
                    //Set Future End Date to be Future Start Date + duration period
                    objEvent.FutureDateEnd = objEvent.FutureDateStart.AddDays(Convert.ToDouble(differenceInDays));
                    //Set Future Points value to equal Current Points Value
                    objEvent.FuturePoints = objEvent.Points;
                    break;
                case "3": //Automatic increment by set month period
                    //Get month value specified by user
                    int month = Convert.ToInt32(this.txtMonth.Text.ToString());
                    //Set Future Start Date to be day after Current Period End Date
                    objEvent.FutureDateStart = objEvent.DateEnd.AddDays(1);
                    //Set Future End Date to be Future Start Date + month value specified by user
                    objEvent.FutureDateEnd = objEvent.FutureDateStart.AddMonths(month);
                    objEvent.FutureDateEnd = objEvent.FutureDateEnd.AddDays(-1);
                    // Month increment value
                    objEvent.MonthIncrement = Int32.Parse(this.txtMonth.Text);
                    //Set Future Points value to equal Current Points Value
                    objEvent.FuturePoints = objEvent.Points;
                    break;
                case "4": //New user defined Future Period
                    //Set Future Start Date to be date specified by user
                    objEvent.FutureDateStart = GetDateFromDropDowns("FutureDate", "Start");
                    //Set Future End Date to be date specified by user
                    objEvent.FutureDateEnd = GetDateFromDropDowns("FutureDate", "End");
                    //Set Future Points value to be value specified by user
                    objEvent.FuturePoints = double.Parse(this.txtFuturePoints.Text.ToString());
                    break;
            }

            return objEvent;
        }
        protected void EventFileList()
        {
            BusinessServices.Event objEvent = new BusinessServices.Event();
            DataTable dtEvent = objEvent.GetEventFileName(int.Parse(ViewState["EventID"].ToString()), int.Parse(ViewState["EventPeriodID"].ToString()));
			if (dtEvent.Rows.Count > 0)
            {
                gvFile.DataSource = dtEvent;
                gvFile.DataBind();
            }
        }
        private bool IsCurrentPeriod(DataTable dtPeriod)
        {
            bool PeriodCurrent = false;
            if (dtPeriod.Rows[0]["datestart"] != System.DBNull.Value)
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
            if (dtPeriod.Rows[0]["datestart"] != System.DBNull.Value)
            {
                DateTime dtDateStart = (DateTime)dtPeriod.Rows[0]["datestart"];
                if (dtDateStart > DateTime.Now)
                {
                    PeriodFuture = true;
                }
            }
            return PeriodFuture;
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
            //Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(Day, Month, Year, 2006, (System.DateTime.Today.Year - 2006) + 5);
			Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(Day, Month, Year, System.DateTime.Today.Year, 2);
        }
        private DataTable GetEvent(int EventID, int EventPeriodID)
        {
            BusinessServices.Event objEvent = new BusinessServices.Event();
            DataTable dtEvent = objEvent.GetEvent(EventID, EventPeriodID, UserContext.UserData.OrgID);
            return dtEvent;
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
        protected void btnNewEventPeriod_Click(object sender, System.EventArgs e)
        {
            this.lblNoPeriod.Text = String.Empty;
            this.panPeriod.Visible = true;
            this.rbNoAction.Checked = true;
            this.btnSaveEvent.Visible = true;
            this.btnNewEventPeriod.Visible = false;
        }
        private string GetEndOfPeriodAction()
        {
            string EndOfPeriodAction = "1";

            if (this.rbNoAction.Checked) { EndOfPeriodAction = "1"; }
            if (this.rbAutoIncrementAsCurrent.Checked) { EndOfPeriodAction = "2"; }
            if (this.rbAutoIncrementByMonth.Checked) { EndOfPeriodAction = "3"; }
            if (this.rbNewFuturePeriod.Checked) { EndOfPeriodAction = "4"; }

            return EndOfPeriodAction;
        }
        private DateTime GetDateFromDropDowns(string currentFuture, string controlSuffix)
        {
            if (currentFuture == "FutureDate")
            {
                return new DateTime(
                int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Year")).SelectedValue)
                , int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Month")).SelectedValue)
                , int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Day")).SelectedValue));

            }
            else
            {
                return new DateTime(
                int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Year")).SelectedValue)
                , int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Month")).SelectedValue)
                , int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Day")).SelectedValue)
                , int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Hour")).SelectedValue)
                , int.Parse(((DropDownList)this.FindControl("ddl" + currentFuture + controlSuffix + "Minute")).SelectedValue), 0);
            }


        }
        protected void btnDeleteFuturePeriod_Click(object sender, System.EventArgs e)
        {
            // Delete future period
            int EventID;
            try
            {
                EventID = int.Parse(Session["EventID"].ToString());
            }
            catch
            {
                EventID = -1;
            }
            BusinessServices.Event objEvent = new BusinessServices.Event();
            objEvent.DeleteFuturePeriod(EventID);
            Response.Redirect(@"\Administration\CPD\cpdevent.aspx");
        }
        private void EventType()
        {
            int OrganisationID = UserContext.UserData.OrgID;
            BusinessServices.Event objEvent = new BusinessServices.Event();

            DataTable dtPolicyPoints = objEvent.GetEventType(OrganisationID);

            if (dtPolicyPoints.Rows.Count == 0) //No policies exist - hide relevant controls and display message
            {
                ddlEventType.DataSource = dtPolicyPoints;
                ddlEventType.DataValueField = "EventTypeId";
                ddlEventType.DataTextField = "EventTypeName";
                ddlEventType.DataBind();

            }
            else //Bind to grid and calculate total points
            {
                ddlEventType.DataSource = dtPolicyPoints;
                ddlEventType.DataValueField = "EventTypeId";
                ddlEventType.DataTextField = "EventTypeName";
                ddlEventType.DataBind();
            }
        }
        private void BindCPDProfile()
        {
            int OrganisationID = UserContext.UserData.OrgID;
            BusinessServices.Event objProfile = new BusinessServices.Event();

            DataTable dtPolicyPoints = objProfile.GetProfileList(OrganisationID);

            if (dtPolicyPoints.Rows.Count > 0)
            {
                ddlCPDProfile.DataSource = dtPolicyPoints;
                ddlCPDProfile.DataValueField = "ProfileID";
                ddlCPDProfile.DataTextField = "ProfileName";
                ddlCPDProfile.DataBind();
            }
        }


        #region EventFile Edit

        protected void gvFile_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvFile.EditIndex = e.NewEditIndex;
            EventFileList();

        }
        // update event    
        protected void gvFile_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

            BusinessServices.Event objProfile = new BusinessServices.Event();
            FileUpload FileUpload1 = (FileUpload)gvFile.Rows[e.RowIndex].FindControl("FileUpload1");
            string path = Server.MapPath(@"\General") + @"\CPDEvent\" + UserContext.UserData.OrgID.ToString() + @"\";

            int OrganisationID = UserContext.UserData.OrgID;
            DataTable dt = objProfile.CheckFileName(OrganisationID, FileUpload1.FileName);
            int CheckRowCount = dt.Rows.Count;

            if (CheckRowCount != 0)
            {

                lblMessage.Text = ResourceManager.GetString("FileExists");
                lblMessage.CssClass = "WarningMessage";
                return;
            }
            string FileID = gvFile.DataKeys[e.RowIndex].Value.ToString();

            if (FileUpload1.HasFile)
            {
                FileUpload1.SaveAs(path + FileUpload1.FileName);
            }

            objProfile.FileID = int.Parse(FileID);
            objProfile.FileName = FileUpload1.FileName;
            objProfile.UpdateEventFile(objProfile);

            gvFile.EditIndex = -1;
            EventFileList();
        }
        // cancel edit event    
        protected void gvFile_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvFile.EditIndex = -1;
            EventFileList();
        }
        //delete event    
        protected void gvFile_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = (GridViewRow)gvFile.Rows[e.RowIndex];
            Label lbldeleteid = (Label)row.FindControl("lblImgId");
            Label lblDeleteImageName = (Label)row.FindControl("lblImageName");


            BusinessServices.Event objProfile = new BusinessServices.Event();
            objProfile.FileID = int.Parse(lbldeleteid.Text);
            objProfile.DeleteEventFile(objProfile);

            ImageDeleteFromFolder(lblDeleteImageName.Text);
            EventFileList();
        }

        protected void ImageDeleteFromFolder(string imagename)
        {
            string file_name = imagename;
            string path = Server.MapPath(@"\General") + @"\CPDEvent\" + UserContext.UserData.OrgID.ToString() + @"\" + imagename;
            FileInfo file = new FileInfo(path);
            if (file.Exists) //check file exsit or not  
            {
                file.Delete();
                lblMessage.Text = file_name + " file deleted successfully";
                lblMessage.ForeColor = System.Drawing.Color.Green;
            }
            else
            {
                lblMessage.Text = file_name + " This file does not exists ";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        #endregion

        #region Validation
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
                    if (args.IsValid)
                    {
                        // Start Date is after end date of Previous Period
                        DateTime dtFutureStart = GetDateFromDropDowns("FutureDate", "Start");
                        DateTime dtCurrentEnd = GetDateFromDropDowns("CurrentDate", "End");
                        if (dtFutureStart < dtCurrentEnd)
                        {
                            ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("PeriodOverlap");
                            args.IsValid = false;
                            return;
                        }
                        dtFutureStart = GetDateOnly(dtFutureStart);
                        dtCurrentEnd = GetDateOnly(dtCurrentEnd);
                        //Gap between end of current period and start of future period
                        TimeSpan ts = dtFutureStart.Subtract(dtCurrentEnd);
                        if (ts.Days > 1)
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
                dtStart = GetDateFromDropDowns(currentFuture, "Start");
            }
            catch
            {
                try
                {
                    dtEnd = GetDateFromDropDowns(currentFuture, "End");
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
                dtEnd = GetDateFromDropDowns(currentFuture, "End");
            }
            catch
            {
                try
                {
                    dtStart = GetDateFromDropDowns(currentFuture, "Start");
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
            dtStart = GetDateFromDropDowns(currentFuture, "Start");
            dtEnd = GetDateFromDropDowns(currentFuture, "End");
            if (dtStart > dtEnd)
            {
                ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("StartDateAfterEndDate");
                args.IsValid = false;
                return;
            }

            dtEnd = GetDateOnly(dtEnd);
            DateTime dtNow = GetDateOnly(DateTime.Now);

            // End Date is today or before				
            if (dtEnd < dtNow)
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

        protected void cvEventName_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            int EventID;
            int EventPeriodID;
            try
            {
                EventID = int.Parse(Session["EventID"].ToString());
            }
            catch
            {
                EventID = -1;
            }
            try
            {
                EventPeriodID = int.Parse(Session["EventPeriodID"].ToString());
            }
            catch
            {
                EventPeriodID = -1;
            }

            int OrganisationID = UserContext.UserData.OrgID;
            string EventName = this.txtEventName.Text;
            BusinessServices.Event objProfile = new BusinessServices.Event();
            if (ddlCPDProfile.SelectedValue != "")
            {
                DataTable dtEventName = objProfile.CheckEventName(EventName, OrganisationID, int.Parse(ddlCPDProfile.SelectedValue), EventPeriodID);
                //if (dtEventName.Rows.Count > 0 && (EventNameCheck != EventName))
                if (dtEventName.Rows.Count > 0)
                {
                    //Name already exists
                    ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("EventExists");
                    args.IsValid = false;
                    return;
                }
            }


            // No value entered for Profile Name
            string strProfileName = this.txtEventName.Text;
            if (strProfileName.Equals(String.Empty))
            {
                ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvProfileName");
                args.IsValid = false;
                return;
            }
        }

        protected void cvCPDProfile_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            string strCPDProfile = this.ddlCPDProfile.SelectedValue;
            if (strCPDProfile.Equals(String.Empty))
            {
                ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvcpdprofile");
                args.IsValid = false;
                return;
            }
        }
        protected void cvCPDEventType_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            string strCPDProfile = this.ddlCPDProfile.SelectedValue;
            if (strCPDProfile.Equals(String.Empty))
            {
                ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvCPDEventType");
                args.IsValid = false;
                return;
            }
        }
        protected void cvEventLocation_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {

            // No value entered for Profile Name
            string strEventLocation = this.txtEventLocation.Text;
            if (strEventLocation.Equals(String.Empty))
            {
                ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvEventLocation");
                args.IsValid = false;
                return;
            }
        }
        protected void cvEventProvider_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {

            // No value entered for Profile Name
            string strEventLocation = this.txtEventProvider.Text;
            if (strEventLocation.Equals(String.Empty))
            {
                ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvEventProvider");
                args.IsValid = false;
                return;
            }
        }
        protected void cvFuturePoints_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            // Check that rbNewFuturePeriod checked
            bool IsFuturePointsChecked = this.rbNewFuturePeriod.Checked;
            if (IsFuturePointsChecked)
            {
                // Get value in txtFuturePoints
                string strFuturePoints = this.txtFuturePoints.Text;

                // If empty then return validation message
                if (strFuturePoints.Equals(String.Empty))
                {
                    ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("FuturePointsNone");
                    args.IsValid = false;
                    return;
                }

                // If not numeric then return validation message
                if (!IsNumeric(strFuturePoints))
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
            if (strCurrentPoints.Equals(String.Empty))
            {
                ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvCurrentPoints");
                args.IsValid = false;
                return;
            }

            // If not numeric then return validation message
            if (!IsNumeric(strCurrentPoints))
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
            if (IsMonthChecked)
            {
                // Get value in txtMonth
                string strMonth = this.txtMonth.Text;

                // If empty then return validation message
                if (strMonth.Equals(String.Empty))
                {
                    ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("MonthNone");
                    args.IsValid = false;
                    return;
                }

                // If not numeric then return validation message
                if (!IsIntNumeric(strMonth))
                {
                    ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("cvCurrentDate_ServerValidate");
                    args.IsValid = false;
                    return;
                }
            }
        }

        private static bool IsNumeric(string strToCheck)
        {
            return Regex.IsMatch(strToCheck, "^\\d+(\\.\\d+)?$");
        }

        private static bool IsIntNumeric(string strToCheck)
        {
            return Regex.IsMatch(strToCheck, @"^[+]?[1-9]\d*\.?[0]*$");
        }



        private void SetSortOrder(string orderByField)
        {
            string strOldOrderByField, strOldOrderByDirection;
            string strOrderByDirection;

            // Get from viewstate
            strOldOrderByField = (string)ViewState["OrderByField"];
            strOldOrderByDirection = (string)ViewState["OrderByDirection"];

            // Compare to desired sort field
            if (strOldOrderByField == orderByField)
            {
                switch (strOldOrderByDirection.ToUpper())
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
        #endregion

    }
}
