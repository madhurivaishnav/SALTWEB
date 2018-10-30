using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Linq;

using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.Web.Utilities;
using System.Reflection;
using Localization;

namespace Bdw.Application.Salt.Web.Reporting
{
    public partial class PeriodicReportControl : System.Web.UI.UserControl
    {
        public global::System.Web.UI.WebControls.TextBox EveryHowMany;

        private int scheduleid;

        protected bool has2DateControls = false;

        protected int ccGridMainCount;

        public List<int> CCUsers
        {
            get
            {
                return Session["CCUsers"] == null ? null : (List<int>)Session["CCUsers"];
            }
            set
            {
                Session["CCUsers"] = value;
            }
        }

        private void Set_DateControls()
        {
            ForWhatPeriod.Visible = ((NumDateControls.Text == "2") & (Morethanonce.Checked));
            if (ForWhatPeriod.Visible)
            {
                try { Parent.FindControl("lstEffectiveDay").Visible = false; }
                catch { }
                try { Parent.FindControl("lstEffectiveMonth").Visible = false; }
                catch { }
                try { Parent.FindControl("lstEffectiveToYear").Visible = false; }
                catch { }
                try { Parent.FindControl("dateFrom").Visible = false; }
                catch { }
                try { Parent.FindControl("dateTo").Visible = false; }
                catch { }

            }
            else if (NumDateControls.Text == "2")
            {
                try { Parent.FindControl("dateFrom").Visible = true; }
                catch { }
                try { Parent.FindControl("dateTo").Visible = true; }
                catch { }
            }
            else if ((NumDateControls.Text == "1") & (!Morethanonce.Checked))
            {
                try { Parent.FindControl("lstEffectiveDay").Visible = true; }
                catch { }
                try { Parent.FindControl("lstEffectiveMonth").Visible = true; }
                catch { }
                try { Parent.FindControl("lstEffectiveToYear").Visible = true; }
                catch { }
            }

        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                InitDateControls();
                InitReportTitle();
                initDocumentType();

                bool fromCC = false;
                if (Request.QueryString["fromCC"] != null)
                {
                    Boolean.TryParse(Request.QueryString["fromCC"].ToString(), out fromCC);
                }
                
                if (!fromCC)
                    CCUsers = null;

                if (Request.QueryString["scheduleid"] != null)
                {
                    if (!fromCC)
                    {
                        CCListDataSource.ConnectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

                        CCListGridMain.DataSourceID = "CCListDataSource";
                        CCListGridMain.DataBind();

                        if (CCListGridMain.Rows.Count > 0)
                        {
                            List<int> ccUsers = new List<int>();
                            foreach (GridViewRow dr in CCListGridMain.Rows)
                            {
                                int userid = 0;
                                Int32.TryParse(dr.Cells[0].Text, out userid);
                                ccUsers.Add(userid);
                            }

                            CCUsers = ccUsers;
                        }
                    }
                    else
                        LoadCCUsers();

                    Int32.TryParse(Request.QueryString["scheduleid"].ToString(), out this.scheduleid);

                    BusinessServices.Report report = new BusinessServices.Report();
                    DataTable dtbPeriodicFields = report.GetPeriodicFields(this.scheduleid);

                    string reportTitle = dtbPeriodicFields.Rows[0]["ReportTitle"].ToString();
                    ReportTitleTextBox.Text = reportTitle;

                    switch (dtbPeriodicFields.Rows[0]["IsPeriodic"].ToString())
                    {
                        case "N":
                            Now.Checked = true;
                            OnceonlyDate.Visible = false;
                            MorethanonceGroup.Visible = false;
                            ForWhatPeriod.Visible = false;
                            break;
                        case "O":
                            Onceonly.Checked = true;
                            OnceonlyDate.Visible = true;
                            MorethanonceGroup.Visible = false;
                            ForWhatPeriod.Visible = false;
                            break;
                        case "M":
                            Morethanonce.Checked = true;
                            OnceonlyDate.Visible = false;
                            MorethanonceGroup.Visible = true;
                            Set_DateControls();
                            // disables parent effective date or to and from dates
                            // when more than once control is selected
                            if (Request.QueryString["ReportID"] != null)
                            {
                                int rptId = 0;
                                Int32.TryParse(Request.QueryString["ReportID"], out rptId);

                                try
                                {
                                    BusinessServices.Report rpt = new BusinessServices.Report();
                                    bool requiresEffDate = rpt.RequiresEffectiveDate(rptId);
                                    if (requiresEffDate)
                                    {
                                        Parent.FindControl("lstEffectiveDay").Visible = false;
                                        Parent.FindControl("lstEffectiveMonth").Visible = false;
                                        Parent.FindControl("lstEffectiveToYear").Visible = false;
                                    }

                                    bool requiresDateFromDateTo = rpt.RequiresDateFromDateTo(rptId);
                                    if (requiresDateFromDateTo)
                                    {
                                        Parent.FindControl("dateFrom").Visible = false;
                                        Parent.FindControl("dateTo").Visible = false;
                                    }
                                }
                                catch
                                {
                                    // if control does not exist
                                }


                            }
                            bool noEndDate = false;
                            Boolean.TryParse(dtbPeriodicFields.Rows[0]["NoEndDate"].ToString(), out noEndDate);
                            bool endAfter = false;
                            Boolean.TryParse(dtbPeriodicFields.Rows[0]["endAfter"].ToString(), out endAfter);
                            bool endOn = false;
                            Boolean.TryParse(dtbPeriodicFields.Rows[0]["endOn"].ToString(), out endOn);
                            if (noEndDate)
                            {
                                NoEndDate.Checked = true;
                                EndAfterTextbox.Enabled = false;
                                EndAfterTextbox.CausesValidation = false;
                                EndAfterTextboxRequiredValidator.EnableClientScript = false;
                                EndAfterTextboxValidator.EnableClientScript = false;
                                EndOnDate.Enabled = false;
                                cboFCompletionDay3.CausesValidation = false;
                                cboFCompletionMonth3.CausesValidation = false;
                                cboFCompletionYear3.CausesValidation = false;
                                cboFCompletionDayValidator3.EnableClientScript = false;
                                cboFCompletionMonthValidator3.EnableClientScript = false;
                                cboFCompletionYearValidator3.EnableClientScript = false;
                                //ForWhatPeriod.Visible = false;
                            }
                            else if (endAfter)
                            {
                                EndAfter.Checked = true;
                                EndAfterTextbox.Enabled = true;
                                EndAfterTextbox.CausesValidation = true;
                                EndAfterTextboxRequiredValidator.EnableClientScript = true;
                                EndAfterTextboxValidator.EnableClientScript = true;
                                EndOnDate.Enabled = false;
                                cboFCompletionDay3.CausesValidation = false;
                                cboFCompletionMonth3.CausesValidation = false;
                                cboFCompletionYear3.CausesValidation = false;
                                cboFCompletionDayValidator3.EnableClientScript = false;
                                cboFCompletionMonthValidator3.EnableClientScript = false;
                                cboFCompletionYearValidator3.EnableClientScript = false;
                                //ForWhatPeriod.Visible = false;
                            }
                            else if (endOn)
                            {
                                EndOn.Checked = true;
                                EndAfterTextbox.Enabled = false;
                                EndAfterTextbox.CausesValidation = false;
                                EndAfterTextboxRequiredValidator.EnableClientScript = false;
                                EndAfterTextboxValidator.EnableClientScript = false;
                                EndOnDate.Enabled = true;
                                cboFCompletionDay3.CausesValidation = true;
                                cboFCompletionMonth3.CausesValidation = true;
                                cboFCompletionYear3.CausesValidation = true;
                                cboFCompletionDayValidator3.EnableClientScript = true;
                                cboFCompletionMonthValidator3.EnableClientScript = true;
                                cboFCompletionYearValidator3.EnableClientScript = true;
                            }
                            if (NumDateControls.Text == "2")
                            {
                                ForWhatPeriod.Visible = true;
                                int reportPeriodType;
                                Int32.TryParse(dtbPeriodicFields.Rows[0]["ReportPeriodType"].ToString(), out reportPeriodType);
                                switch (reportPeriodType)
                                {
                                    case 1:
                                        rbtnAllDays.Checked = true;
                                        cboFCompletionDay4.Enabled = false;
                                        cboFCompletionMonth4.Enabled = false;
                                        cboFCompletionYear4.Enabled = false;
                                        cboFCompletionDay4.CausesValidation = false;
                                        cboFCompletionMonth4.CausesValidation = false;
                                        cboFCompletionYear4.CausesValidation = false;
                                        break;
                                    case 2:
                                        rbtnPreced.Checked = true;
                                        lblPreced.Text = " " + EveryHowMany.Text + " " + EveryUnit.Items[EveryUnit.SelectedIndex].Text + " ";
                                        cboFCompletionDay4.Enabled = false;
                                        cboFCompletionMonth4.Enabled = false;
                                        cboFCompletionYear4.Enabled = false;
                                        cboFCompletionDay4.CausesValidation = false;
                                        cboFCompletionMonth4.CausesValidation = false;
                                        cboFCompletionYear4.CausesValidation = false;
                                        break;
                                    case 3:
                                        rbtnPeriodStartOn.Checked = true;
                                        cboFCompletionDay4.Enabled = true;
                                        cboFCompletionMonth4.Enabled = true;
                                        cboFCompletionYear4.Enabled = true;
                                        cboFCompletionDay4.CausesValidation = true;
                                        cboFCompletionMonth4.CausesValidation = true;
                                        cboFCompletionYear4.CausesValidation = true;
                                        cboFCompletionDayValidator4.EnableClientScript = true;
                                        cboFCompletionMonthValidator4.EnableClientScript = true;
                                        cboFCompletionYearValidator4.EnableClientScript = true;
                                        break;
                                    default:
                                        rbtnAllDays.Checked = true;
                                        cboFCompletionDay4.Enabled = false;
                                        cboFCompletionMonth4.Enabled = false;
                                        cboFCompletionYear4.Enabled = false;
                                        cboFCompletionDay4.CausesValidation = false;
                                        cboFCompletionMonth4.CausesValidation = false;
                                        cboFCompletionYear4.CausesValidation = false;
                                        break;
                                }
                            }
                            break;
                        default:
                            break;
                    }

                    DateTime reportStartDate=DateTime.Now;
                    if (dtbPeriodicFields.Rows[0]["ReportStartDate"] != null && dtbPeriodicFields.Rows[0]["ReportStartDate"].ToString() != "")
                        reportStartDate = DateTime.Parse(dtbPeriodicFields.Rows[0]["ReportStartDate"].ToString());

                    cboFCompletionDay1.SelectedValue = reportStartDate.Day.ToString();
                    cboFCompletionMonth1.SelectedValue = reportStartDate.Month.ToString();
                    cboFCompletionYear1.SelectedValue = reportStartDate.Year.ToString();

                    cboFCompletionDay2.SelectedValue = reportStartDate.Day.ToString();
                    cboFCompletionMonth2.SelectedValue = reportStartDate.Month.ToString();
                    cboFCompletionYear2.SelectedValue = reportStartDate.Year.ToString();

                    EveryHowMany.Text = dtbPeriodicFields.Rows[0]["ReportFrequency"].ToString();

                    lblPreced.Text = " " + EveryHowMany.Text + " " + EveryUnit.Items[EveryUnit.SelectedIndex].Text + " ";

                    DateTime reportEndDate = DateTime.Now;

                    if (dtbPeriodicFields.Rows[0]["ReportEndDate"] != null && dtbPeriodicFields.Rows[0]["ReportEndDate"].ToString() != "")
                        reportEndDate = DateTime.Parse(dtbPeriodicFields.Rows[0]["ReportEndDate"].ToString());

                    cboFCompletionDay3.SelectedValue = reportEndDate.Day.ToString();
                    cboFCompletionMonth3.SelectedValue = reportEndDate.Month.ToString();
                    cboFCompletionYear3.SelectedValue = reportEndDate.Year.ToString();

                    DateTime reportFromDate = DateTime.Now;
                    if (dtbPeriodicFields.Rows[0]["ReportFromDate"] != null && dtbPeriodicFields.Rows[0]["ReportFromDate"].ToString() != "")
                        reportFromDate = DateTime.Parse(dtbPeriodicFields.Rows[0]["ReportFromDate"].ToString());

                    cboFCompletionDay4.SelectedValue = reportFromDate.Day.ToString();
                    cboFCompletionMonth4.SelectedValue = reportFromDate.Month.ToString();
                    cboFCompletionYear4.SelectedValue = reportFromDate.Year.ToString();

                    CCAddEdit.Attributes.Add("onclick", "window.open('CCList.aspx?scheduleid=" + scheduleid.ToString() + "'); return false;");
                }
                else
                    CCAddEdit.Attributes.Add("onclick", "window.open('CCList.aspx'); return false;");
            }

