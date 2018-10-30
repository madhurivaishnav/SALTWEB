using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Data.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Linq.Expressions;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.Web.Reporting
{
    public partial class PeriodicReportList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (UserContext.UserData.UserType == UserType.User)
                Response.Redirect("~/Default.aspx");
            if ((Request.QueryString["user"] == null) && (Request.QueryString["isoninactivate"] != "true"))
            {
                PeriodicReportListControl prlc = (PeriodicReportListControl)Page.LoadControl("/Reporting/PeriodicReportListControl.ascx");
                prlc.Username = "";
                PeriodicReportListHolder.Controls.Add(prlc);
            }
            else if ((Request.QueryString["user"] != null) && (Request.QueryString["isoninactivate"] != "true"))
            {
                PeriodicReportListControl prlc = (PeriodicReportListControl)Page.LoadControl("/Reporting/PeriodicReportListControl.ascx");
                int userId = 0;
                Int32.TryParse(Request.QueryString["user"].ToString(), out userId);
                BusinessServices.User user = new BusinessServices.User();
                DataTable dtUser = user.GetUser(userId);
                prlc.Username = dtUser.Rows[0]["UserName"].ToString();
                PeriodicReportListHolder.Controls.Add(prlc);
            }
            else if ((Request.QueryString["user"] == null) && (Request.QueryString["isoninactivate"] == "true"))
            {
                PeriodicReportInactiveListControl prilc = (PeriodicReportInactiveListControl)Page.LoadControl("/Reporting/PeriodicReportInactiveListControl.ascx");
                prilc.IsOnInactivate = true;
                prilc.Username = "";
                PeriodicReportListHolder.Controls.Add(prilc);
            }
            else if ((Request.QueryString["user"] != null) && (Request.QueryString["isoninactivate"] == "true"))
            {
                PeriodicReportInactiveListControl prilc = (PeriodicReportInactiveListControl)Page.LoadControl("/Reporting/PeriodicReportInactiveListControl.ascx");
                prilc.IsOnInactivate = true;
                int userId = 0;
                Int32.TryParse(Request.QueryString["user"].ToString(), out userId);
                BusinessServices.User user = new BusinessServices.User();
                DataTable dtUser = user.GetUser(userId);
                prilc.Username = dtUser.Rows[0]["UserName"].ToString();
                PeriodicReportListHolder.Controls.Add(prilc);
            }            
        }
    }
}
