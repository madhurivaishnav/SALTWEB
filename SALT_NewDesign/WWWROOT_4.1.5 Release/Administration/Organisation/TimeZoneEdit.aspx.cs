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

namespace Bdw.Application.Salt.Web.Administration.Organisation
{
    public partial class TimeZoneEdit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            pagTitle.InnerText = ResourceManager.GetString("pagTitle");
            if (!this.IsPostBack)
            {
                String timezoneId = Request.QueryString["timeZoneId"];
                this.txtTimezoneID.Text = timezoneId;
                getTimeZoneDetail(timezoneId);
                if (!String.IsNullOrEmpty(timezoneId)) 
                {
                    getDLSList(timezoneId);
                }
                
            }


        }

        private void getDLSList(String timezoneId)
        {
            // Get all the daylight saving
            SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@TimezoneID", timezoneId) };
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string sqlSelect = "select TimeZoneID, TimezoneRuleID, start_year, year=convert(varchar(10),start_year), ruleid=convert(varchar(10),TimezoneRuleID) from tblTimeZoneDaylightSavingRules where TimezoneID=@timezoneId order by start_year";

            DataTable dtbDLS = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];

            DataRow   dr   =   dtbDLS.NewRow();
            dr["TimeZoneID"] = 0;
            dr["year"] = "NEW";
            dr["ruleid"] = "NEW";
            dtbDLS.Rows.Add(dr);

            if (dtbDLS.Rows.Count > 0)
            {
                this.dtgDLSRule.DataKeyField = "TimeZoneID";
                this.dtgDLSRule.DataSource = dtbDLS;
                this.dtgDLSRule.DataBind();
            }
            else
            {
                //this.butSaveAll.Visible = false;
//                this.lblMessage.Text = ResourceManager.GetString("lblMessage.NoDLS");//"No courses were found";
//                this.lblMessage.CssClass = "FeedbackMessage";
            }

        }

        private void getTimeZoneDetail(String timezoneId)
        {
            SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@TimezoneID", timezoneId) };
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string sqlSelect = "select TimeZoneID, WrittenName, OffsetUTC, FLB_Name from tblTimeZone where TimezoneID=@timezoneId";

            DataTable dtbTimeZone = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];
            if (dtbTimeZone.Rows.Count > 0)
            {
                txtTimezoneName.Text = dtbTimeZone.Rows[0]["WrittenName"].ToString().Trim();
                txtTimezoneDisplayName.Text = dtbTimeZone.Rows[0]["FLB_Name"].ToString().Trim();
                offsetList.SelectedValue = dtbTimeZone.Rows[0]["OffsetUTC"].ToString();
                txtTimezoneID.Text = dtbTimeZone.Rows[0]["TimeZoneID"].ToString();
            }

        }

        protected void onPageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            int startIndex;
            startIndex = dtgDLSRule.CurrentPageIndex * dtgDLSRule.PageSize;
            dtgDLSRule.CurrentPageIndex = e.NewPageIndex;
            getDLSList(txtTimezoneID.Text);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            ArrayList al = new ArrayList();
            al.Add(new SqlParameter("@WrittenName", this.txtTimezoneName.Text.Trim()));
            al.Add(new SqlParameter("@OffsetUTC", this.offsetList.SelectedValue));
            al.Add(new SqlParameter("@FLB_Name", this.txtTimezoneDisplayName.Text.Trim()));
            string sql;
            //save here
            if (!string.IsNullOrEmpty(this.txtTimezoneID.Text))
            {//update

                if (isExist(this.txtTimezoneID.Text))
                {
                    this.lblMessage.Text = "Duplicate timezone name or display name.";
                    this.lblMessage.CssClass = "FeedbackMessage";
                    return;
                }

                sql = @"UPDATE tblTimeZone
                        SET WrittenName = @WrittenName
                           ,OffsetUTC = @OffsetUTC
                           ,FLB_Name = @FLB_Name 
                           ,Active = @Active  
                           WHERE TimeZoneID=@TimeZoneID";
                if (deleteTimezone.Checked)
                {
                    al.Add(new SqlParameter("@Active", "0"));
                }
                else
                {
                    al.Add(new SqlParameter("@Active", "1"));
                }
                al.Add(new SqlParameter("@TimeZoneID", this.txtTimezoneID.Text));

                SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sql, (SqlParameter[])al.ToArray(typeof(SqlParameter)));

                //refresh here
                Response.Redirect("TimeZone.aspx");				
            }
            else
            {//insert

                if (isExist(null))
                {
                    this.lblMessage.Text = "Duplicate timezone name or display name.";
                    this.lblMessage.CssClass = "FeedbackMessage";
                    return;
                }

                al.Add(new SqlParameter("@Active", "1"));
                sql = "INSERT INTO tblTimeZone (WrittenName,OffsetUTC,FLB_Name,Active)" +
                      "VALUES (@WrittenName, @OffsetUTC ,@FLB_Name,@Active) SELECT @@IDENTITY";

                DataSet ds = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, sql, (SqlParameter[])al.ToArray(typeof(SqlParameter)));
                string newID = Convert.ToString(ds.Tables[0].Rows[0][0]);

                //refresh here
                Response.Redirect("TimeZoneEdit.aspx?timeZoneId=" + newID);				
            }


        }

        private Boolean isExist(string timezoneId)
        {
            Boolean ret = false;
            ArrayList al = new ArrayList();
            al.Add(new SqlParameter("@WrittenName", this.txtTimezoneName.Text.Trim()));
            al.Add(new SqlParameter("@FLB_Name", this.txtTimezoneDisplayName.Text.Trim()));

            string sqlSelect = "";
            if (!String.IsNullOrEmpty(timezoneId))
            {
                al.Add(new SqlParameter("@TimeZoneID", this.txtTimezoneID.Text));
                sqlSelect = "select * from tblTimeZone where (WrittenName=@WrittenName or FLB_Name=@FLB_Name) and TimeZoneID!=@TimeZoneID";
            }
            else
            {
                sqlSelect = "select * from tblTimeZone where WrittenName=@WrittenName or FLB_Name=@FLB_Name";
            }

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            
            DataTable dtbTimeZone = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, (SqlParameter[])al.ToArray(typeof(SqlParameter))).Tables[0];
            if (dtbTimeZone.Rows.Count > 0)
            {
                ret = true;
            }
            return ret;
        }

    }
}