            if (NoEndDate.Checked)
            {
                EndAfterTextbox.Enabled = false;
                EndAfterTextbox.CausesValidation = false;
                EndAfterTextboxRequiredValidator.EnableClientScript = false;
                EndAfterTextboxValidator.EnableClientScript = false;
                EndOnDate.Enabled = false;
                cboFCompletionDay3.CausesValidation = false;
                cboFCompletionMonth3.CausesValidation = false;
                cboFCompletionYear3.CausesValidation = false;
                cboFCompletionDayValidator3.EnableClientScript = false;
                cboFCompletionMonthValidator3.EnableClientScript = false;
                cboFCompletionYearValidator3.EnableClientScript = false;
                ForWhatPeriod.Visible = false;
            }
            else if (EndAfter.Checked)
            {
                EndAfterTextbox.Enabled = true;
                EndAfterTextbox.CausesValidation = true;
                EndAfterTextboxRequiredValidator.EnableClientScript = true;
                EndAfterTextboxValidator.EnableClientScript = true;
                EndOnDate.Enabled = false;
                cboFCompletionDay3.CausesValidation = false;
                cboFCompletionMonth3.CausesValidation = false;
                cboFCompletionYear3.CausesValidation = false;
                cboFCompletionDayValidator3.EnableClientScript = false;
                cboFCompletionMonthValidator3.EnableClientScript = false;
                cboFCompletionYearValidator3.EnableClientScript = false;
                ForWhatPeriod.Visible = false;
            }
            else if (EndOn.Checked)
            {
                EndAfterTextbox.Enabled = false;
                EndAfterTextbox.CausesValidation = false;
                EndAfterTextboxRequiredValidator.EnableClientScript = false;
                EndAfterTextboxValidator.EnableClientScript = false;
                EndOnDate.Enabled = true;
                cboFCompletionDay3.CausesValidation = true;
                cboFCompletionMonth3.CausesValidation = true;
                cboFCompletionYear3.CausesValidation = true;
                cboFCompletionDayValidator3.EnableClientScript = true;
                cboFCompletionMonthValidator3.EnableClientScript = true;
                cboFCompletionYearValidator3.EnableClientScript = true;
            }

