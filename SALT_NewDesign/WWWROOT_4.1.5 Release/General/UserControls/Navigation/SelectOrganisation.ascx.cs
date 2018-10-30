namespace Bdw.Application.Salt.Web.General.UserControls.Navigation
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.Security;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using Bdw.Application.Salt.Web.Utilities;
	using Bdw.Application.Salt.Data;
	using Bdw.Application.Salt.BusinessServices;

	/// <summary>
	///	Summary description for SelectOrganisation.
	/// </summary>
	/// <remarks>
	/// Assumptions: None.
	/// Notes: None.
	/// Author: Jack Liu.
	/// Date: 25/02/0/2004
	/// Changes:
	/// </remarks>
	public partial class SelectOrganisation : System.Web.UI.UserControl
	{
		#region Protected Controls
		/// <summary>
		/// HTML table for the organisation drop down list.
		/// </summary>
		protected System.Web.UI.HtmlControls.HtmlTable tblOrganisation;
		
		/// <summary>
		/// Drop down list that holds all the organisation names.
		/// </summary>
		/// <remarks>
		/// This will only hold those organisation that the user has access to.
		/// In the case of a Salt Administrator this will be all the organisations in the database.
		/// </remarks>
		protected System.Web.UI.WebControls.DropDownList cboOrganisationName;
		#endregion
		
		#region Private Event Handlers
		/// <summary>
		/// Event handler method for the page load event.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			if(!Page.IsPostBack)
			{
				// Sets the state of this control based on the UserType of the logged in user.
				// Set the Organisation List for the Salt Administrator.
				this.SetOrganisationList();
			}

		}
		
		/// <summary>
		/// Event handler method for the selected index changed event on the organisation drop down list.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void cboOrganisationName_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			int intSelectedOrganisationID; // Holds the ID of the organisation selected in the drop down list.
			
			if (this.cboOrganisationName.SelectedIndex > -1)
			{
				// Get the organisation ID from the drop down list.
				intSelectedOrganisationID = int.Parse(this.cboOrganisationName.SelectedValue);
			
				// Save the selected organisation in the user context.
				WebSecurity.SelectOrganisation(intSelectedOrganisationID);
			
				// Check which menu the control is being generated from and redirect to that sections home page.
			}
			if(HttpContext.Current.Items["Section"].ToString() == "Reporting")
			{
				Response.Redirect("/Reporting/ReportingHome.aspx");
			}
			else
			{
				Response.Redirect("/Administration/AdministrationHome.aspx");
			}
		} // cboOrganisationName_SelectedIndexChanged
		#endregion

		#region Private Methods

		/// <summary>
		/// Sets the organisation list for the salt admin.
		/// </summary>
		private void SetOrganisationList()
		{
			// Check to see if the User is a SaltAdmin, 
			// if not hide the organisation drop down list
			if(UserContext.UserData.UserType != UserType.SaltAdmin)
			{
				// Make the drop down list invisible.
				this.tblOrganisation.Visible = false;
			}
			else // Show Drop down list if user is Salt Admin.
			{
				//1. Get a list of organisations, and bind to the list control.
				Organisation objOrganisation = new Organisation();
				DataTable dtbOrganisationDetails; // Data table to hold the organisation details.
				dtbOrganisationDetails = objOrganisation.GetOrganisationList();
				int intSelectedOrganisationID; // Holds the selected organisation ID.
				
				this.cboOrganisationName.DataSource = dtbOrganisationDetails;
				this.cboOrganisationName.DataTextField = "OrganisationName";
				this.cboOrganisationName.DataValueField  = "OrganisationID";
				this.cboOrganisationName.DataBind();
				
                
				//2. Get Selected organisation
                intSelectedOrganisationID = UserContext.UserData.OrgID;
				
				
				//3. Select the selected organisation
				// Check to see if there is more than one organisation in the database.
				if(dtbOrganisationDetails.Rows.Count > 1)
				{
					// Set the selected organisation.
					this.cboOrganisationName.Items.FindByValue(intSelectedOrganisationID.ToString()).Selected = true;
					
					// Make the drop down list visible.
					this.tblOrganisation.Visible = true;
				}
				else // There is only one Organisation in the database.
				{
					//Make the drop down list invisible.
					this.tblOrganisation.Visible = false;
				}
			}
		}
		#endregion Private Methods


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
		} // OnInit
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{

		}		
        #endregion
	}
}