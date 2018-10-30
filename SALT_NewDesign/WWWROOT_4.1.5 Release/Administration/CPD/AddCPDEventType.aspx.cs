using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Bdw.Application.Salt.Web.Utilities;
using System.Data;
using Localization;

namespace Bdw.Application.Salt.Web.Administration.CPD
{
    public partial class AddCPDEventType : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                EventType();
            }
        }
        protected void btnSave_Click(object sender, System.EventArgs e)
        {
            lblMessage.Text = "";
            if (Page.IsValid)
            {
                if (txtEventTypeName.Text.ToString().Trim() != "")
                {
                    BusinessServices.Event objEvent = new BusinessServices.Event();
                    int OrganisationID = UserContext.UserData.OrgID;

                    DataTable dtEventType = objEvent.GetEventType(txtEventTypeName.Text.ToString().Trim(), OrganisationID);
                    if (dtEventType.Rows.Count > 0)
                    {
                        lblMessage.Text = ResourceManager.GetString("EventExists");
                    }
                    else
                    {
                        objEvent.AddEventType(txtEventTypeName.Text.ToString().Trim(), OrganisationID, Convert.ToInt32(cboStatus.SelectedValue));
                        EventType();
                        lblMessage.Text = ResourceManager.GetString("SaveSuccess");
                    }
                }
            }
        }
        #region EventType Edit
        protected void EventType()
        {
            BusinessServices.Event objEvent = new BusinessServices.Event();
            int PageSize = ApplicationSettings.PageSize;
            this.gvImage.PageSize = PageSize;

            int OrganisationID = UserContext.UserData.OrgID;
            DataTable dtPolicyPoints = objEvent.GetEventType(OrganisationID);
            if (dtPolicyPoints.Rows.Count > 0)
            {
                gvImage.DataSource = dtPolicyPoints;
                gvImage.DataBind();
            }
        }
        protected void gvImage_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvImage.EditIndex = e.NewEditIndex;
            EventType();

        }
        // update event    
        protected void gvImage_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

            BusinessServices.Event objProfile = new BusinessServices.Event();
            TextBox EventTypeName = (TextBox)gvImage.Rows[e.RowIndex].FindControl("txtImageName");

            string EventTypeId = gvImage.DataKeys[e.RowIndex].Value.ToString();



            objProfile.EventTypeId = int.Parse(EventTypeId);
            objProfile.EventTypeName = EventTypeName.Text;
            objProfile.UpdateEventType(objProfile);

            gvImage.EditIndex = -1;
            EventType();
        }
        // cancel edit event    
        protected void gvImage_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvImage.EditIndex = -1;
            EventType();
        }
        //delete event    
        protected void gvImage_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridViewRow row = (GridViewRow)gvImage.Rows[e.RowIndex];
            Label lbldeleteid = (Label)row.FindControl("lblImgId");

            BusinessServices.Event objProfile = new BusinessServices.Event();
            objProfile.EventTypeId = int.Parse(lbldeleteid.Text);
            objProfile.DeleteEventType(objProfile);


            EventType();
        }

        protected void OnPageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvImage.PageIndex = e.NewPageIndex;
            this.EventType();
        }

        #endregion
    }
}