            if ((Morethanonce.Checked) && (NumDateControls.Text == "2"))
            {
                ForWhatPeriod.Visible = true;

                if (rbtnAllDays.Checked)
                {
                    cboFCompletionDay4.Enabled = false;
                    cboFCompletionMonth4.Enabled = false;
                    cboFCompletionYear4.Enabled = false;
                    cboFCompletionDay4.CausesValidation = false;
                    cboFCompletionMonth4.CausesValidation = false;
                    cboFCompletionYear4.CausesValidation = false;
                }
                else if (rbtnPreced.Checked)
                {
                    lblPreced.Text = " " + EveryHowMany.Text + " " + EveryUnit.Items[EveryUnit.SelectedIndex].Text + " ";
                    cboFCompletionDay4.Enabled = false;
                    cboFCompletionMonth4.Enabled = false;
                    cboFCompletionYear4.Enabled = false;
                    cboFCompletionDay4.CausesValidation = false;
                    cboFCompletionMonth4.CausesValidation = false;
                    cboFCompletionYear4.CausesValidation = false;
                }
                else if (rbtnPeriodStartOn.Checked)
                {
                    cboFCompletionDay4.Enabled = true;
                    cboFCompletionMonth4.Enabled = true;
                    cboFCompletionYear4.Enabled = true;
                    cboFCompletionDay4.CausesValidation = true;
                    cboFCompletionMonth4.CausesValidation = true;
                    cboFCompletionYear4.CausesValidation = true;
                    cboFCompletionDayValidator4.EnableClientScript = true;
                    cboFCompletionMonthValidator4.EnableClientScript = true;
                    cboFCompletionYearValidator4.EnableClientScript = true;
                }
            }
        }

