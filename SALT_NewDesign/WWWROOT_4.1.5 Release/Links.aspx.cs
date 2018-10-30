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

using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Localization;

namespace Bdw.Application.Salt.Web
{
	/// <summary>
	/// Displays the links to external sites / internal files for a particular organisation
	/// </summary>
    /// <remarks>
    /// Assumptions: None.
    /// Notes: None.
    /// Author: Gavin Buddis.
    /// Date: 26/02/2004
    /// Changes:
    /// </remarks>
    public partial class Links : System.Web.UI.Page
	{
        #region Protected Variables
        /// <summary>
        /// The repeater control for the list of links.
        /// </summary>
        protected System.Web.UI.WebControls.Repeater rptLinks;

        /// <summary>
        /// Label for Page Titles
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;
        
        /// <summary>
        /// Link for the URLs.
        /// </summary>
        protected System.Web.UI.WebControls.HyperLink lnkURL;

        /// <summary>
        /// Label for disclaimer
        /// </summary>
        protected System.Web.UI.WebControls.Label lblDisclaimer;

        #endregion

        #region Private Event Handlers
        /// <summary>
        /// Event Handler for the Page Load event.
        /// </summary>
        /// <param name="sender"> The source of the event.</param>
        /// <param name="e"> Any arguments that the event fires.</param>
        protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");

            // Set the label in the page header 
            this.Context.Items["SectionTitle"] = ResourceManager.GetString("lblSectionTitle");//"Links";
            if (!Page.IsPostBack)
            {
                SetPageState();
            }
		}
		
		/// <summary>
		/// Event handler for the item data bounmd event for the repeater.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		private void rptLinks_ItemDataBound(object sender, System.Web.UI.WebControls.RepeaterItemEventArgs e)
		{
			DataRowView drvLinkDetails = (DataRowView)e.Item.DataItem;
			
			//1. Check to see if this link needs to display the disclaimer.
            HyperLink lnkURL = (HyperLink)(e.Item.Controls[1].FindControl("lnkURL"));
            Label lblCategory = (Label)e.Item.Controls[0].FindControl("lblCategory");
                

            // If it has no length then disable the link as its just a category
            if (drvLinkDetails["Url"].ToString().Length==0)
            {
                // adjust the style of the row
                HtmlTableRow rowTable = (HtmlTableRow)(e.Item.Controls[1].FindControl("TableRow"));
                rowTable.Attributes.Add("class","tablerowtop");
                
                // make the label visible
                lblCategory.Text = drvLinkDetails["Caption"].ToString();
                lblCategory.Visible=true;

                lnkURL.Visible=false;
                
            }
            else
            {
                lnkURL.Visible=true;
                lblCategory.Visible=false;
            }
            // If it is to show the disclaimer
            if((bool)drvLinkDetails["ShowDisclaimer"])
			{
				//2. Make a reference to the html anchor.
				lnkURL.Attributes.Add("onclick", "return showDisclaimer()");
			}
          

		}
        #endregion

        #region Private Methods
        /// <summary>
        /// Sets the State of the page
        /// </summary>
        private void SetPageState()
        {
            Page.RegisterClientScriptBlock("showDisclaimer",
                "<script language='javascript'>" +
			    "    function showDisclaimer()" +
			    "        {" +
				"            return window.confirm(\""+ Utilities.ApplicationSettings.ExternalLinkDisclaimer+"\");" +
			    "        }" +
		        "</script>");
            // Retrieve the list of links for the current organisation
            DataTable dtbLinks = Link.GetLinksByOrganisation(UserContext.UserData.OrgID);

            // Bind the data table of links to the repeater UI control
            rptLinks.DataSource = dtbLinks;
            rptLinks.DataBind();
        }
        #endregion

		#region Web Form Designer generated code

        /// <summary>
        /// This call is required by the ASP.NET Web Form Designer. 
        /// </summary>
        /// <param name="e">EventArgs</param>
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
            this.rptLinks.ItemDataBound += new System.Web.UI.WebControls.RepeaterItemEventHandler(this.rptLinks_ItemDataBound);
        }
		#endregion
	}
}
