using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text;

using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.BusinessServices;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.Organisation
{
    public partial class OrgEditTimezoneDaylightRules : System.Web.UI.Page
    {
        protected int tzId;
        private string tzWrittenName;
        private int ruleId;
        private bool isNew;
 
        protected void Page_Load(object sender, EventArgs e)
        {
            pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            if (!Page.IsPostBack)
            {
                if (UserContext.UserData.UserType == UserType.SaltAdmin || UserContext.UserData.UserType == UserType.OrgAdmin)
                {
                    Int32.TryParse(Request.QueryString["timezone"], out this.tzId);

                    using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetTimeZoneWrittenName",
                        StoredProcedure.CreateInputParam("@TimeZoneID", SqlDbType.Int, this.tzId)))
                    {
                        this.tzWrittenName = sp.ExecuteScalar().ToString();
                    }

                    ViewState.Add("WrittenName", this.tzWrittenName);

                    this.isNew = false;
                    if (Request.QueryString["ruleid"].ToString().ToUpper() == "NEW")
                    {
                        this.isNew = true;
                        this.txtTimezone.Text = this.tzWrittenName;
                    }
                    else
                    {
                        Int32.TryParse(Request.QueryString["ruleid"], out this.ruleId);
                        this.LoadData();
                    }

                    ViewState.Add("RuleID", this.ruleId);
                    ViewState.Add("TimezoneID", this.tzId);
                    ViewState.Add("IsNew", this.isNew);
                }
            }
        }

        private void LoadData()
        {

            DataTable dtTZDaylight;

            using (StoredProcedure sp = new StoredProcedure("prcGetTimezoneDaylightRules",
                StoredProcedure.CreateInputParam("@TimezoneId", SqlDbType.Int, this.tzId),
                StoredProcedure.CreateInputParam("@RuleID", SqlDbType.Int, this.ruleId)))
            {
                dtTZDaylight = sp.ExecuteTable();
            }

            if (dtTZDaylight.Rows.Count > 0)
            {
                this.txtTimezone.Text = ViewState["WrittenName"].ToString();
                this.txtFirstYearStart.Text = dtTZDaylight.Rows[0]["StartYear"].ToString();
                this.txtLastYearStart.Text = dtTZDaylight.Rows[0]["EndYear"].ToString();
                int offset;
                int timeStart;
                int weekdayStart;
                int weekStart;
                int monthStart;
                int timeEnd;
                int weekdayEnd;
                int weekEnd;
                int monthEnd;

                Int32.TryParse(dtTZDaylight.Rows[0]["Offset"].ToString(), out offset);
                this.txtOffset.Text = ConvertMinstoString(offset);
                Int32.TryParse(dtTZDaylight.Rows[0]["TimeStart"].ToString(), out timeStart);
                this.txtTimeStart.Text = ConvertMinstoString(timeStart);
                Int32.TryParse(dtTZDaylight.Rows[0]["WeekdayStart"].ToString(), out weekdayStart);
                this.drpWeekdayStart.SelectedValue = weekdayStart.ToString();
                Int32.TryParse(dtTZDaylight.Rows[0]["WeekStart"].ToString(), out weekStart);
                this.drpWeekStart.SelectedValue = weekStart.ToString();
                Int32.TryParse(dtTZDaylight.Rows[0]["MonthStart"].ToString(), out monthStart);
                this.drpMonthStart.SelectedValue = monthStart.ToString();
                Int32.TryParse(dtTZDaylight.Rows[0]["TimeEnd"].ToString(), out timeEnd);
                this.txtTimeEnd.Text = ConvertMinstoString(timeEnd);
                Int32.TryParse(dtTZDaylight.Rows[0]["WeekdayEnd"].ToString(), out weekdayEnd);
                this.drpWeekdayEnd.SelectedValue = weekdayEnd.ToString();
                Int32.TryParse(dtTZDaylight.Rows[0]["WeekEnd"].ToString(), out weekEnd);
                this.drpWeekEnd.SelectedValue = weekEnd.ToString();
                Int32.TryParse(dtTZDaylight.Rows[0]["MonthEnd"].ToString(), out monthEnd);
                this.drpMonthEnd.SelectedValue = monthEnd.ToString();
            }
        }

        private string ConvertMinstoString(int totalMins)
        {
            String strHours = null;
            String strMins = null;
            int hours;
            int mins;

            hours = (int)(totalMins / 60);
            strHours = hours.ToString();
            mins = totalMins - (hours * 60);
            if (mins < 0)
                mins = -mins;
            strMins = mins.ToString();

            StringBuilder sb = new StringBuilder();
            sb.AppendFormat("{0}:{1}:00", strHours, strMins);
            return sb.ToString();
        }

        protected void chkDelete_Changed(object sender, EventArgs e)
        {
            if (this.chkDelete.Checked)
            {
                this.txtTimezone.Enabled = false;
                this.txtFirstYearStart.Enabled = false;
                this.txtLastYearStart.Enabled = false;
                this.txtOffset.Enabled = false;
                this.txtTimeStart.Enabled = false;
                this.drpWeekdayStart.Enabled = false;
                this.drpWeekStart.Enabled = false;
                this.drpMonthStart.Enabled = false;
                this.txtTimeEnd.Enabled = false;
                this.drpWeekdayEnd.Enabled = false;
                this.drpWeekEnd.Enabled = false;
                this.drpMonthEnd.Enabled = false;
            }
            else
            {
                this.txtTimezone.Enabled = true;
                this.txtFirstYearStart.Enabled = true;
                this.txtLastYearStart.Enabled = true;
                this.txtOffset.Enabled = true;
                this.txtTimeStart.Enabled = true;
                this.drpWeekdayStart.Enabled = true;
                this.drpWeekStart.Enabled = true;
                this.drpMonthStart.Enabled = true;
                this.txtTimeEnd.Enabled = true;
                this.drpWeekdayEnd.Enabled = true;
                this.drpWeekEnd.Enabled = true;
                this.drpMonthEnd.Enabled = true;
            }
        }

        protected void btnOrgEditDaylightSave_Click(object sender, EventArgs e)
        {
            this.tzId = (int)ViewState["TimezoneID"];
            this.isNew = (bool) ViewState["IsNew"];
            this.ruleId = (int) ViewState["RuleID"];

            if (this.chkDelete.Checked && (!this.isNew))
            {
                using (StoredProcedure sp = new StoredProcedure("prcDeleteTimezoneDaylightSavingRule",
                StoredProcedure.CreateInputParam("@TimezoneId", SqlDbType.Int, this.tzId),
                StoredProcedure.CreateInputParam("@RuleID", SqlDbType.Int, this.ruleId)))
                {
                    sp.ExecuteNonQuery();
                }
            }

            bool error = false;

            if (!this.chkDelete.Checked)
            {

                this.tzWrittenName = ViewState["WrittenName"].ToString();

                int firstYearStart;
                Int32.TryParse(this.txtFirstYearStart.Text, out firstYearStart);

                int lastYearStart;
                Int32.TryParse(this.txtLastYearStart.Text, out lastYearStart);

                int offset;
                string strOffset = this.txtOffset.Text;
                offset = ConvertStringtoMins(strOffset);

                int timeStart;
                string strtimeStart = this.txtTimeStart.Text;
                timeStart = ConvertStringtoMins(strtimeStart);

                int weekdayStart;
                Int32.TryParse(drpWeekdayStart.SelectedValue, out weekdayStart);

                int weekStart;
                Int32.TryParse(drpWeekStart.SelectedValue, out weekStart);

                int monthStart;
                Int32.TryParse(drpMonthStart.SelectedValue, out monthStart);

                int timeEnd;
                string strTimeEnd = this.txtTimeEnd.Text;
                timeEnd = ConvertStringtoMins(strTimeEnd);

                int weekdayEnd;
                Int32.TryParse(drpWeekdayEnd.SelectedValue, out weekdayEnd);

                int weekEnd;
                Int32.TryParse(drpWeekEnd.SelectedValue, out weekEnd);

                int monthEnd;
                Int32.TryParse(drpMonthEnd.SelectedValue, out monthEnd);

                if (this.isNew)
                {
                    ESTimeZone es = new ESTimeZone();
                    es.AddTimeZoneRule(this.tzWrittenName, offset, firstYearStart, lastYearStart,
                        timeStart, weekdayStart, weekStart, monthStart, timeEnd, weekdayEnd, weekEnd, monthEnd, out error);
                }
                else
                {
                    ESTimeZone es = new ESTimeZone();
                    es.UpdateTimeZoneRule(this.ruleId, this.tzWrittenName, offset, firstYearStart, lastYearStart,
                        timeStart, weekdayStart, weekStart, monthStart, timeEnd, weekdayEnd, weekEnd, monthEnd, out error);
                }

            }
            if (error)
                Response.Write(@"<script language='javascript'>alert('Overlapping rule violated');</script>");
            else
                Response.Redirect("TimeZoneEdit.aspx?timeZoneId=" + ViewState["TimezoneID"].ToString());
        }

        private int ConvertStringtoMins(string strMins)
        {
            int totalMins = 0;
            if (strMins.Contains(":"))
            {
                string[] hoursMins = strMins.Split(new char[]{':'});
                if (hoursMins.Length > 0)
                {
                    int hours = 0;
                    Int32.TryParse(hoursMins[0], out hours);
                    int mins = 0;
                    if (hoursMins.Length > 1)
                        Int32.TryParse(hoursMins[1], out mins);
                    totalMins = (hours * 60) + mins;
                }
            }
            else if (strMins.Contains("."))
            {
                string[] hoursMins = strMins.Split(new char[] { '.' });
                if (hoursMins.Length > 0)
                {
                    float fltTotalMins = 0;
                    float.TryParse(strMins, out fltTotalMins);
                    totalMins = (int) (fltTotalMins * 60);
                }
            }
            else
            {
                Int32.TryParse(strMins, out totalMins);
                totalMins *= 60;
            }

            return totalMins;
        }

        protected void btnOrgEditDaylightCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("TimeZoneEdit.aspx?timeZoneId=" + ViewState["TimezoneID"].ToString());
        }
    }
}
