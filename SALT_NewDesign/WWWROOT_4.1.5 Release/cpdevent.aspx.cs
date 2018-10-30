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
    public partial class cpdevent1 : System.Web.UI.Page
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
        //override protected void OnInit(EventArgs e)
        //{
        //    //
        //    // CODEGEN: This call is required by the ASP.NET Web Form Designer.
        //    //
        //    InitializeComponent();
        //    base.OnInit(e);

        //}
        //private void InitializeComponent()
        //{
        //    this.txtCurrentPoints.TextChanged +=new EventHandler(txtCurrentPoints_TextChanged); 
        //}

        //void txtCurrentPoints_TextChanged(object sender, EventArgs e)
        //{
        //    if (int.Parse(txtCurrentPoints.Text) <= int.Parse(lblavailablepoint.Text))
        //    {

        //    }
        //    else
        //    {
        //        txtCurrentPoints.Text = "0";
        //    }

        //}
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
                    //int ProfileID;
                    //string EventName;
                    //int EventType;

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

                        this.ddlCurrentDateStartDay.SelectedValue = System.DateTime.Today.Day.ToString();
                        this.ddlCurrentDateStartMonth.SelectedValue = System.DateTime.Today.Month.ToString();
                        this.ddlCurrentDateStartYear.SelectedValue = System.DateTime.Today.Year.ToString();


                        this.ddlCurrentDateEndDay.SelectedValue = System.DateTime.Today.Day.ToString();
                        this.ddlCurrentDateEndMonth.SelectedValue = System.DateTime.Today.Month.ToString();
                        this.ddlCurrentDateEndYear.SelectedValue = System.DateTime.Today.Year.ToString();


                        SetSortOrder("LastName");
                        BindCPDProfile();
                        BindEventType();
                        checkAvailablepoint(EventID, EventPeriodID);
                        BusinessServices.Event objEvent = new BusinessServices.Event();
                        DataTable dtEvent = objEvent.GetEvent(EventID, EventPeriodID, UserContext.UserData.OrgID);
                        try
                        {
                            txtEventName.Text = dtEvent.Rows[0]["EventName"].ToString();
                            txtEventName.ReadOnly = true;
                            ddlCPDProfile.SelectedValue = dtEvent.Rows[0]["ProfileID"].ToString();
                            ddlCPDProfile.Enabled = false;
                            ddlEventType.SelectedValue = dtEvent.Rows[0]["EventType"].ToString();
                           // ddlEventType.Enabled = false;
                            ViewState["CurrentEventPoints"] = "0";
                        }
                        catch
                        { }
                        if (Session["Action"].ToString() == "Add")
                        {

                            EventID = -1;
                            EventPeriodID = -1;
                        }
                        //By default "No Action" radiobutton checked if a new Event
                        if (EventID > 0) //Existing Event
                        {
                            LoadEvent(EventID, EventPeriodID);
                        }

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
                ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "Usercpdevent.aspx.cs", "Page_Load", ex.Message);
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

                    this.btnSaveEvent.Visible = true;

                }
                else if (IsFuturePeriod(dtEvent))	//Future
                {
                    this.lblMultiPeriod.Text = ResourceManager.GetString("Future") + " " + ResourceManager.GetString("lblPeriod");

                    this.btnSaveEvent.Visible = true;

                }
                else // Event with no periods
                {
                    this.lblMultiPeriod.Text = ResourceManager.GetString("New") + " " + ResourceManager.GetString("lblPeriod");
                    this.panPeriod.Visible = false;

                    this.btnSaveEvent.Visible = false;

                    this.lblNoPeriod.Text = ResourceManager.GetString("NoPeriod");
                    this.lblNoPeriod.CssClass = "FeedbackMessage";
                }
                this.btnCancel.Visible = true;

            }
            else //New Event
            {
                this.lblPageTitle.Text = ResourceManager.GetString("Create") + " " + ResourceManager.GetString("New") + " " + ResourceManager.GetString("lblPageTitle");
                this.lblMultiPeriod.Text = ResourceManager.GetString("New") + " " + ResourceManager.GetString("lblPeriod");


                this.btnCancel.Visible = true;

            }

            this.lblCurrentTo1.Text = ResourceManager.GetString("lblTo");

        }
        private void LoadEvent(int EventID, int EventPeriodID)
        {
            try
            {
                BusinessServices.Event objEvent = new BusinessServices.Event();
                DataTable dtEvent = objEvent.GetEvent(EventID, EventPeriodID, UserContext.UserData.OrgID);
                if (dtEvent.Rows.Count > 0)
                {
                    this.txtEventName.Text = dtEvent.Rows[0]["EventName"].ToString();
                    EventNameCheck = dtEvent.Rows[0]["EventName"].ToString();
                    this.txtEventItem.Text = dtEvent.Rows[0]["EventItem"].ToString();
                    this.txtEventLocation.Text = dtEvent.Rows[0]["EventLocation"].ToString();
                    this.txtEventProvider.Text = dtEvent.Rows[0]["EventProvider"].ToString();
                    this.ddlEventType.SelectedValue = dtEvent.Rows[0]["EventType"].ToString();
                    // this.chkstatus.Checked = Boolean.Parse(dtEvent.Rows[0]["RegisterPoint"].ToString());
                    //this.chkallowuser.Checked = Boolean.Parse(dtEvent.Rows[0]["AllowUser"].ToString());
                    this.ddlCPDProfile.SelectedValue = dtEvent.Rows[0]["ProfileID"].ToString();
                    ViewState["EventID"] = EventID;
                    ViewState["EventPeriodID"] = EventPeriodID;
                    ViewState["CurrentEventPoints"] = dtEvent.Rows[0]["Points"].ToString(); ;
                    // if (Session["Action"] == "Edit")
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

                    }
                }
            }
            catch (Exception ex)
            {
                ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "Usercpdevent.aspx.cs", "LoadEvent", ex.Message);
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
                if (Session["Action"] == "Add")
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

                //DataTable dtEventName = objEvent.CheckEventName(objEvent.EventName, OrganisationID, int.Parse(ddlCPDProfile.SelectedValue), EventPeriodID);
                ////if (dtProfileName.Rows.Count > 0 && (ProfileNameCheck != ProfileName))
                //if (dtEventName.Rows.Count > 0)
                //{
                //    this.lblMessage.Text += ResourceManager.GetString("EventExists");
                //    this.lblMessage.CssClass = "WarningMessage";
                //    return;

                //}

                int CheckRowCount = 0;
                bool flagCanUpload = true;
                HttpFileCollection hfc = Request.Files;



                for (int i = 0; i < hfc.Count; i++)
                {
                    HttpPostedFile hpf = hfc[i];
                    if (hpf.FileName != "")
                    {
                        System.IO.FileInfo file = new System.IO.FileInfo(hpf.FileName);
                        string fname = file.Name.Remove((file.Name.Length - file.Extension.Length));
                        fname = fname + "~" + DateTime.Now.ToString("ddMMyyyy") + file.Extension;


                        if (hpf.ContentLength > 0)
                        {
                            DataTable dt = objEvent.CheckFileName(OrganisationID, fname);
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
                }

                if (EventID > 0) //Existing Event - update
                {
                    if (flagCanUpload)
                    {
                        objEvent.UpdateUserEvent(objEvent);
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
                        EventID = objEvent.AddUserEvent(objEvent);
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

                ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "Usercpdevent.aspx.cs", "btnSaveEvent_Click", ex.Message);
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

                            fname = fname + "~" + DateTime.Now.ToString("ddMMyyyyhhmmss") + file.Extension;
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
                    ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "Usercpdevent.aspx.cs", "UploadEventFile", ex.Message);

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
            Response.Redirect(@"\MyTraining.aspx");
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
            objEvent.UserID = UserContext.UserID;
            objEvent.OrganisationID = UserContext.UserData.OrgID;
            objEvent.EventName = this.txtEventName.Text.ToString();
            objEvent.ProfileID = int.Parse(ddlCPDProfile.SelectedValue);
            objEvent.EventProvider = this.txtEventProvider.Text.ToString();
            objEvent.EventType = int.Parse(ddlEventType.SelectedValue);
            objEvent.EventLocation = this.txtEventLocation.Text.ToString();
            objEvent.EventItem = this.txtEventItem.Text.ToString();
            objEvent.UserType = 1;
            // objEvent.RegisterPoint = this.chkstatus.Checked;
            // objEvent.AllowUser = this.chkallowuser.Checked;
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
        private void PopulateDropdown(DropDownList Day, DropDownList Month, DropDownList Year)
        {
            Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(Day, Month, Year, 2006, (System.DateTime.Today.Year - 2006) + 5);
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
            // this.rbNoAction.Checked = true;
            this.btnSaveEvent.Visible = true;
            //  this.btnNewEventPeriod.Visible = false;
        }
        private string GetEndOfPeriodAction()
        {
            string EndOfPeriodAction = "1";

            //if (this.rbNoAction.Checked) { EndOfPeriodAction = "1"; }
            //if (this.rbAutoIncrementAsCurrent.Checked) { EndOfPeriodAction = "2"; }
            //if (this.rbAutoIncrementByMonth.Checked) { EndOfPeriodAction = "3"; }
            //if (this.rbNewFuturePeriod.Checked) { EndOfPeriodAction = "4"; }

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
        //protected void btnDeleteFuturePeriod_Click(object sender, System.EventArgs e)
        //{
        //    // Delete future period
        //    int EventID;
        //    try
        //    {
        //        EventID = int.Parse(Session["EventID"].ToString());
        //    }
        //    catch
        //    {
        //        EventID = -1;
        //    }
        //    BusinessServices.Event objEvent = new BusinessServices.Event();
        //    objEvent.DeleteFuturePeriod(EventID);
        //    Response.Redirect(@"\Administration\CPD\cpdeventdefault.aspx");
        //}
        private void BindEventType()
        {
            int OrganisationID = UserContext.UserData.OrgID;
            BusinessServices.Event objEvent = new BusinessServices.Event();
            DataTable dtPolicyPoints = objEvent.GetEventType(OrganisationID);
            if (dtPolicyPoints.Rows.Count > 0) //No policies exist - hide relevant controls and display message
            {
                ddlEventType.DataSource = dtPolicyPoints;
                ddlEventType.DataValueField = "EventTypeId";
                ddlEventType.DataTextField = "EventTypeName";
                ddlEventType.DataBind();
            }
        }
        private void BindCPDProfile()
        {
            //int OrganisationID = UserContext.UserData.OrgID;
            //BusinessServices.Profile objProfile = new BusinessServices.Profile();
            //DataTable dtPolicyPoints = objProfile.GetProfileList(OrganisationID);
            //if (dtPolicyPoints.Rows.Count > 0)
            //{
            //    ddlCPDProfile.DataSource = dtPolicyPoints;
            //    ddlCPDProfile.DataValueField = "ProfileID";
            //    ddlCPDProfile.DataTextField = "ProfileName";
            //    ddlCPDProfile.DataBind();
            //}
            int UserID = UserContext.UserID;
            BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtProfileList = objUser.GetProfilePeriodList(UserID);
            if (dtProfileList.Rows.Count > 0)
            {
                ddlCPDProfile.DataSource = dtProfileList;
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
            try
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
            catch (Exception ex)
            {

                ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "Usercpdevent.aspx.cs", "gvFile_RowUpdating", ex.Message);
            }
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
            try
            {
                GridViewRow row = (GridViewRow)gvFile.Rows[e.RowIndex];
                Label lbldeleteid = (Label)row.FindControl("lblImgId");
                Label lblDeleteImageName = (Label)row.FindControl("lblImageName");


                BusinessServices.Event objProfile = new BusinessServices.Event();
                objProfile.FileID = int.Parse(lbldeleteid.Text);
                objProfile.DeleteEventFile(objProfile);

                FileDeleteFromFolder(lblDeleteImageName.Text);
                EventFileList();
            }
            catch (Exception ex)
            {
                ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "Usercpdevent.aspx.cs", "gvFile_RowDeleting", ex.Message);
            }
        }

        protected void FileDeleteFromFolder(string imagename)
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

            // No value entered for Profile Name
            string strEventName = this.txtEventName.Text;
            if (strEventName.Equals(String.Empty))
            {
                ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvProfileName");
                args.IsValid = false;
                return;
            }
        }

        protected void cvEventItem_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
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
            string EventItem = this.txtEventItem.Text;
            BusinessServices.Event objProfile = new BusinessServices.Event();

            DataTable dtEventName = objProfile.CheckEventItem(EventItem, EventID, EventPeriodID, UserContext.UserID);

            if (dtEventName.Rows.Count > 0)
            {

                ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("EventItemExists");
                args.IsValid = false;
                return;
            }

            string strEventItem = this.txtEventItem.Text;
            if (strEventItem.Equals(String.Empty))
            {
                ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvEventItem");
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
            //if (Session["Action"].ToString() == "Add")
            //{
            //    if (!(double.Parse(txtCurrentPoints.Text) <= double.Parse(lblavailablepoint.Text)))
            //    {
            //        ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvAvilablePoints");
            //        args.IsValid = false;
            //        return;
            //    }
            //}
            //else
            //{
            if (!(double.Parse(txtCurrentPoints.Text) <= (double.Parse(ViewState["CurrentEventPoints"].ToString()) + double.Parse(lblavailablepoint.Text))))
            {
                ((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvAvilablePoints");
                args.IsValid = false;
                return;
            }

            //}


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
        protected string GetFilename(string name)
        {
            if (String.IsNullOrEmpty(name))
            {
                return "";
            }
            else
            {
                string filename = name;

                if (name.Contains("~"))
                {
                    int underscoreIndex = name.LastIndexOf("~");
                    int dotIndex = name.LastIndexOf(".");
                    string newFilename = name.Substring(0, underscoreIndex);
                    newFilename += name.Substring(dotIndex);
                    filename = newFilename;
                }


                return filename;

            }
        }
        #endregion
        private void checkAvailablepoint(int EventID, int EventPeriodID)
        {
            BusinessServices.Event objEvent = new BusinessServices.Event();
            DataTable dtEvent = objEvent.CheckAvilableEventpoint(EventID, EventPeriodID, UserContext.UserData.OrgID, UserContext.UserID);
            if (dtEvent.Rows.Count > 0)
            {
                lblavailablepoint.Text = dtEvent.Rows[0]["Points"].ToString();
                lblavailablepoint.ForeColor = Color.Green;
            }
        }

    }
}
