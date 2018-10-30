using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Configuration;
using System.Collections.ObjectModel;

using Localization;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.Web.Administration.Organisation
{
    public partial class TimeZone : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ResourceManager.RegisterLocaleResource("ConfirmMessage");
            pagTitle.InnerText = ResourceManager.GetString("pagTitle");

            if (!Page.IsPostBack)
            {
                PopulateUIControls();
                GetTimeZoneList();
            }
        }

        private void PopulateUIControls()
        {
            ReadOnlyCollection<TimeZoneInfo> timeZones = TimeZoneInfo.GetSystemTimeZones();

            //Got TimeZoneID, convert to TimeZone.standardName
            String stTimeZone = "AUS Eastern Standard Time";

            int SelIndex = 0;
            foreach (TimeZoneInfo timeZone in timeZones)
            {
                listTimeZone.Items.Add(timeZone.DisplayName);
                if (timeZone.StandardName == stTimeZone)
                {
                    SelIndex = listTimeZone.Items.Count - 1;
                }
            }
            listTimeZone.SelectedIndex = SelIndex;


            this.btnImport.Attributes.Add("onclick","javascript:return SaveConfirm();");

        }

        private void GetTimeZoneList()
        {
            // Get all the timezone

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string sqlSelect = "select TimeZoneID, WrittenName from tblTimeZone where active=1 order by WrittenName";

            DataTable dtbTimeZone = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect).Tables[0];

            if (dtbTimeZone.Rows.Count > 0)
            {
                this.dtgTimezone.DataKeyField = "TimeZoneID";
                this.dtgTimezone.DataSource = dtbTimeZone;
                this.dtgTimezone.DataBind();
                
            }
            else
            {
                //this.butSaveAll.Visible = false;
                this.lblMessage.Text = ResourceManager.GetString("lblMessage.NoTimezone");//"No courses were found";
                this.lblMessage.CssClass = "FeedbackMessage";
            }

        }

        protected void onPageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            int startIndex;
            startIndex = dtgTimezone.CurrentPageIndex * dtgTimezone.PageSize;
            dtgTimezone.CurrentPageIndex = e.NewPageIndex;
            GetTimeZoneList();
        }


        protected void btnNew_Click(object sender, EventArgs e)
        {
            Response.Redirect("TimeZoneEdit.aspx");				
        }

        protected void btnImport_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            ReadOnlyCollection<TimeZoneInfo> timeZones = TimeZoneInfo.GetSystemTimeZones();

            //int b = 0;
            ESTimeZone TZ = new ESTimeZone();
            ArrayList al;
            foreach (TimeZoneInfo timeZone in timeZones)
            {
                //b++;
                string name = timeZone.StandardName;//WrittenName
                string displayName = timeZone.DisplayName;//FLB_Name
                double totalMinutes = timeZone.BaseUtcOffset.TotalMinutes;
                int offset = Convert.ToInt32(totalMinutes);//OffsetUTC

                al = new ArrayList();
                al.Add(new SqlParameter("@offset", offset));
                al.Add(new SqlParameter("@displayName", displayName));
                al.Add(new SqlParameter("@active", 1));
                al.Add(new SqlParameter("@name", name));

                Console.WriteLine("{0}   Start Date: {1:D}", "   ", displayName);

                string sqlUpdate = @"UPDATE tblTimeZone
                                       SET OffsetUTC = @offset
                                          ,FLB_Name = @displayName
                                          ,Active = @active
                                     WHERE WrittenName=@name select TimeZoneID from tblTimeZone WHERE WrittenName=@name";
                DataSet ds = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlUpdate, (SqlParameter[])al.ToArray(typeof(SqlParameter)));
                string newID = "";
                if (ds.Tables[0].Rows.Count == 0)
                {
                    
                    string sqlInsert = "INSERT INTO tblTimeZone (OffsetUTC,FLB_Name,Active,WrittenName) " +
                                       "VALUES (@offset, @displayName ,@active, @name) SELECT @@IDENTITY";
                    ds = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlInsert, (SqlParameter[])al.ToArray(typeof(SqlParameter)));
                }
                newID = Convert.ToString(ds.Tables[0].Rows[0][0]);

                //reimport daylightsaving
                if (timeZone.SupportsDaylightSavingTime)
                {
                    //delete all of existing
                    string sqlDelete = "delete tblTimeZoneDaylightSavingRules where TimezoneID=@timezoneID";
                    al = new ArrayList();
                    al.Add(new SqlParameter("@timezoneID", newID));
                    SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sqlDelete, (SqlParameter[])al.ToArray(typeof(SqlParameter)));

                    //re add all of them
                    TimeZoneInfo.AdjustmentRule[] adjustRules = timeZone.GetAdjustmentRules();
                    
                    foreach (TimeZoneInfo.AdjustmentRule rule in adjustRules)
                    {
                        bool error = false;

                        TimeZoneInfo.TransitionTime transTimeStart = rule.DaylightTransitionStart;
                        TimeZoneInfo.TransitionTime transTimeEnd = rule.DaylightTransitionEnd;
                        TZ.AddTimeZoneRule(timeZone.StandardName,
                                        rule.DaylightDelta.Hours * 60 + rule.DaylightDelta.Minutes,
                                        rule.DateStart.Year,
                                        rule.DateEnd.Year,
                                        transTimeStart.TimeOfDay.Hour * 60 + transTimeStart.TimeOfDay.Minute,
                                        (int)transTimeStart.DayOfWeek + 1,
                                        transTimeStart.Week,
                                        transTimeStart.Month,
                                        transTimeEnd.TimeOfDay.Hour * 60 + transTimeEnd.TimeOfDay.Minute,
                                        (int)transTimeEnd.DayOfWeek + 1,
                                        transTimeEnd.Week,
                                        transTimeEnd.Month,
                                        out error);
                    }

                }

                                
                //if (b == 5 ) break;
            }

            Response.Redirect("TimeZone.aspx");				
            Console.WriteLine("----");
        }

    }
}
