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
using System.Net;
using System.Text;
using System.Web.SessionState;


namespace Bdw.Application.Salt.Web.Reporting.Individual
{
    public partial class TestCPD : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
               
                string str = Globals.MyGlobalValue;
                if (str != "")
                    PopulateGrid.InnerHtml = str;

            }
        }
    }
}
