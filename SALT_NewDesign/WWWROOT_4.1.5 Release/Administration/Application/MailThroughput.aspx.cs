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
using System.ServiceProcess;
using Localization;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.Web.Administration.Application
{

    public partial class MailThroughput : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                loadData();
            }
        }

        private void loadData()
        {
            SqlDataSource SrcEmails = new SqlDataSource();
            SrcEmails.SelectCommand = "prcGetEmailThroughput";
            SrcEmails.SelectCommandType = SqlDataSourceCommandType.StoredProcedure;

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            SrcEmails.ConnectionString = connectionString;

            MailThroughputGrid.DataSource = SrcEmails;
            MailThroughputGrid.DataBind();

            MarkPercentRed();
            setButtonLabel();
        }

        private void MarkPercentRed()
        {
            string strPercentEmails = null;
            int percentEmails;
            foreach (GridViewRow grdRow in MailThroughputGrid.Rows)
            {
                strPercentEmails = grdRow.Cells[3].Text.Split(new char[] { '%' })[0];
                Int32.TryParse(strPercentEmails, out percentEmails);
                if (percentEmails > 500)
                    grdRow.Cells[3].Style.Add(HtmlTextWriterStyle.Color, "red");
            }
        }

        private void setButtonLabel()
        {
            try
            {
                String[] strArr;
                ServiceController scSendMail = null;

                BusinessServices.AppConfig ac = new BusinessServices.AppConfig();

                DataTable dt = ac.getMailServices();


                foreach (DataRow dr in dt.Rows)
                {
                    strArr = dr.ItemArray[1].ToString().Split(';');

                    if (dr.ItemArray[0].Equals("MailService_SendMail"))
                    {
                        try
                        {
                            scSendMail = new ServiceController(strArr[1], strArr[0]);
                        }
                        catch (Exception e)
                        {
                            btnServiceToggle.Text = "- No Service Permissions -";
                        }
                    }
                }

                if (scSendMail.Status != ServiceControllerStatus.Stopped)
                {
                    btnServiceToggle.Text = ResourceManager.GetString("btnStopServices");
                }
                else
                {
                    btnServiceToggle.Text = ResourceManager.GetString("btnStartServices");
                }
            }
            catch (Exception e)
            {
                ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(e, ErrorLevel.High, "Service Control", "No Permissions to access", "Please use subinacl.exe to grant permissions");
            }
 
        }

        protected void btnServiceToggle_Click(object sender, EventArgs e)
        {
            try
            {

                BusinessServices.AppConfig ac = new BusinessServices.AppConfig();
                BusinessServices.Email em = new BusinessServices.Email();

                DataTable dt = ac.getMailServices();

                String[] strArr;                

                ServiceController scQueueMail = null;
                ServiceController scQueueReports = null;
                ServiceController scSendMail = null;


                foreach (DataRow dr in dt.Rows)
                {
                    strArr= dr.ItemArray[1].ToString().Split(';');

                    if (dr.ItemArray[0].Equals("MailService_QueueMail"))
                    {
                        scQueueMail = new ServiceController (strArr[1],strArr[0]);
                    }
                    else if(dr.ItemArray[0].Equals("MailService_QueueReports"))
                    {
                        scQueueReports = new ServiceController (strArr[1],strArr[0]);
                    }
                    else if(dr.ItemArray[0].Equals("MailService_SendMail"))
                    {
                        scSendMail = new ServiceController (strArr[1],strArr[0]);
                    }

                }

                //String username = System.Security.Principal.WindowsIdentity.GetCurrent().Name;// used for debugging
                
                // if its stopped then start it
                if (scSendMail.Status == ServiceControllerStatus.Stopped)
                {
                    em.purgeAutoEmails();

                    // set the send mail flag to allow emails to be sent
                    ac.Update("SEND_AUTO_EMAILS", "YES");

                    scSendMail.Start();
                    scSendMail.WaitForStatus(ServiceControllerStatus.Running, new TimeSpan(0, 0, 10));
                    scSendMail.Refresh();
                }
                // if its started then stop it
                else if (scSendMail.Status == ServiceControllerStatus.Running)
                {
                    em.purgeAutoEmails();

                    // set the send mail flag to stop emails from being sent
                    ac.Update("SEND_AUTO_EMAILS", "NO");

                    // restart report queuing
                    restartService(scQueueReports);

                    scSendMail.Stop();
                    scSendMail.WaitForStatus(ServiceControllerStatus.Stopped, new TimeSpan(0, 0, 10));
                    scSendMail.Refresh();

                    // restart mail queuing service
                    restartService(scQueueMail);                    
                }

                //username = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
                setButtonLabel();
            }
            catch (Exception ex) 
            {
                ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "Service Control", "Panic button pressed", ex.Message);
            } 
        }


        private void purgeEmails()
        {
 
        }

        private void restartService(ServiceController sc)
        {

            try
            {
                if (sc.Status != ServiceControllerStatus.Stopped)
                {
                    sc.Stop();
                    sc.WaitForStatus(ServiceControllerStatus.Stopped, new TimeSpan(0, 0, 10));
                }
                sc.Start();
                sc.WaitForStatus(ServiceControllerStatus.Running, new TimeSpan(0, 0, 10));
                sc.Refresh();
            }
            catch (Exception ex)
            {
                ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "Service Control", "Panic button pressed", ex.Message);
            } 
        }

        protected void MailThroughputGrid_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            MailThroughputGrid.PageIndex = e.NewPageIndex;
            loadData();
            BindGridView();
            MarkPercentRed();
        }

        protected void GridView1_Sorting(object sender, GridViewSortEventArgs e)
        {
            string sortExpression = e.SortExpression.ToString();
            //string sortDirection = "ASC";

            if (null == ViewState["sortorder"])
            {
                ViewState["sortorder"] = "";
                ViewState["orderdire"] = "";

                //this.MailThroughputGrid.Attributes["SortExpression"] = "OrganisationName";
                //this.MailThroughputGrid.Attributes["SortDirection"] = "asc";
            }

            if (ViewState["sortorder"].ToString() == sortExpression) 
            { 
                if (ViewState["orderdire"].ToString() == "desc")
                    ViewState["orderdire"] = "asc"; 
                else                  
                    ViewState["orderdire"] = "desc"; 
            }
            else 
            {
                ViewState["sortorder"] = sortExpression;
                ViewState["orderdire"] = "asc"; 
            }

            //if (sortExpression == this.MailThroughputGrid.Attributes["SortExpression"])
            //{
            //    sortDirection = (this.MailThroughputGrid.Attributes["SortDirection"].ToString() == sortDirection ? "DESC" : "ASC");
            //}

            //this.MailThroughputGrid.Attributes["SortExpression"] = sortExpression;
            //this.MailThroughputGrid.Attributes["SortDirection"] = sortDirection;

            loadData();
            this.BindGridView();
            MarkPercentRed();
        }

        private void BindGridView()
        {

            //string sortExpression = this.MailThroughputGrid.Attributes["SortExpression"];
            //string sortDirection = this.MailThroughputGrid.Attributes["SortDirection"];
            if (null == ViewState["sortorder"])
            {
                return;
            }
            string sortExpression = ViewState["sortorder"].ToString();
            string sortDirection = ViewState["orderdire"].ToString();

            if ((!string.IsNullOrEmpty(sortExpression)) && (!string.IsNullOrEmpty(sortDirection)))
            {

                SqlDataSource SrcData = MailThroughputGrid.DataSource as SqlDataSource;
                if (SrcData != null)
                {
                    DataView srcDataView = (DataView)SrcData.Select(DataSourceSelectArguments.Empty);
                    //srcDataView.Sort = string.Format("{0} {1}", sortExpression, sortDirection);
                    srcDataView.Sort = string.Format("{0} {1}", sortExpression, sortDirection);
                    
                    this.MailThroughputGrid.DataSource = srcDataView;
                    this.MailThroughputGrid.DataBind();

                }
            }

        }
    }
}
