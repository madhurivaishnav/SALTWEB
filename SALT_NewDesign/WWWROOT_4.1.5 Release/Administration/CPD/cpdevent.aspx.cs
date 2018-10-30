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

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.CPD
{
    public partial class cpdevent : System.Web.UI.Page
    {
        protected System.Web.UI.WebControls.Repeater rptPolicy;
        protected Localization.LocalizedLinkButton lnkEdit;
        protected Localization.LocalizedLinkButton lnkSave;
        protected Localization.LocalizedLinkButton lnkCancel;
        private int GEventid;
        private int GEventrowcount;
        protected void Page_Load(object sender, System.EventArgs e)
        {
            try
            {
                //Response.AddHeader("Refresh", Convert.ToString((Session.Timeout*60)-10));
                pagTitle.Text = ResourceManager.GetString("pagTitle");
                if (!Page.IsPostBack)
                {
                    BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
                    if (objOrganisation.GetOrganisationCPDEventAccess(UserContext.UserData.OrgID))
                    {
                        CPDBindGrid();
                    }
                    else// dosnt have access to CPD 
                    {
                        panCPD.Visible = false;
                        this.btnCreateEvent.Visible = false;
                        lblMessage.Text = ResourceManager.GetString("NoAccess");
                        lblMessage.CssClass = "WarningMessage";
                    }
                }
            }
            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "cpdevent.aspx.cs", "Page_Load", "GetFilename");
                throw (Ex);
            }

        }
        private void CPDBindGrid()
        {
            try
            {
                DataTable dtEvents = GetEvent();


                int PageSize = ApplicationSettings.PageSize;
                this.dgrCPD.PageSize = PageSize;
                if (dtEvents.Rows.Count > 0)
                {
                    dgrCPD.DataSource = dtEvents;
                    dgrCPD.DataBind();
                    DisplayEvents(dtEvents);
                }
            }
            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "cpdevent.aspx.cs", "CPDBindGrid", "GetFilename");
                throw (Ex);
            }
        }
        private DataTable GetEvent()
        {
            int OrganisationID = UserContext.UserData.OrgID;
            BusinessServices.Event org = new BusinessServices.Event();
            DataTable dtPolicies = org.GetOrganisationEvents(OrganisationID);
            return dtPolicies;
        }
        private void DisplayEvents(DataTable dtEvents)
        {
            try
            {
                lblMessage.Text = String.Empty;
                panCPD.Visible = (dtEvents.Rows.Count > 0);

                if (dtEvents.Rows.Count == 0)
                {
                    lblMessage.Text = ResourceManager.GetString("NoProfiles");
                    lblMessage.CssClass = "WarningMessage";
                }
            }
            catch (Exception Ex)
            {
                ErrorHandler.ErrorLog Error = new ErrorHandler.ErrorLog(Ex, ErrorLevel.Medium, "cpdevent.aspx.cs", "DisplayEvents", "GetFilename");
                throw (Ex);
            }
        }
        #region Web Form Designer generated code
        override protected void OnInit(EventArgs e)
        {
            //
            // CODEGEN: This call is required by the ASP.NET Web Form Designer.
            //
            InitializeComponent();
            base.OnInit(e);
            //dgrCPD.Columns[2].HeaderText = ResourceManager.GetString("profile_name");
            //dgrCPD.Columns[3].HeaderText = ResourceManager.GetString("current_period");
            //dgrCPD.Columns[4].HeaderText = ResourceManager.GetString("future_period");
            //dgrCPD.Columns[5].HeaderText = ResourceManager.GetString("status");
            //dgrCPD.Columns[6].HeaderText = ResourceManager.GetString("action");
            //EditCommandColumn ecc = (EditCommandColumn)dgrCPD.Columns[6];
            //ecc.EditText = ResourceManager.GetString("edit");
        }
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.dgrCPD.ItemCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.dgrCPD_ItemCommand);
            this.dgrCPD.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrCPD_ItemDataBound);
            //this.dgrCPD.PageIndexChanged += new System.Web.UI.WebControls.DataGridItemEventHandler(this.dgrCPD_PageIndexChanged);
            this.dgrCPD.PageIndexChanged += new DataGridPageChangedEventHandler(dgrCPD_PageIndexChanged);

        }
        #endregion
        protected void btnCreateEvent_Click(object sender, System.EventArgs e)
        {
            // Get existing data source
            //			DataTable dtEvents = GetEvents();
            //			
            //			// add new row to data source
            //			DataRow drEvents = dtEvents.NewRow();
            //			dtEvents.Rows.Add(drEvents);//DataSet.newRow
            //			// databind to repeater control
            //			dgrCPD.DataSource = dtEvents;
            //			dgrCPD.EditItemIndex = (dtEvents.Rows.Count - 1); //TODO - need to change this to get index of newly added row
            //			dgrCPD.DataBind();
            //			
            //			DisplayEvents(dtEvents);
            //Above redundant - new functional spec specifies that on create new Event should direct to cpddetail.aspx page
            Session["EventID"] = @"-1";
            Session["EventPeriodID"] = @"-1";
            Response.Redirect(@"\Administration\CPD\cpdeventdetail.aspx");
        }
        private void ClearMessage()
        {
            this.lblMessage.Text = String.Empty;
        }
        private void dgrCPD_ItemCommand(object source, System.Web.UI.WebControls.DataGridCommandEventArgs e)
        {
            if (e.CommandName != "Page")
            {
                string EventPeriodIDValue = @"-1";
                string Action = e.CommandName;

                Label EventID = (Label)e.Item.FindControl("lblEventID");
                Label EventPeriodID = (Label)e.Item.FindControl("lblEventPeriodID");

                string EventIDValue = EventID.Text;
                if (EventPeriodID.Text != "")
                {
                    EventPeriodIDValue = EventPeriodID.Text;
                }
                Session["EventID"] = EventIDValue;
                Session["EventPeriodID"] = EventPeriodIDValue;
                switch (Action)
                {
                    case "Edit":
                        Response.Redirect(@"\Administration\CPD\cpdeventdetail.aspx");
                        break;
                    case "Delete":
                        string confirmValue = Request.Form["confirm_value"];
                        if (confirmValue == "Yes")
                        {
                            //this.Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('You clicked YES!')", true);
                            BusinessServices.Event objEvent = new BusinessServices.Event();
                            objEvent.DeleteEventPeriod(Convert.ToInt32(EventPeriodIDValue));
                            Response.Redirect(@"\Administration\CPD\cpdevent.aspx");
                        }
                        else
                        {
                            //this.Page.ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('You clicked NO!')", true);

                        }
                        break;
                    case "Copy":
                        Response.Redirect(@"\Administration\CPD\cpdeventdetail.aspx?IsCopy=copy");
                        break;
                }
            }
        }
        private void dgrCPD_ItemDataBound(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
        {
            //if (e.Item.ItemType != ListItemType.Pager)
            //{
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int EventID = (int)drv["EventID"];

                BusinessServices.Event objEvent = new BusinessServices.Event();
                DataTable dtEvent = objEvent.GetEvent(EventID, -1, UserContext.UserData.OrgID);

                if (dtEvent.Rows.Count > 0)
                {
                    if (GEventid != EventID)
                    {
                        GEventid = EventID;
                        GEventrowcount = 0;
                    }
                    else
                    {
                        GEventrowcount++;
                    }
                    if (!dtEvent.Rows[GEventrowcount]["DateStart"].Equals(System.DBNull.Value))
                    {
                        DateTime dtStart = (DateTime)dtEvent.Rows[GEventrowcount]["DateStart"];
                        if (dtStart < DateTime.Now) //Current Period
                        {
                            Label lblCurrentDate = (Label)e.Item.FindControl("lblCurrentDate");
                            lblCurrentDate.Text =
                                string.Format("{0:dd/MM/yyyy}", (DateTime)dtEvent.Rows[GEventrowcount]["DateStart"])
                                + " - " +
                                string.Format("{0:dd/MM/yyyy}", (DateTime)dtEvent.Rows[GEventrowcount]["DateEnd"]);

                            Label lblStarttime = (Label)e.Item.FindControl("lblStarttime");
                            lblStarttime.Text = string.Format("{0:hh:mm tt}", (DateTime)dtEvent.Rows[GEventrowcount]["DateStart"]);

                            Label lblendtime = (Label)e.Item.FindControl("lblendtime");
                            lblendtime.Text = string.Format("{0:hh:mm tt}", (DateTime)dtEvent.Rows[GEventrowcount]["DateEnd"]);

                            Label lblFutureDate = (Label)e.Item.FindControl("lblFutureDate");
                            if (!dtEvent.Rows[GEventrowcount]["FutureDateStart"].Equals(System.DBNull.Value))
                            {
                                lblFutureDate.Text =
                                    string.Format("{0:dd/MM/yyyy}", (DateTime)dtEvent.Rows[GEventrowcount]["FutureDateStart"])
                                    + " - " +
                                    string.Format("{0:dd/MM/yyyy}", (DateTime)dtEvent.Rows[GEventrowcount]["FutureDateEnd"]);
                            }




                        }
                        else //Future Period
                        {
                            Label lblFutureDate = (Label)e.Item.FindControl("lblFutureDate");
                            lblFutureDate.Text =
                                string.Format("{0:dd/MM/yyyy}", (DateTime)dtEvent.Rows[GEventrowcount]["DateStart"])
                                + " - " +
                                string.Format("{0:dd/MM/yyyy}", (DateTime)dtEvent.Rows[GEventrowcount]["DateEnd"]);
                        }
                    }
                }
            }
            //}
        }
        private void dgrCPD_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
        {

            dgrCPD.CurrentPageIndex = e.NewPageIndex;



            CPDBindGrid();

        }
    }
}