        protected void CCGridUpdatePanel_Load(object sender, EventArgs e)
        {
            LoadCCUsers();
            //CCGridUpdatePanel.Update();
        }

        private void LoadCCUsers()
        {
            DataTable dtCCUsers = new DataTable();
            DataColumn dc0 = new DataColumn("UserId");
            DataColumn dc1 = new DataColumn("FirstName");
            DataColumn dc2 = new DataColumn("LastName");
            DataColumn dc3 = new DataColumn("Email");
            dtCCUsers.Columns.Add(dc0);
            dtCCUsers.Columns.Add(dc1);
            dtCCUsers.Columns.Add(dc2);
            dtCCUsers.Columns.Add(dc3);
            if (CCUsers != null)
            {
                foreach (int userId in CCUsers)
                {
                    BusinessServices.User user = new BusinessServices.User();
                    DataTable dtUser = user.GetUser(userId);
                    DataRow dr = dtCCUsers.NewRow();
                    dr["UserId"] = userId;
                    dr["FirstName"] = dtUser.Rows[0]["FirstName"].ToString();
                    dr["LastName"] = dtUser.Rows[0]["LastName"].ToString();
                    dr["Email"] = dtUser.Rows[0]["Email"].ToString();
                    dtCCUsers.Rows.Add(dr);
                }
                ccGridMainCount = dtCCUsers.Rows.Count;

                CCListGridMain.DataSourceID = "";
                CCListGridMain.DataSource = dtCCUsers.DefaultView;
                CCListGridMain.DataBind();
            }
        }

        private void InitDateControls()
        {
            Utilities.WebTool.SetupDateControl(cboFCompletionDay1, cboFCompletionMonth1, cboFCompletionYear1, DateTime.Now.Year-1, 5);
            Utilities.WebTool.SetupDateControl(cboFCompletionDay2, cboFCompletionMonth2, cboFCompletionYear2, DateTime.Now.Year-1, 5);
            Utilities.WebTool.SetupDateControl(cboFCompletionDay3, cboFCompletionMonth3, cboFCompletionYear3, DateTime.Now.Year-1, 5);
            Utilities.WebTool.SetupDateControl(cboFCompletionDay4, cboFCompletionMonth4, cboFCompletionYear4, DateTime.Now.Year-1, 5);
        }

