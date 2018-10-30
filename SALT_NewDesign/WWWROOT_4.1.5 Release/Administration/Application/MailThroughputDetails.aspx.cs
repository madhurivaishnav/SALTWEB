using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Bdw.Application.Salt.Web.Utilities;

namespace Bdw.Application.Salt.Web.Administration.Application
{
    public partial class MailThroughputDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SqlDataSource SrcEmailsDetails = new SqlDataSource();

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            SrcEmailsDetails.ConnectionString = connectionString;

            string OrganisationName;
            OrganisationName = Request.QueryString["OrganisationName"];

            bool EmailinHour = false;
            Boolean.TryParse(Request.QueryString["EmailinHour"], out EmailinHour);

            bool EmailinDay = false;
            Boolean.TryParse(Request.QueryString["EmailinHour"], out EmailinDay);

             if (EmailinHour || EmailinDay)
            {
                if (EmailinHour)
                    SrcEmailsDetails.SelectCommand = "SELECT e.EmailId,e.ToEmail,e.ToName,e.FromEmail,e.FromName,e.CC,e.BCC,e.Subject,e.Body,dbo.udfUTCtoDaylightSavingTime(e.DateCreated, "+UserContext.UserData.OrgID+") as DateCreated ,o.OrganisationName FROM tblEmail e JOIN tblOrganisation o ON e.OrganisationId = o.OrganisationId WHERE o.OrganisationName='" + OrganisationName + "'  AND e.DateCreated BETWEEN DATEADD(hour, -1, GETUTCDATE()) AND GETUTCDATE()";
                if (EmailinDay)
                    SrcEmailsDetails.SelectCommand = "SELECT e.EmailId,e.ToEmail,e.ToName,e.FromEmail,e.FromName,e.CC,e.BCC,e.Subject,e.Body,dbo.udfUTCtoDaylightSavingTime(e.DateCreated, " + UserContext.UserData.OrgID + ") as DateCreated,o.OrganisationName FROM tblEmail e JOIN tblOrganisation o ON e.OrganisationId = o.OrganisationId WHERE o.OrganisationName='" + OrganisationName + "' AND e.DateCreated BETWEEN DATEADD(day, -1, GETUTCDATE()) AND GETUTCDATE()";
            }
            else
                 SrcEmailsDetails.SelectCommand = "SELECT e.EmailId,e.ToEmail,e.ToName,e.FromEmail,e.FromName,e.CC,e.BCC,e.Subject,e.Body,dbo.udfUTCtoDaylightSavingTime(e.DateCreated, " + UserContext.UserData.OrgID + ") as DateCreated,o.OrganisationName FROM tblEmail e JOIN tblOrganisation o ON e.OrganisationId = o.OrganisationId WHERE o.OrganisationName='" + OrganisationName + "'";
            grdMailThroughputDetails.DataSource = SrcEmailsDetails;
            grdMailThroughputDetails.DataBind();
        }
    }
}