        private void InitReportTitle()
        {
            if (ReportTitleTextBox.Text == String.Empty)
            {
                string appName = Utilities.ApplicationSettings.AppName;
                BusinessServices.Report rpt = new BusinessServices.Report();

                string reportTypeName = String.Empty;

                if (Request.QueryString["scheduleid"] != null)
                {
                    Int32.TryParse(Request.QueryString["scheduleid"].ToString(), out this.scheduleid);
                    reportTypeName = rpt.GetTypeFromScheduleId(this.scheduleid);
                }
                else if (Request.QueryString["ReportID"] != null)
                {
                    int rptId = 0;
                    Int32.TryParse(Request.QueryString["ReportID"].ToString(), out rptId);
                    reportTypeName = rpt.GetTypeFromID(rptId);

                    string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
                    string sqlSelect = "SELECT case " +
                    " when RI.ReportID = 27 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.2')) " +
                    " when RI.ReportID = 26 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.2')) " +
                    " when RI.ReportID = 3 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.1')) " +
                    " when RI.ReportID = 6 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Admin/AdministrationReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle.1')) " +
                    " when RI.ReportID = 36 then (select coalesce(LangEntryValue,'Missing Localisation') from tblLangValue where tblLangValue.LangID = (SELECT LangID FROM tblLang where tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "') and LangInterfaceID = (select LangInterfaceID from tblLangInterface where LangInterfaceName = '/Reporting/Policy/PolicyBuilderReport.aspx') and LangResourceID = (select LangResourceID from tblLangResource where LangResourceName = 'lblPageTitle')) " +
                    " else coalesce(LangEntryValue,'Missing Localisation') " +
                    " end as ReportName, ReportID " +
                    " FROM (SELECT tblLangValue.LangEntryValue, tblLangInterface.langinterfacename FROM tblLang INNER JOIN " +
                    " tblLangValue ON tblLang.LangID = tblLangValue.LangID and tblLang.LangCode = '" + ResourceManager.CurrentCultureName + "' " +
                    " INNER JOIN tblLangResource ON tblLangValue.LangResourceID = tblLangResource.LangResourceID " +
                    " INNER JOIN tblLangInterface ON tblLangValue.LangInterfaceID = tblLangInterface.LangInterfaceID " +
                    " AND (tblLangValue.Active = 1) and langresourcename = 'rptreporttitle' ) as TI " +
                    " right outer join tblReportinterface RI on RI.paramlanginterfacename = TI.langinterfacename " +
                        //" where (RI.ReportID != 6)  and (RI.ReportID != 18) and (RI.ReportID != 24) and (RI.ReportID != 26) and (RI.ReportID != 10)and (RI.ReportID != 23)order by ReportName";
                    " where (RI.Active = 1) and (RI.ReportID != 6)  and (RI.ReportID != 18) and (RI.ReportID != 24) and (RI.ReportID != 26) and (RI.ReportID != 10)and (RI.ReportID != 23)   ";
                    DataTable dtbReportTable = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect).Tables[0];

                    var query = from report in dtbReportTable.AsEnumerable() where report.Field<int>("ReportID") == rptId select report;
                    DataTable dtReport = query.CopyToDataTable();

                    reportTypeName = dtReport.Rows[0]["ReportName"].ToString();

                    string reportText = ResourceManager.GetString("ReportText");

                    ReportTitleTextBox.Text = appName + reportText + reportTypeName;
                }
            }
        }

        private void initDocumentType()
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            String sqlSelect = "select * from tblReportType order by Name";
            DataTable dtbDocumentTypeTable = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect).Tables[0];
            DocType.DataSource = dtbDocumentTypeTable;
            DocType.DataValueField = "Type";
            DocType.DataTextField = "Name";
            DocType.DataBind();
            PeriodicReportTimes.GroupingText = ResourceManager.GetString("howManyTimes"); 
            ForWhatPeriod.GroupingText = ResourceManager.GetString("ForWhatPeriod");
            EveryUnit.Items[0].Text = ResourceManager.GetString("day");
            EveryUnit.Items[1].Text = ResourceManager.GetString("week");
            EveryUnit.Items[2].Text = ResourceManager.GetString("month");
            EveryUnit.Items[3].Text = ResourceManager.GetString("year");
        }

        protected void CCListGridMain_RowCreated(object sender, GridViewRowEventArgs e)
        {
            e.Row.Cells[0].Visible = false;
        }

        protected void CCListGridMain_PreRender(object sender, EventArgs e)
        {

            GridViewRow pagerRow = CCListGridMain.BottomPagerRow;

            if (pagerRow != null && pagerRow.Visible == false)
                pagerRow.Visible = true;

        }

        protected void CCListGridMain_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            for (int i = 0; i < e.Row.Cells.Count; i++)
            {
                e.Row.Cells[i].Attributes.Add("style", "white-space: nowrap;");
            }
        }

        protected void CCListDataSource_Selected(Object sender, SqlDataSourceStatusEventArgs e)
        {
            ccGridMainCount = e.AffectedRows;
        }

        protected void CCListGridMain_DataBound(Object sender, EventArgs e)
        {
                 // Retrieve the pager row.
                GridViewRow pagerRow = CCListGridMain.BottomPagerRow;
                if (pagerRow == null)
                    return;
                // Retrieve the DropDownList and Label controls from the row.
                DropDownList pageList = (DropDownList)pagerRow.Cells[0].FindControl("PageDropDownList");
                Label pageLabel = (Label)pagerRow.Cells[0].FindControl("CurrentPageLabel");

            if (pageList != null)
            {

                // Create the values for the DropDownList control based on 
                // the  total number of pages required to display the data
                // source.
                for (int i = 0; i < CCListGridMain.PageCount; i++)
                {

                    // Create a ListItem object to represent a page.
                    int pageNumber = i + 1;
                    ListItem item = new ListItem(pageNumber.ToString());

                    // If the ListItem object matches the currently selected
                    // page, flag the ListItem object as being selected. Because
                    // the DropDownList control is recreated each time the pager
                    // row gets created, this will persist the selected item in
                    // the DropDownList control.   
                    if (i == CCListGridMain.PageIndex)
                    {
                        item.Selected = true;
                    }

                    // Add the ListItem object to the Items collection of the 
                    // DropDownList.
                    pageList.Items.Add(item);

                }
            }

            if (pageLabel != null)
            {
                // Calculate the current page number.
                int currentPage = CCListGridMain.PageIndex + 1;


                // Update the Label control with the current page information.
                pageLabel.Text = " Of " + CCListGridMain.PageCount.ToString()
                               + " :    " + (CCListGridMain.PageIndex * CCListGridMain.PageSize + 1) + " -- " + (CCListGridMain.PageIndex * CCListGridMain.PageSize + CCListGridMain.Rows.Count) + " Of " + ccGridMainCount;

            }
        }

        protected void PageDropDownList_SelectedIndexChanged(Object sender, EventArgs e)
        {

            // Retrieve the pager row.
            GridViewRow pagerRow = CCListGridMain.BottomPagerRow;

            // Retrieve the PageDropDownList DropDownList from the bottom pager row.
            DropDownList pageList = (DropDownList)pagerRow.Cells[0].FindControl("PageDropDownList");

            // Set the PageIndex property to display that page selected by the user.
            CCListGridMain.PageIndex = pageList.SelectedIndex;

            LoadCCUsers();
            
        }

        protected void StartOnValidate(object sender, ServerValidateEventArgs args)
        {
            int startonDay = 0;
            Int32.TryParse(cboFCompletionDay2.SelectedValue, out startonDay);
            int startonMonth = 0;
            Int32.TryParse(cboFCompletionMonth2.SelectedValue, out startonMonth);
            int startonYear = 0;
            Int32.TryParse(cboFCompletionYear2.SelectedValue, out startonYear);
            DateTime startOnDate = new DateTime(startonYear, startonMonth, startonDay);

            args.IsValid = (startOnDate >= DateTime.Today);
        }

          // Not used. One in periodicreport.aspx is used instead
        protected void SaveSend_OnClick(object sender, EventArgs e)
        {
        }

        protected void now_CheckChanged(object sender, EventArgs e)
        {
            if (Now.Checked)
            {
                OnceonlyDate.Visible = false;
                MorethanonceGroup.Visible = false;
                ForWhatPeriod.Visible = false;
                Set_DateControls();
            }
        }

        protected void onceonly_CheckChanged(object sender, EventArgs e)
        {
            if (Onceonly.Checked)
            {
                OnceonlyDate.Visible = true; 
                MorethanonceGroup.Visible = false;
                ForWhatPeriod.Visible = false;
                Set_DateControls();
            }
            else
            {
                OnceonlyDate.Visible = false;
            }
        }

        protected void morethanonce_CheckChanged(object sender, EventArgs e)
        {
            if (Morethanonce.Checked)
            {
                OnceonlyDate.Visible = false;
                MorethanonceGroup.Visible = true;
                Set_DateControls();
                // disables parent effective date or to and from dates
                // when more than once control is selected
                if (Request.QueryString["ReportID"] != null)
                {
                    int rptId = 0;
                    Int32.TryParse(Request.QueryString["ReportID"], out rptId);

                }

                if (NoEndDate.Checked)
                {
                    EndAfterTextbox.Enabled = false;
                    EndAfterTextbox.CausesValidation = false;
                    EndAfterTextboxRequiredValidator.EnableClientScript = false;
                    EndAfterTextboxValidator.EnableClientScript = false;
                    EndOnDate.Enabled = false;
                    cboFCompletionDay3.CausesValidation = false;
                    cboFCompletionMonth3.CausesValidation = false;
                    cboFCompletionYear3.CausesValidation = false;
                    cboFCompletionDayValidator3.EnableClientScript = false;
                    cboFCompletionMonthValidator3.EnableClientScript = false;
                    cboFCompletionYearValidator3.EnableClientScript = false;
                    ForWhatPeriod.Visible = false;
                }
                else if (EndAfter.Checked)
                {
                    EndAfterTextbox.Enabled = true;
                    EndAfterTextbox.CausesValidation = true;
                    EndAfterTextboxValidator.EnableClientScript = true;
                    EndAfterTextboxRequiredValidator.EnableClientScript = true;
                    EndOnDate.Enabled = false;
                    cboFCompletionDay3.CausesValidation = false;
                    cboFCompletionMonth3.CausesValidation = false;
                    cboFCompletionYear3.CausesValidation = false;
                    cboFCompletionDayValidator3.EnableClientScript = false;
                    cboFCompletionMonthValidator3.EnableClientScript = false;
                    cboFCompletionYearValidator3.EnableClientScript = false;
                    ForWhatPeriod.Visible = false;
                }
                else if (EndOn.Checked)
                {
                    EndAfterTextbox.Enabled = false;
                    EndAfterTextbox.CausesValidation = false;
                    EndAfterTextboxRequiredValidator.EnableClientScript = false;
                    EndAfterTextboxValidator.EnableClientScript = false;
                    EndOnDate.Enabled = true;
                    cboFCompletionDay3.CausesValidation = true;
                    cboFCompletionMonth3.CausesValidation = true;
                    cboFCompletionYear3.CausesValidation = true;
                    cboFCompletionDayValidator3.EnableClientScript = true;
                    cboFCompletionMonthValidator3.EnableClientScript = true;
                    cboFCompletionYearValidator3.EnableClientScript = true;
                }

                if (NumDateControls.Text == "2")
                {
                    ForWhatPeriod.Visible = true;
                    if (rbtnAllDays.Checked)
                    {
                        cboFCompletionDay4.Enabled = false;
                        cboFCompletionMonth4.Enabled = false;
                        cboFCompletionYear4.Enabled = false;

                        cboFCompletionDay4.CausesValidation = false;
                        cboFCompletionMonth4.CausesValidation = false;
                        cboFCompletionYear4.CausesValidation = false;
                        cboFCompletionDayValidator4.EnableClientScript = false;
                        cboFCompletionMonthValidator4.EnableClientScript = false;
                        cboFCompletionYearValidator4.EnableClientScript = false;
                    }
                    else if (rbtnPreced.Checked)
                    {
                        lblPreced.Text = " " + EveryHowMany.Text + " " + EveryUnit.Items[EveryUnit.SelectedIndex].Text + " ";
                        cboFCompletionDay4.Enabled = false;
                        cboFCompletionMonth4.Enabled = false;
                        cboFCompletionYear4.Enabled = false;
                        cboFCompletionDay4.CausesValidation = false;
                        cboFCompletionMonth4.CausesValidation = false;
                        cboFCompletionYear4.CausesValidation = false;
                        cboFCompletionDayValidator4.EnableClientScript = false;
                        cboFCompletionMonthValidator4.EnableClientScript = false;
                        cboFCompletionYearValidator4.EnableClientScript = false;
                    }
                    else if (rbtnPeriodStartOn.Checked)
                    {
                        cboFCompletionDay4.Enabled = true;
                        cboFCompletionMonth4.Enabled = true;
                        cboFCompletionYear4.Enabled = true;
                        cboFCompletionDay4.CausesValidation = true;
                        cboFCompletionMonth4.CausesValidation = true;
                        cboFCompletionYear4.CausesValidation = true;
                        cboFCompletionDayValidator4.EnableClientScript = true;
                        cboFCompletionMonthValidator4.EnableClientScript = true;
                        cboFCompletionYearValidator4.EnableClientScript = true;
                    }
                }
            }
            else
            {
                Morethanonce.Visible = false;
                ForWhatPeriod.Visible = false;
                Set_DateControls();
                // enable parent effective date or to and from dates
                // when more than once control is unselected
                if (Request.QueryString["ReportID"] != null)
                {
                    int rptId = 0;
                    Int32.TryParse(Request.QueryString["ReportID"], out rptId);

                    try
                    {
                        BusinessServices.Report rpt = new BusinessServices.Report();
                        bool requiresEffDate = rpt.RequiresEffectiveDate(rptId);
                        if (requiresEffDate)
                        {
                            Parent.FindControl("lstEffectiveDay").Visible = true;
                            Parent.FindControl("lstEffectiveMonth").Visible = true;
                            Parent.FindControl("lstEffectiveToYear").Visible = true;
                        }

                        bool requiresDateFromDateTo = rpt.RequiresDateFromDateTo(rptId);
                        if (requiresDateFromDateTo)
                        {
                            Parent.FindControl("dateFrom").Visible = true;
                            Parent.FindControl("dateTo").Visible = true;
                        }
                    }
                    catch
                    {
                        // if control does not exist
                    }
                }
            }
        }

        protected void EndAfterTextbox_TextChanged(object sender, EventArgs e)
        {
            lblPreced.Text = " " + EveryHowMany.Text + " " + EveryUnit.Items[EveryUnit.SelectedIndex].Text + " ";
        }

        protected void noEndDate_CheckChanged(object sender, EventArgs e)
        {
            if (NoEndDate.Checked)
            {
                EndAfterTextbox.Enabled = false;
                EndAfterTextbox.CausesValidation = false;
                EndAfterTextboxRequiredValidator.EnableClientScript = false;
                EndAfterTextboxValidator.EnableClientScript = false;
                EndOnDate.Enabled = false;
                cboFCompletionDay3.CausesValidation = false;
                cboFCompletionMonth3.CausesValidation = false;
                cboFCompletionYear3.CausesValidation = false;
                cboFCompletionDayValidator3.EnableClientScript = false;
                cboFCompletionMonthValidator3.EnableClientScript = false;
                cboFCompletionYearValidator3.EnableClientScript = false;

                if (NumDateControls.Text == "2")
                {
                    ForWhatPeriod.Visible = true;
                    if (rbtnAllDays.Checked)
                    {
                        cboFCompletionDay4.Enabled = false;
                        cboFCompletionMonth4.Enabled = false;
                        cboFCompletionYear4.Enabled = false;
                        cboFCompletionDay4.CausesValidation = false;
                        cboFCompletionMonth4.CausesValidation = false;
                        cboFCompletionYear4.CausesValidation = false;
                    }
                    else if (rbtnPreced.Checked)
                    {
                        lblPreced.Text = " " + EveryHowMany.Text + " " + EveryUnit.Items[EveryUnit.SelectedIndex].Text + " ";
                        cboFCompletionDay4.Enabled = false;
                        cboFCompletionMonth4.Enabled = false;
                        cboFCompletionYear4.Enabled = false;
                        cboFCompletionDay4.CausesValidation = false;
                        cboFCompletionMonth4.CausesValidation = false;
                        cboFCompletionYear4.CausesValidation = false;
                    }
                    else if (rbtnPeriodStartOn.Checked)
                    {
                        cboFCompletionDay4.Enabled = true;
                        cboFCompletionMonth4.Enabled = true;
                        cboFCompletionYear4.Enabled = true;
                        cboFCompletionDay4.CausesValidation = true;
                        cboFCompletionMonth4.CausesValidation = true;
                        cboFCompletionYear4.CausesValidation = true;
                        cboFCompletionDayValidator4.EnableClientScript = true;
                        cboFCompletionMonthValidator4.EnableClientScript = true;
                        cboFCompletionYearValidator4.EnableClientScript = true;
                    }
                }
            }
            else
            {
                ForWhatPeriod.Visible = false;
            }
        }

        protected void endAfter_CheckChanged(object sender, EventArgs e)
        {
            if (EndAfter.Checked)
            {
                EndAfterTextbox.Enabled = true;
                EndAfterTextbox.CausesValidation = true;
                EndAfterTextboxValidator.EnableClientScript = true;
                EndAfterTextboxRequiredValidator.EnableClientScript = true;
                EndOnDate.Enabled = false;
                cboFCompletionDay3.CausesValidation = false;
                cboFCompletionMonth3.CausesValidation = false;
                cboFCompletionYear3.CausesValidation = false;
                cboFCompletionDayValidator3.EnableClientScript = false;
                cboFCompletionMonthValidator3.EnableClientScript = false;
                cboFCompletionYearValidator3.EnableClientScript = false;

                if (NumDateControls.Text == "2")
                {
                    ForWhatPeriod.Visible = true;
                    if (rbtnAllDays.Checked)
                    {
                        cboFCompletionDay4.Enabled = false;
                        cboFCompletionMonth4.Enabled = false;
                        cboFCompletionYear4.Enabled = false;
                        cboFCompletionDay4.CausesValidation = false;
                        cboFCompletionMonth4.CausesValidation = false;
                        cboFCompletionYear4.CausesValidation = false;
                    }
                    else if (rbtnPreced.Checked)
                    {
                        lblPreced.Text = " " + EveryHowMany.Text + " " + EveryUnit.Items[EveryUnit.SelectedIndex].Text + " ";
                        cboFCompletionDay4.Enabled = false;
                        cboFCompletionMonth4.Enabled = false;
                        cboFCompletionYear4.Enabled = false;
                        cboFCompletionDay4.CausesValidation = false;
                        cboFCompletionMonth4.CausesValidation = false;
                        cboFCompletionYear4.CausesValidation = false;
                    }
                    else if (rbtnPeriodStartOn.Checked)
                    {
                        cboFCompletionDay4.Enabled = true;
                        cboFCompletionMonth4.Enabled = true;
                        cboFCompletionYear4.Enabled = true;
                        cboFCompletionDay4.CausesValidation = true;
                        cboFCompletionMonth4.CausesValidation = true;
                        cboFCompletionYear4.CausesValidation = true;
                        cboFCompletionDayValidator4.EnableClientScript = true;
                        cboFCompletionMonthValidator4.EnableClientScript = true;
                        cboFCompletionYearValidator4.EnableClientScript = true;
                    }
                }
            }
            else
            {
                ForWhatPeriod.Visible = false;
                EndAfterTextbox.Enabled = false;
                EndAfterTextboxRequiredValidator.EnableClientScript = false;
                EndAfterTextboxValidator.EnableClientScript = false;
                EndAfterTextbox.CausesValidation = false;
            }
        }

        protected void endOn_CheckChanged(object sender, EventArgs e)
        {
            if (EndOn.Checked)
            {
                EndAfterTextbox.Enabled = false;
                EndAfterTextbox.CausesValidation = false;
                EndAfterTextboxRequiredValidator.EnableClientScript = false;
                EndAfterTextboxValidator.EnableClientScript = false;
                EndOnDate.Enabled = true;
                cboFCompletionDay3.CausesValidation = true;
                cboFCompletionMonth3.CausesValidation = true;
                cboFCompletionYear3.CausesValidation = true;
                cboFCompletionDayValidator3.EnableClientScript = true;
                cboFCompletionMonthValidator3.EnableClientScript = true;
                cboFCompletionYearValidator3.EnableClientScript = true;

                if (NumDateControls.Text == "2")
                {
                    ForWhatPeriod.Visible = true;
                    if(rbtnAllDays.Checked)
                    {
                            cboFCompletionDay4.Enabled = false;
                            cboFCompletionMonth4.Enabled = false;
                            cboFCompletionYear4.Enabled = false;
                            cboFCompletionDay4.CausesValidation = false;
                            cboFCompletionMonth4.CausesValidation = false;
                            cboFCompletionYear4.CausesValidation = false;
                    }
                    else if (rbtnPreced.Checked)
                    {
                            lblPreced.Text = " " + EveryHowMany.Text + " " + EveryUnit.Items[EveryUnit.SelectedIndex].Text + " ";
                            cboFCompletionDay4.Enabled = false;
                            cboFCompletionMonth4.Enabled = false;
                            cboFCompletionYear4.Enabled = false;
                            cboFCompletionDay4.CausesValidation = false;
                            cboFCompletionMonth4.CausesValidation = false;
                            cboFCompletionYear4.CausesValidation = false;
                    }
                    else if (rbtnPeriodStartOn.Checked)
                    {
                            cboFCompletionDay4.Enabled = true;
                            cboFCompletionMonth4.Enabled = true;
                            cboFCompletionYear4.Enabled = true;
                            cboFCompletionDay4.CausesValidation = true;
                            cboFCompletionMonth4.CausesValidation = true;
                            cboFCompletionYear4.CausesValidation = true;
                            cboFCompletionDayValidator4.EnableClientScript = true;
                            cboFCompletionMonthValidator4.EnableClientScript = true;
                            cboFCompletionYearValidator4.EnableClientScript = true;
                    }
                }
            }
            else
            {
                EndOnDate.Enabled = false;
                cboFCompletionDay3.CausesValidation = false;
                cboFCompletionMonth3.CausesValidation = false;
                cboFCompletionYear3.CausesValidation = false;
                cboFCompletionDayValidator3.EnableClientScript = false;
                cboFCompletionMonthValidator3.EnableClientScript = false;
                cboFCompletionYearValidator3.EnableClientScript = false;
                ForWhatPeriod.Visible = false;
            }
        }

        protected void allDays_CheckChanged(object sender, EventArgs e)
        {
            if (rbtnAllDays.Checked)
            {
                cboFCompletionDay4.Enabled = false;
                cboFCompletionMonth4.Enabled = false;
                cboFCompletionYear4.Enabled = false;
                cboFCompletionDay4.CausesValidation = false;
                cboFCompletionMonth4.CausesValidation = false;
                cboFCompletionYear4.CausesValidation = false;
                cboFCompletionDayValidator4.EnableClientScript = false;
                cboFCompletionMonthValidator4.EnableClientScript = false;
                cboFCompletionYearValidator4.EnableClientScript = false;
            }
        }

        protected void preced_CheckChanged(object sender, EventArgs e)
        {
            if (rbtnPreced.Checked)
            {
                lblPreced.Text = " " + EveryHowMany.Text + " " + EveryUnit.Items[EveryUnit.SelectedIndex].Text + " ";
                cboFCompletionDay4.Enabled = false;
                cboFCompletionMonth4.Enabled = false;
                cboFCompletionYear4.Enabled = false;
                cboFCompletionDay4.CausesValidation = false;
                cboFCompletionMonth4.CausesValidation = false;
                cboFCompletionYear4.CausesValidation = false;
                cboFCompletionDayValidator4.EnableClientScript = false;
                cboFCompletionMonthValidator4.EnableClientScript = false;
                cboFCompletionYearValidator4.EnableClientScript = false;
            }
        }

        protected void periodStartOn_CheckChanged(object sender, EventArgs e)
        {
            if (rbtnPeriodStartOn.Checked)
            {
                cboFCompletionDay4.Enabled = true;
                cboFCompletionMonth4.Enabled = true;
                cboFCompletionYear4.Enabled = true;
                cboFCompletionDay4.CausesValidation = true;
                cboFCompletionMonth4.CausesValidation = true;
                cboFCompletionYear4.CausesValidation = true;
                cboFCompletionDayValidator4.EnableClientScript = true;
                cboFCompletionMonthValidator4.EnableClientScript = true;
                cboFCompletionYearValidator4.EnableClientScript = true;
            }
            else
            {
                cboFCompletionDay4.Enabled = false;
                cboFCompletionMonth4.Enabled = false;
                cboFCompletionYear4.Enabled = false;
                cboFCompletionDay4.CausesValidation = false;
                cboFCompletionMonth4.CausesValidation = false;
                cboFCompletionYear4.CausesValidation = false;
                cboFCompletionDayValidator4.EnableClientScript = false;
                cboFCompletionMonthValidator4.EnableClientScript = false;
                cboFCompletionYearValidator4.EnableClientScript = false;
            }
        }


    }
}