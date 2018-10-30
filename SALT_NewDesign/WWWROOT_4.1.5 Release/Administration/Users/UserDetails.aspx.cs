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
using Bdw.Application.Salt.Data;
using Localization;
using System.Collections.ObjectModel;
using System.Text.RegularExpressions;
using System.Linq;
using System.Collections.Generic;

using System.Configuration;
using System.Data.SqlClient;
using Bdw.Application.Salt.Web.Reporting;
using System.Data.Linq;

namespace Bdw.Application.Salt.Web.Administration.Users
{
	/// <summary>
	/// User Detail page which allows an administrator to edit 
	/// a users details, or a Salt User to edit their own details
	/// </summary>
	/// <remarks>
	/// Assumptions: A user can only have 1 Classification Type
	/// Notes: 
	/// Author: John Crawford
	/// Date: 18/02/2004
	/// Changes:
	/// </remarks>
	public partial class UserDetails : System.Web.UI.Page
	{
		#region Protected Variables

        /// <summary>
        /// Treeview for selecting units
        /// </summary>
		protected Uws.Framework.WebControl.TreeView trvUnitsSelector;

        /// <summary>
        /// Textbox for entering first name
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtFirstName;

        
        /// <summary>
        /// Textbox for entering last name
        /// </summary>
        protected System.Web.UI.WebControls.TextBox txtLastName;

        /// <summary>
        /// Table surrouding search criteria
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlTable tblSearchCriteria;

        /// <summary>
        /// Label for units
        /// </summary>
		protected Label lblUnits;


        /// <summary>
        /// Save button
        /// </summary>
		protected Localization.LocalizedButton btnSave;

        /// <summary>
        /// Textbox for entering user name
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtUserName;

        /// <summary>
        /// Textbox for confirming password
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtConfirmPassword;

        /// <summary>
        /// Textbox for entering email address
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtEmail;

        /// <summary>
        /// Label indicating user status
        /// </summary>
		protected Label lblUserStatus;

        /// <summary>
        /// Label for the last login date/time
        /// </summary>
        protected Localization.LocalizedLabel lblLastLoginLabel;

        /// <summary>
        /// Checkbox for selecting user status
        /// </summary>
		protected Localization.LocalizedCheckBox chkUserStatus;

        /// <summary>
        /// Treeview control showing unit priviledges for user
        /// </summary>
		protected Uws.Framework.WebControl.TreeView trvUnitPrivileges;

        /// <summary>
        /// Label showing admin privilidges
        /// </summary>
		protected Localization.LocalizedLabel lblAdminPrivileges;

        /// <summary>
        /// Label showing no admin privilgeges
        /// </summary>
		protected Localization.LocalizedLabel lblNoAdminPrivileges;

        /// <summary>
        /// Label showing org admin
        /// </summary>
		protected Localization.LocalizedLabel lblOrganisationAdmin;

        /// <summary>
        /// Validator for first name
        /// </summary>
		protected Localization.LocalizedRequiredFieldValidator rfvFirstName;

        /// <summary>
        /// Validator for last name
        /// </summary>
		protected Localization.LocalizedRequiredFieldValidator rfvLastName;

        /// <summary>
        /// Validator for username 
        /// </summary>
		protected Localization.LocalizedRequiredFieldValidator rfvUserName;

        /// <summary>
        /// Label for old password
        /// </summary>
		protected Localization.LocalizedLabel lblOldPassword;

        /// <summary>
        /// Textbox for old password
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtOldPassword;

        /// <summary>
        /// Validator for email field
        /// </summary>
		protected Localization.LocalizedRequiredFieldValidator rfvEmail;

        /// <summary>
        /// Validator expression for email field
        /// </summary>
		protected Localization.LocalizedRegularExpressionValidator revEmail;

        /// <summary>
        /// Validator expression for username field
        /// </summary>
		protected Localization.LocalizedRegularExpressionValidator revUserName;

        /// <summary>
        /// Validator comparison for email field
        /// </summary>
		protected Localization.LocalizedCompareValidator cpvPassword;

        /// <summary>
        /// Validator comparison for old password field
        /// </summary>
		protected Localization.LocalizedCompareValidator cpvOldPassword;

        /// <summary>
        /// Custom validator for password
        /// </summary>
		protected Localization.LocalizedCustomValidator cvlConfirmPassword;

        /// <summary>
        /// Textbox for password
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtPassword;

        /// <summary>
        /// Table row for user module access
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trwUserModuleAccess;  
  
        /// <summary>
        /// Label for Page title
        /// </summary>
        protected Label lblPageTitle;

        /// <summary>
        /// Label for password instructions
        /// </summary>
        protected Localization.LocalizedLabel lblPasswordInstruction;

        /// <summary>
        /// Validator for password
        /// </summary>
        protected Localization.LocalizedRequiredFieldValidator rvlPassword;


        /// <summary>
        /// Expression validator for new password
        /// </summary>
        protected Localization.LocalizedRegularExpressionValidator revNewPassword;

        /// <summary>
        /// Custom validator for Unit
        /// </summary>
        protected Localization.LocalizedCustomValidator cvlUnit;

        /// <summary>
        /// Link back to main page
        /// </summary>
        protected LinkButton lnkReturnTo;

        /// <summary>
        /// Custom validator for old password
        /// </summary>
        protected Localization.LocalizedCustomValidator cvlOldPassword;

        /// <summary>
        /// Label for external id
        /// </summary>
        protected Localization.LocalizedLabel lblExternalIDLabel;

        /// <summary>
        /// Label for custom classification
        /// </summary>
        protected Label lblCustomClassLabel;

        /// <summary>
        /// Drop down list for selecting custom classification
        /// </summary>
        protected System.Web.UI.WebControls.DropDownList cboCustomClass;

        /// <summary>
        /// Label for salt administrator
        /// </summary>
        protected Localization.LocalizedLabel lblApplicationAdmin;

        /// <summary>
        /// Placeholder for tree view control
        /// </summary>
        protected System.Web.UI.WebControls.PlaceHolder plhUnitSelector;

        /// <summary>
        /// Placeholder for main form
        /// </summary>
        protected System.Web.UI.WebControls.PlaceHolder plhMainForm;
		protected DataGrid grdModules;

        
		#endregion
		
		#region Private Constants
		
		// constants for all available columns returned in the datatable
		// for objUser.GetUser

		// UserColumns
		private const string cm_strTblUserUserID = "UserID";
		private const string cm_strTblUserFirstName = "FirstName";
		private const string cm_strTblUserLastName = "LastName";
		private const string cm_strTblUserUserName = "UserName";
		private const string cm_strTblUserPassword = "Password";
        private const string cm_strTblUserEmail = "Email";
        private const string cm_strTblUserManEmail = "DelinquencyManagerEmail";
        private const string cm_strTblUserSendEmail = "NotifyOfPendingDelinquencies";
        private const string cm_strTblUserExternalID = "ExternalID";
		private const string cm_strTblUserOrganisationID = "OrganisationID";
		private const string cm_strTblUserUnitID = "UnitID";
		private const string cm_strTblUserTypeID = "UserTypeID";
		private const string cm_strTblUserActive = "Active";
		private const string cm_strTblUserCreatedBy = "CreatedBy";
		private const string cm_strTblUserDateCreated = "DateCreated";
		private const string cm_strTblUserUpdatedBy = "UpdatedBy";
		private const string cm_strTblUserDateUpdated = "DateUpdated";
        private const string cm_strTblUserLastLogin = "LastLogin";
        private const string cm_strTblUserTimeZoneID = "TimeZoneID";
        private const string cm_strTblUserNotifyMgr = "NotifyMgr";
        private const string cm_strTblUserNotifyUnitAdmin = "NotifyUnitAdmin";
        private const string cm_strTblUserNotifyOrgAdmin = "NotifyOrgAdmin";
        private const string cm_strTblUserEbookNotification = "EbookNotification";

		// Unit Columns
		private const string cm_strTblUnitUnitName = "Name";

		// ClassificationType Columns
		private const string cm_strTblClassificationTypeName = "Name";
		private const string cm_strTblClassificationTypeID = "ClassificationTypeID";
		
		// classification Item columns
		private const string cm_strTblClassificationID = "ClassificationID";
		private const string cm_strTblClassificationValue = "Value";
		private const string cm_strTblClassificationActive = "Active";

		// Local ViewState Variables
		private const string viewstate_dateupdated = "DateUpdated";

		#endregion
		
		#region Private Member Variables
		
        /// <summary>
        /// stores the userID of the user being displayed
        /// </summary>
		protected int p_intUserIDToDisplay;	

        /// <summary>
        /// Unit id of the parent unit
        /// </summary>
        protected int p_intParentUnitID;

        /// <summary>
        /// Placeholder for the units
        /// </summary>
        protected System.Web.UI.WebControls.PlaceHolder plhUnit;

        /// <summary>
        /// Label for error message
        /// </summary>
        protected Label lblMessage;

        /// <summary>
        /// Label for unit error message
        /// </summary>
        protected Label lblMessageUnit;
        
        /// <summary>
        ///  The Org in which to create the new user
        /// </summary>
        protected int p_intParentOrgID;

		#endregion
		
		#region Private Properties

        /// <summary>
        /// Determines the User ID of the user that is currently being edited
        /// </summary>
        /// <remarks>
        ///	The User Details page is called from at least 2 contexts:
        ///		1. User Search datagrid - UserID passed in on query string
        ///		2. SaltUser Administration link - no USERID passed in
        /// </remarks>
        private void SetUserID()
        {
            if (Request.QueryString["UserID"] == null)
            {
                // No UserID passed in via request query string - this user viewing their 
                // personal details.  Get the current user's ID and set the associated OrgID
                this.p_intUserIDToDisplay = UserContext.UserID;
                this.p_intParentOrgID = UserContext.UserData.OrgID;
            }
            else
            {
                // The UserID parameter has been supplied via the query string
                this.p_intUserIDToDisplay = int.Parse(Request["UserID"]);
                this.p_intParentOrgID = UserContext.UserData.OrgID;

                // A UserID value of 0 indicates a new SALT user, -1 indicates a new SALT Admin
                if (this.p_intUserIDToDisplay == 0)
                {
                    // Check whether a parent UnitID has been supplied
                    if (Request.QueryString["UnitID"] != null)
                    {
                        // A parent Unit ID has been supplied
                        this.p_intParentUnitID = int.Parse(Request.QueryString["UnitID"]);

                        // Add a user to a specific unit, need to check whether the admin user has permission to add user to this unit
                        if (this.p_intParentUnitID > 0)
                        {
                            WebSecurity.CheckUnitAdministrator(this.p_intParentUnitID);
                        }
                    }
                }
                else if (this.p_intUserIDToDisplay == -1)
                {
                    // Only a SALT Administrator is able to create a SALT Administrator
                    WebSecurity.CheckSALTAdministrator();
                }
                else
                {
                    // Edit existing user details, check whether the admin user has 
                    // permission to see the user details
                    WebSecurity.CheckUserAdministrator(this.p_intUserIDToDisplay);
                }
            }
        }

        /// <summary>
        /// This function retrives the next integrity timestamp for the user page each time it is reloaded
        /// regardless of whether the page is a postback or not. This is to ensure that if a user repeatedly
        /// hits save they will always have the most up to date value
        /// </summary>
        private void SetPageIntegrity ()
        {
            if (this.p_intUserIDToDisplay > 0 )
            {
                // Displaying details for an exiting user
                BusinessServices.User objUser = new BusinessServices.User();
    			
                // Load the user's details
                DataTable dtbUserDetails = objUser.GetUser(p_intUserIDToDisplay);
                ViewState[viewstate_dateupdated] = dtbUserDetails.Rows[0][cm_strTblUserDateUpdated].ToString();
            }
                
        }

        protected bool IsMadeInactive
        {
            get
            {
                if (ViewState["IsMadeInactive"] == null)
                    return false;
                else
                    return (bool)ViewState["IsMadeInactive"];
            }
            set
            {
                ViewState["IsMadeInactive"] = value;
            }
        }

        #endregion

		#region Private Event Handlers


		/// <summary>
		/// Event Handler for the Page Load event.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			lblPageTitle.Text  = ResourceManager.GetString("lblPageTitle");
			lblUserStatus.Text = ResourceManager.GetString("lblUserStatus");
			
			// store the userid on the p_intUserIDToDisplay
			SetUserID();
            SetPageIntegrity();
			if (!Page.IsPostBack)
			{
				lnkReturnTo.Text = ResourceManager.GetString("lnkReturnTo");

                // Store the HTTP referer
                if ((Request.ServerVariables["HTTP_REFERER"] == null) || (Request.ServerVariables["HTTP_REFERER"].ToString().Contains("PeriodicReportList.aspx")))
                    ViewState["HTTPReferer"] = Session["UserDetailsReferrer"];
                else
                    ViewState["HTTPReferer"] = Request.ServerVariables["HTTP_REFERER"];

                SetUIControlsVisibility();
				PopulateUIControls();
				if (Request.QueryString["message"] == "AddUser")
				{
					this.lblMessage.Text = ResourceManager.GetString("lblMessage");//"The User's Details have been added successfully";
					this.lblMessage.CssClass = "SuccessMessage";
				}
                if (Request.QueryString["message"] == "UpdatedUser")
                {
                    if (this.lblMessage.Text.Length == 0)
                    {
                        this.lblMessage.Text = ResourceManager.GetString("lblMessage");//"The User's Details have been updated successfully";
                        this.lblMessage.CssClass = "SuccessMessage";

                        // Refresh the UI
                        SetUIControlsVisibility();
                        PopulateUIControls();
                    }
                }
			}


			lnkModuleAccess.NavigateUrl = "UserModuleAccess.aspx?UserID=" + this.p_intUserIDToDisplay.ToString();
            lnkReceivedEmails.NavigateUrl = "UserReceivedEmails.aspx?UserID=" + this.p_intUserIDToDisplay.ToString();
		}

		/// <summary>
		/// Return link returns the user to where they navigated to the page
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
        protected void lnkReturnTo_Click(object sender, System.EventArgs e)
        {
            // Determine where to return to user to
            if (UserContext.UserData.UserType == UserType.User)
            {
                // Regular user viewing their personal details
                Response.Redirect("/Default.aspx");
            }
            else if (Request.QueryString["UserID"] == null)
            {
                // Admin user viewing their personal details
                Response.Redirect("/Administration/AdministrationHome.aspx");
            }
            else if (p_intParentUnitID != 0)
            {
                // Either viewing user or adding new user from unit details page
                Response.Redirect("/Administration/Unit/UnitDetails.aspx?UnitID=" + p_intParentUnitID.ToString());
            }
            else if (p_intUserIDToDisplay == 0)
            {
                // Admin user adding a new user from the homepage
                Response.Redirect("/Administration/AdministrationHome.aspx");
            }
            else if (p_intUserIDToDisplay == -1)
            {
                // Admin user adding a new user from the homepage
                Response.Redirect("ApplicationAdministrators.aspx");
            }
            else 
            {
                // Admin user modified another users module access and attempting to 
                // return to the user search page
                if (ViewState["HTTPReferer"].ToString().IndexOf("UserModuleAccess") > -1)
                {
                    Response.Redirect("/Administration/Users/UserSearch.aspx");
                }
                else
                {
                    // Admin user viewing another user's details via the user search page or 
                    // unit detail page or creating a new user

                    //if (!Request.UrlReferrer.ToString().Contains("PeriodicReportList.aspx"))
                        Response.Redirect(ViewState["HTTPReferer"].ToString());
                    //else if (Session["UserDetailsReferrer"] != null)
                    //    Response.Redirect(Session["UserDetailsReferrer"].ToString());
                }
            }
		}

		/// <summary>
		/// Validation for ensuring an old password is entered when a password is entered
		/// </summary>
		/// <param name="source"></param>
		/// <param name="args"></param>
		protected void cvlOldPassword_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			// Verify the old and new password fields
			if(this.txtOldPassword.Text.Length == 0 && this.txtPassword.Text.Length > 0)
			{
				args.IsValid = false;
			} 
			else 
			{
				args.IsValid = true;
			}
		}

		/// <summary>
		/// Validation for ensuring a confirm password is entered when a password is entered
		/// </summary>
		/// <param name="source"></param>
		/// <param name="args"></param>
		protected void cvlConfirmPassword_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			if (txtConfirmPassword.Text.Length == 0 && txtPassword.Text.Length > 0)
			{
				args.IsValid = false;
			} 
			else 
			{
				args.IsValid = true;
			}
		}

        /// <summary>
        /// Validation for ensuring unit is selected
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void cvlUnit_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            // Must have a unit if not a SALT Admin
            if ( (!this.lblApplicationAdmin.Visible) && (Request.QueryString["UserID"] != null) )
            {
                args.IsValid = !(this.trvUnitsSelector.GetSelectedValue()=="");
            }
            else
            {
                args.IsValid = true;
            }
        }

        protected void chkUserStatus_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox cb = (CheckBox) sender;
            if (!cb.Checked)
                IsMadeInactive = true;
            else
                IsMadeInactive = false;
        }

		/// <summary>
		/// Updates the user details into the database
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnSave_Click(object sender, System.EventArgs e)
		{
			// User object used to return the user details of the desired user
			BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtbUserDetails = objUser.GetUser(p_intUserIDToDisplay);
			
			if (Page.IsValid)
			{
				UserType objUserType;
				int intUnitID = 0;
				bool blnActive;

				if (this.chkUnlock.Checked)
				{
					// Reset the LoginFailCount
					objUser.UpdateLoginAttempts(int.Parse(dtbUserDetails.Rows[0]["UserID"].ToString()), 0);
				}

				// Get/Setup the UserTypeID to be inserted in the DB
				if (UserContext.UserData.UserType == UserType.SaltAdmin)
				{
					// SALT Administrator so verify the checkbox
					if (this.lblApplicationAdmin.Visible)
					{
						// Salt admin is checked so set user to be salt admin
						objUserType = UserType.SaltAdmin;
					} 
					else 
					{
						// If a new user, then set the user type to be a normal User
                        if (p_intUserIDToDisplay == 0)
                        {
                            objUserType = UserType.User;
                        }
                        else if (p_intUserIDToDisplay == -1)
                        {
                            objUserType = UserType.SaltAdmin;
                        }
                        else
                        {
                            // Get the current users existing UserTypeID
                            objUserType = (UserType) Int32.Parse(dtbUserDetails.Rows[0][cm_strTblUserTypeID].ToString());

                            // Only need to change the user status if they were previously a 
                            // SALT Administrator
                            if (objUserType == UserType.SaltAdmin)
                            {
                                objUserType = UserType.User;
                            }
                        }
					}
				} 
				else 
				{
					// If a new user, then set the user type to be a normal User
					if (p_intUserIDToDisplay == 0)
					{
						objUserType = UserType.User;
					}
                    else if (p_intUserIDToDisplay == -1)
                    {
                        objUserType = UserType.SaltAdmin;
                    }
                    else
					{
						// Logged on user is not a salt admin therefore will not be able to change 
						// usertype set usertype to be existing value
						objUserType = (UserType) Int32.Parse(dtbUserDetails.Rows[0][cm_strTblUserTypeID].ToString());
					}
				}

                // Get Unit ID and status values
                if (Request.QueryString["UserID"] == null)
                {
                    // Viewing Personal Details - Unit ID and status cannot have changed so 
                    // get the current value in the database
                    if (objUserType != UserType.SaltAdmin)
                    {
                        intUnitID = int.Parse(dtbUserDetails.Rows[0][cm_strTblUserUnitID].ToString());
                    }
                    blnActive = Boolean.Parse(dtbUserDetails.Rows[0][cm_strTblUserActive].ToString());
                }
                else
                {
                    // Get the unit id from the tree control as administrator is viewing other
                    // user's details which may have been changed
                    if (objUserType != UserType.SaltAdmin)
                    {
                        intUnitID = Int32.Parse(trvUnitsSelector.GetSelectedValue());
                    }
                    blnActive = chkUserStatus.Checked;
                }


				//=========================
				// Update the user object
				//=========================

				// If a new user, redirect to the User Detail page passing the User ID
				// via the query string once the user has been created, otherwise refresh 
				// the UI
				if ( (p_intUserIDToDisplay == 0) || (p_intUserIDToDisplay == -1) ) 
				{
					// Redirect to the page to ensure the query string parameters are correctly set
					UpdateUser(objUser, intUnitID, blnActive, objUserType);

					// If no errors occurred, then redirect to the User Details page for the newly
					if (p_intUserIDToDisplay != 0)
					{
   						Response.Redirect("UserDetails.aspx?UserID=" + p_intUserIDToDisplay + "&message=AddUser");
					}
				} // new users wont have periodic reports
				else
				{
					// Update the user details
					UpdateUser(objUser, intUnitID, blnActive, objUserType);

					// Set the success message if no error message was set
					if (this.lblMessage.Text.Length == 0)
					{
						this.lblMessage.Text = ResourceManager.GetString("lblMessage");//"The User's Details have been updated successfully";
						this.lblMessage.CssClass = "SuccessMessage";
                        
						// Refresh the UI
						SetUIControlsVisibility();
						PopulateUIControls();
                        if (IsMadeInactive)
                        {
                            int periodicReportsCount = PeriodicReportCountUser(p_intUserIDToDisplay);
                            if (periodicReportsCount > 0)
                            {
                                Session["UserDetailsReferrer"] = ViewState["HTTPReferer"];
                                Response.Redirect("~/Reporting/PeriodicReportList.aspx?user=" + p_intUserIDToDisplay.ToString() + "&isoninactivate=true");
                            }
                        }
                    }
                }
			}
		}

		#endregion

		#region Private Methods

        private int PeriodicReportCountUser(int UserId)
        {
            int OrgID = UserContext.UserData.OrgID;

            BusinessServices.User user = new BusinessServices.User();
            DataTable dtUser = user.GetUser(UserId);
            String Username = dtUser.Rows[0]["UserName"].ToString();

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            PeriodicReportListDataContext prl = new PeriodicReportListDataContext(connectionString);

            ISingleResult<prcGetPeriodicReportListOnInactivateUserResult> result = prl.prcGetPeriodicReportListOnInactivateUser(OrgID, Username);

            var query = from pr in result.AsQueryable<prcGetPeriodicReportListOnInactivateUserResult>() select pr;

            return query.Count<prcGetPeriodicReportListOnInactivateUserResult>();
        }

		/// <summary>
		/// Places the user details from the various data tables into the UI Controls
		/// </summary>
		private void PopulateUIControls()
		{
			// User object to return user details
			BusinessServices.User objUser;

			// Unit object to get unit details
			BusinessServices.Unit objUnit;
			
			// Datatable for user details
			DataTable dtbUserDetails;

			// Datatable for unit details
			DataTable dtbUnitDetails;

			// Datatable for user classification details
			DataTable dtbUserClassification;

            if ( p_intUserIDToDisplay == 0)
            {
                // The current user is an administrator so setup the unit tree view control
                // for the current organisaiton
                LoadUnitTreeView();

                // Set the page title
                this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle.3");//"Add User";
                if (!IsPostBack)
                {

                    txtPassword.Attributes["value"] = MakePassword();
                    txtConfirmPassword.Attributes["value"] = txtPassword.Attributes["value"];


                    List<string> tzList = new List<string>();
                    DataTable dtTzTable = new DataTable();

                    using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetList"))
                    {
                        dtTzTable = sp.ExecuteTable();
                    }

                    tzList = (from tzRow in dtTzTable.AsEnumerable()
                              select tzRow.Field<string>("FLB_Name")).ToList();

                    listTimeZone.DataSource = dtTzTable;
                    listTimeZone.DataValueField = "TimeZoneID";
                    listTimeZone.DataTextField = "FLB_Name";
                    listTimeZone.DataBind();
                     string orgid = Convert.ToString(p_intParentOrgID);
                     using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetTimeZoneFLBName", StoredProcedure.CreateInputParam("@TimeZoneID", SqlDbType.Int, Convert.ToInt32(getOrgTimezoneIdByOrgId(orgid)))))
                     {
                         string stTimeZone = Convert.ToString(sp.ExecuteScalar());
                         int selectedIndex = tzList.FindIndex(delegate(string s) { return s.Contains(stTimeZone); });
                         listTimeZone.SelectedValue = listTimeZone.Items[selectedIndex].Value;
                    }



                }
            }
            else if (p_intUserIDToDisplay == -1)
            {
                // Set the page title
                this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle.2");//"Add Application Administrator";
                if (!IsPostBack)
                {
                    List<string> tzList = new List<string>();
                    DataTable dtTzTable = new DataTable();

                    using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetList"))
                    {
                        dtTzTable = sp.ExecuteTable();
                    }

                    tzList = (from tzRow in dtTzTable.AsEnumerable()
                              select tzRow.Field<string>("FLB_Name")).ToList();

                    listTimeZone.DataSource = dtTzTable;
                    listTimeZone.DataValueField = "TimeZoneID";
                    listTimeZone.DataTextField = "FLB_Name";

                    listTimeZone.DataBind();
                    string orgid = Convert.ToString(p_intParentOrgID);
                    using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetTimeZoneFLBName", StoredProcedure.CreateInputParam("@TimeZoneID", SqlDbType.Int, Convert.ToInt32(getOrgTimezoneIdByOrgId(orgid)))))
                    {
                        string stTimeZone = Convert.ToString(sp.ExecuteScalar());
                        int selectedIndex = tzList.FindIndex(delegate(string s) { return s.Contains(stTimeZone); });
                        listTimeZone.SelectedValue = listTimeZone.Items[selectedIndex].Value;
                    }
                }
            }
            else
            {
                // Displaying details for an exiting user
                objUser = new BusinessServices.User();
    			
                // Load the user's details
                dtbUserDetails = objUser.GetUser(p_intUserIDToDisplay);

                // Store the dateupdated in the viewstate - this will be used for integrity 
                // checking if the user's details are updated
                ViewState[viewstate_dateupdated] = dtbUserDetails.Rows[0][cm_strTblUserDateUpdated].ToString();

                if (!IsPostBack)
                {
                    List<string> tzList = new List<string>();
                    DataTable dtTzTable = new DataTable();

                    using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetList"))
                    {
                        dtTzTable = sp.ExecuteTable();
                    }

                    tzList = (from tzRow in dtTzTable.AsEnumerable()
                              select tzRow.Field<string>("FLB_Name")).ToList();

                    listTimeZone.DataSource = dtTzTable;
                    listTimeZone.DataValueField = "TimeZoneID";
                    listTimeZone.DataTextField = "FLB_Name";

                    listTimeZone.DataBind();
                    string stTimeZone;
                    if ((dtbUserDetails.Rows[0]["TimeZoneID"] == null) ||  (dtbUserDetails.Rows[0]["TimeZoneID"].ToString() == ""))
                    {
                        string orgid = dtbUserDetails.Rows[0]["OrganisationID"].ToString();
                        if (string.IsNullOrEmpty(orgid))
                        {
                            orgid = Convert.ToString(p_intParentOrgID);
                        }

                        using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetTimeZoneFLBName", StoredProcedure.CreateInputParam("@TimeZoneID", SqlDbType.Int, Convert.ToInt32(getOrgTimezoneIdByOrgId(orgid)))))
                        {
                            stTimeZone = Convert.ToString(sp.ExecuteScalar());
                        }
                    }
                    else
                    {
                        using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetTimeZoneFLBName", StoredProcedure.CreateInputParam("@TimeZoneID", SqlDbType.Int, Convert.ToInt32(dtbUserDetails.Rows[0]["TimeZoneID"].ToString()))))
                        {
                            stTimeZone = Convert.ToString(sp.ExecuteScalar());
                        }
                    }

                    int selectedIndex = tzList.FindIndex(delegate(string s) { return s.Contains(stTimeZone); });
                    listTimeZone.SelectedValue = listTimeZone.Items[selectedIndex].Value;

                }
                // Set Unit and User type controls based whether current user is viewing their 
                // Personal Details
                if (Request.QueryString["UserID"] == null)
                {
                    // If the current user is not a Salt Admin, set the unit details label
                    if (UserContext.UserData.UserType != UserType.SaltAdmin)
                    {
                        // Set the label containing the full name of user's unit (tree view not used)
                        objUnit = new BusinessServices.Unit();

                        // If the user has been assi
                        if (dtbUserDetails.Rows[0][cm_strTblUserUnitID] != DBNull.Value)
                        {
                            int intUnitID = (int) dtbUserDetails.Rows[0][cm_strTblUserUnitID];
                            dtbUnitDetails = objUnit.GetUnit(intUnitID);
                            if (dtbUnitDetails.Rows.Count > 0)
                            {
                                this.lblUnits.Text = dtbUnitDetails.Rows[0]["Organisation"].ToString() + " > " + dtbUnitDetails.Rows[0]["Pathway"].ToString();
                            }
                        }
                    }
                    
                    // Set the user's status (Active / Inactive)
                    this.lblUserStatus.Text = (Boolean.Parse(dtbUserDetails.Rows[0][cm_strTblUserActive].ToString())) ? ResourceManager.GetString("cmnActive" ) : ResourceManager.GetString("cmnInactive");

                    // Set the page title
                    this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle.4");//"Personal Details";
 

                } 
                else 
                {
                    // The current user is an administrator so setup the unit tree view control
                    LoadUnitTreeView();
                   
                    // Set the user's status (Active / Inactive)
                    this.chkUserStatus.Checked = Boolean.Parse(dtbUserDetails.Rows[0][cm_strTblUserActive].ToString());
                }

                // Set user detail text boxes
                this.txtFirstName.Text = dtbUserDetails.Rows[0][cm_strTblUserFirstName].ToString();
                this.txtLastName.Text = dtbUserDetails.Rows[0][cm_strTblUserLastName].ToString();
                this.txtUserName.Text = dtbUserDetails.Rows[0][cm_strTblUserUserName].ToString();
                this.txtPassword.Text = dtbUserDetails.Rows[0][cm_strTblUserPassword].ToString();
                this.txtConfirmPassword.Text = dtbUserDetails.Rows[0][cm_strTblUserPassword].ToString();
                this.txtEmail.Text = dtbUserDetails.Rows[0][cm_strTblUserEmail].ToString();
                this.txtExternalID.Text = dtbUserDetails.Rows[0][cm_strTblUserExternalID].ToString();
                this.txtEmail2.Text = dtbUserDetails.Rows[0][cm_strTblUserManEmail].ToString();
                this.chkNotifyManager.Checked =(dtbUserDetails.Rows[0][cm_strTblUserNotifyMgr].ToString()=="True");
		        this.chkEmailUnitAdmin.Checked=(dtbUserDetails.Rows[0][cm_strTblUserNotifyUnitAdmin].ToString()=="True");
                this.chkEmailOrgAdmin.Checked = (dtbUserDetails.Rows[0][cm_strTblUserNotifyOrgAdmin].ToString() == "True");
                this.chkEbookNotification.Checked = (dtbUserDetails.Rows[0][cm_strTblUserEbookNotification].ToString() == "True");
                
                // Date user last logged in.
                if (dtbUserDetails.Rows[0][cm_strTblUserLastLogin] == DBNull.Value)
                {
                    this.lblLastLogin.Text = ResourceManager.GetString("lblLastLogin.Never");//"Never";
                    this.lblLastLogin.CssClass = "FeedbackMessage";
                }
                else
                {
                    DateTime dtLogin;
                    //not defined user timezone, then use org timezone
                    if (dtbUserDetails.Rows[0][cm_strTblUserTimeZoneID] == DBNull.Value)
                    {
                        dtLogin = DateTime.Parse(dtbUserDetails.Rows[0][cm_strTblUserLastLogin].ToString());
                    }
                    else
                    {
                        // in Personal Details screen, display user timezone time
                        if (Request.QueryString["UserID"] == null)
                        {
                            // Load the user's details
                            DataTable dtbUserDetailsWithOwnTime = objUser.GetUserWithOwnTime(p_intUserIDToDisplay);
                            dtLogin = DateTime.Parse(dtbUserDetailsWithOwnTime.Rows[0][cm_strTblUserLastLogin].ToString());
                        }
                        // in user details screen, display org timezone time, don't display Email in Organisation Domain
                        else
                        {
                            dtLogin = DateTime.Parse(dtbUserDetails.Rows[0][cm_strTblUserLastLogin].ToString());                            
                        }

                    }
                    this.lblLastLogin.Text = dtLogin.ToLongTimeString() + " " + dtLogin.ToString("dd/MM/yyyy");
                    
                }
                // If a regular user is using this page then disable modifiction of the username.
                if (UserContext.UserData.UserType == UserType.User)
                {
                    this.txtUserName.Enabled=false;
                }

                // Get the current users classification to set the value
                dtbUserClassification = objUser.GetClassification(p_intUserIDToDisplay);
                if (dtbUserClassification.Rows.Count == 1)
                {
                    this.cboCustomClass.SelectedValue = dtbUserClassification.Rows[0][cm_strTblClassificationID].ToString();
                }
            }
		}

        /// <summary>
        /// Sets the visibility of the UI controls based on the current user's type and the
        /// type of the user being displayed
        /// </summary>
        private void SetUIControlsVisibility()
        {
            BusinessServices.User objUser;
            BusinessServices.Classification objClassification;
            DataTable dtbUserDetails;
            DataTable dtbClassificationType;
            DataTable dtbClassificationList;

			// set visibility of Unlock controls to false
			this.lblUnlock.Visible = false;
			this.chkUnlock.Visible = false;

            // Set visibility of selected UI controls based on currently logged on user
            if (UserContext.UserData.UserType == UserType.User)
            {
                // Currently logged on user is a normal User (viewing their own details)
                this.lblUnits.Visible = true;
                this.chkUserStatus.Visible = false;
                this.lblUserStatus.Visible = true;
                this.lblAdminPrivileges.Visible = false;
                this.lblNoAdminPrivileges.Visible = false;
                this.trvUnitPrivileges.Visible = false;
                this.lblOrganisationAdmin.Visible = false;
				this.trwUserModuleAccess.Visible = false;
                this.txtExternalID.Visible=false;
                this.lblExternalIDLabel.Visible=false;

                this.txtEmail2.Visible = false;
                this.lblEmail2.Visible = false;
                
                /*this.lblNotifyManager.Visible = false;
                this.chkNotifyManager.Visible = false;

                this.chkEmailOrgAdmin.Visible = false;
                this.lblEmailOrgAdmin.Visible = false;
                
                this.chkEmailUnitAdmin.Visible = false;
                this.lblEmailUnitAdmin.Visible = false;   */

                this.plhNotifications.Visible = false;
                this.butRamdonPwd.Visible = false;

                bool isDisablePasswordField = BusinessServices.Organisation.GetDisablePasswordField(UserContext.UserData.OrgID);

                // To disable/enable PasswordField
                if (isDisablePasswordField)
                {
                    this.lblOldPassword.Visible = false;
                    this.txtOldPassword.Visible = false;
                    this.txtOldPassword.Enabled = false;
                    this.cvlOldPassword.Enabled = false;

                    this.lblNewPassword.Visible = false;
                    this.txtPassword.Visible = false;
                    this.txtPassword.Enabled = false;

                    this.lblConfirmPassword.Visible = false;
                    this.txtConfirmPassword.Visible = false;
                    this.txtConfirmPassword.Enabled = false;
                    this.cvlConfirmPassword.Enabled = false;

                    this.lblPasswordInstruction.Visible = false;
                }

            }
            else
            {
                // Show / Hide controls based on whether current Administrator is viewing 
                // Personal Details or other user's details
                if (Request.QueryString["UserID"] == null)
                {
                    // Show the Unit pathway label as current user is viewing their 
                    // Personal Details
                    this.lblUnits.Visible = true;
                    this.chkUserStatus.Enabled = false;
                    this.chkUserStatus.ToolTip = ResourceManager.GetString("chkUserStatus.ToolTip");//"You cannot change your own User Active status";
                }
                else
                {
                    // Hide the old password fields as Admin user is viewing other user's details
                    this.lblOldPassword.Visible = false;
                    this.txtOldPassword.Visible = false;
                    this.cvlOldPassword.Enabled = false;
                }

                this.lblUserStatus.Visible = false;
                this.chkUserStatus.Visible = true;
            }


            // Set visibility of selected UI controls based on user being displayed
            // NOTE: some controls are set to invisible by default
            if (p_intUserIDToDisplay == 0)
            {
                // Hide the Module access link as not user id is available yet
                this.trwUserModuleAccess.Visible = false;

                // Hide the password instruction label as password must be set
                this.lblPasswordInstruction.Visible = false;

                // Hide the login date as a user that hasnt been created cant have logged in.
                this.lblLastLoginLabel.Visible = false;

            }
            else if (p_intUserIDToDisplay == -1)
            {
                // Hide the Module access link as not user id is available yet
                this.trwUserModuleAccess.Visible = false;

                // Hide the password instruction label as password must be set
                this.lblPasswordInstruction.Visible = false;

                // Hide the controls not applicable when viewing a SALT Administrator's details
                this.trwUserModuleAccess.Visible = false;
                this.lblCustomClassLabel.Visible = false;
                this.cboCustomClass.Visible = false;
                this.lblApplicationAdmin.Visible = true;
                this.plhUnitSelector.Visible = false;
				this.lblExternalIDLabel.Visible = false;
				this.txtExternalID.Visible = false;

            }
            else
            {
                objUser = new BusinessServices.User();
                dtbUserDetails = objUser.GetUser(p_intUserIDToDisplay);
                switch ((UserType) int.Parse(dtbUserDetails.Rows[0][cm_strTblUserTypeID].ToString()))
                {
                    case UserType.UnitAdmin:
                        // Show the tree control that displays the Units this Unit 
                        // Administrator administers
                        this.lblAdminPrivileges.Visible = true;
                        LoadAdminTreeView(p_intUserIDToDisplay);
                        //this.butRamdonPwd.Visible = false;
                        break;
                    case UserType.OrgAdmin:
                        this.lblOrganisationAdmin.Visible = true;
                        //this.butRamdonPwd.Visible = false;
                        break;
                    case UserType.SaltAdmin:
                        this.trwUserModuleAccess.Visible = false;
                        this.lblCustomClassLabel.Visible = false;
                        this.cboCustomClass.Visible = false;
                        this.lblApplicationAdmin.Visible = true;
                        this.plhUnitSelector.Visible = false;
						this.lblExternalIDLabel.Visible = false;
						this.txtExternalID.Visible = false;
                        //this.butRamdonPwd.Visible = false;
                        break;
                }


				UserType UserToDisplay = (UserType) int.Parse(dtbUserDetails.Rows[0][cm_strTblUserTypeID].ToString());
				// Currently Logged On User
				switch (UserContext.UserData.UserType)
				{
					// SaltAdmin can unlock anyone
					case UserType.SaltAdmin:
						DisplayUnlock(objUser, p_intUserIDToDisplay);
						break;
					// Org Admin can unlock Unit Admin or User
					case UserType.OrgAdmin:
						if ((UserToDisplay == UserType.UnitAdmin) || (UserToDisplay == UserType.User))
						{
							DisplayUnlock(objUser, p_intUserIDToDisplay);
						}
						break;
					// Unit Admin can unlock User only
					case UserType.UnitAdmin:
						if (UserToDisplay == UserType.User)
						{
							DisplayUnlock(objUser, p_intUserIDToDisplay);
						}
						// Or another Unit admin provided they are in a subunit
						if (UserToDisplay == UserType.UnitAdmin)
						{
							
							DataTable dtUnitID = objUser.UnitsUserAdministrates(UserContext.UserID);
							if (dtUnitID.Rows.Count > 0)
							{
								foreach(DataRow dr in dtUnitID.Rows)
								{
									int intUnitID = int.Parse(dr["UnitID"].ToString());
									bool bPropagate = bool.Parse(dr["Propagate"].ToString());
									// if the currently logged in user is able to propagate
									if(bPropagate)
									{
										// if the unit the unit admin is a sub-unit of the unit the currently logged
										// in user is
										int intDisplayUnitID = int.Parse(dtbUserDetails.Rows[0][cm_strTblUserUnitID].ToString());
										if (objUser.DisplayUnitIsSub(intUnitID, intDisplayUnitID))
										{
											// then display the unlock checkbox
											DisplayUnlock(objUser, p_intUserIDToDisplay);
										}
									}
								}
							}
						}
						break;
				}
				
                // Password and Confirm Password are not mandatory for an existing user
                this.rvlPassword.Enabled = false;
                this.rvlConfirmPassword.Enabled = false;
            }


            // hide the ebook checkbox if the organisation does not have ebook feature
            BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
            bool hasEbookAccess = objOrganisation.GetOrganisationEbookAccess(UserContext.UserData.OrgID);
            bool defaultEbookEmailNotification = BusinessServices.Organisation.GetDefaultEbookEmailNotification(UserContext.UserData.OrgID);
            if (!hasEbookAccess)
            {
                this.plhEbookNotification.Visible = false;
            }
            else
            {
                if (defaultEbookEmailNotification)
                {
                    this.plhEbookNotification.Visible = true;
                }
                else
                {
                    this.plhEbookNotification.Visible = false;
                }
            }


            // Only setup custom classifications if displayed user is not a SALT Admin
            if (this.cboCustomClass.Visible == true)
            {
                // Get Classification Type for the dsiplayed user's organisation
                objClassification = new BusinessServices.Classification();
                dtbClassificationType = objClassification.GetClassificationType(p_intParentOrgID);

                // Check if any classification types exist for the user's organisation
                if (dtbClassificationType.Rows.Count == 0)
                {
                    // Hide the custom row as no custom classifications found
                    this.lblCustomClassLabel.Visible = false;
                    this.cboCustomClass.Visible = false;
                }
                else
                {
                    // Custom classifications found
                    this.lblCustomClassLabel.Visible = true;
                    this.cboCustomClass.Visible = true;
                    this.lblCustomClassLabel.Text = dtbClassificationType.Rows[0][cm_strTblClassificationTypeName].ToString();

                    // Add a blank value
                    dtbClassificationList = objClassification.GetClassificationList((int) Int32.Parse(dtbClassificationType.Rows[0][cm_strTblClassificationTypeID].ToString()));
    				
                    // Add blank row to the datatable
                    DataRow drwBlank;

                    drwBlank = dtbClassificationList.NewRow();

                    drwBlank[cm_strTblClassificationID] = 0;
                    drwBlank[cm_strTblClassificationTypeID] = 0;
                    drwBlank[cm_strTblClassificationValue] = "";
                    drwBlank[cm_strTblClassificationActive] = 1;

                    dtbClassificationList.Rows.InsertAt(drwBlank, 0);
                    this.cboCustomClass.DataSource = dtbClassificationList;

                    // Add blank item
                    this.cboCustomClass.DataTextField = cm_strTblClassificationValue;
                    this.cboCustomClass.DataValueField = cm_strTblClassificationID;
                    this.cboCustomClass.DataBind();
                }
            }

            // Determine where to return to user to
            // Set the text of the "Cancel" link button
            if (UserContext.UserData.UserType == UserType.User)
            {
                // Regular user viewing their personal details
                //this.lnkReturnTo.Text = "Return to Homepage";
                this.lnkReturnTo.Visible = false;
            }
            else if (Request.QueryString["UserID"] == null)
            {
                // Admin user viewing their personal details
                //this.lnkReturnTo.Text = "Return to Administration Homepage";
                this.lnkReturnTo.Visible = false;
            }
            else if (p_intParentUnitID != 0)
            {
                // Either viewing user or adding new user from unit details page
                this.lnkReturnTo.Text = ResourceManager.GetString("cmnReturnUnitDetails");//"Return to Unit Details";
            }
            else if (p_intUserIDToDisplay == 0)
            {
                // Admin user adding a new user from the homepage
                this.lnkReturnTo.Text = ResourceManager.GetString("cmnReturn");//"Return to Administration Homepage";
            }
            else if (p_intUserIDToDisplay == -1)
            {
                // Admin user adding a new user from the homepage
                this.lnkReturnTo.Text = ResourceManager.GetString("lnkReturnTo.3");//"Return to Application Administrators";
            }
            else 
            {
                if (ViewState["HTTPReferer"].ToString().IndexOf("UnitDetails.aspx", 0) > 0)
                {
                    // Admin user viewing another user's details via the unit detail page
                    this.lnkReturnTo.Text = ResourceManager.GetString("cmnReturnUnitDetails");//"Return to Unit Details";
                }
                else if (ViewState["HTTPReferer"].ToString().IndexOf("UserDetails.aspx?UserID=0", 0) > 0)
                {
                    // Just created a new user and now displaying their details
                    this.lnkReturnTo.Text = ResourceManager.GetString("lnkReturnTo.5");//"Return to Add User page";
                }
                else if (ViewState["HTTPReferer"].ToString().IndexOf("UserDetails.aspx?UserID=-1", 0) > 0)
                {
                    // Just created a new SALT Administrator and now displaying their details
                    this.lnkReturnTo.Text = ResourceManager.GetString("lnkReturnTo.6");//"Return to Add Application Administrator page";
                }
                else if (ViewState["HTTPReferer"].ToString().IndexOf("ApplicationAdministrators.aspx", 0) > 0)
                {
                    // Just created a new user and now displaying their details
                    this.lnkReturnTo.Text = ResourceManager.GetString("lnkReturnTo.7");//"Return to Application Administrators page";
                }
                else
                {
                    // Admin user viewing another user's details via the user search page
                    this.lnkReturnTo.Text = ResourceManager.GetString("lnkReturnTo.8");//"Return to User Search page";
                }
            }
        }

		private void DisplayUnlock(BusinessServices.User objUser, int p_intUserIDToDisplay)
		{
			if (objUser.UserIsPasswordLocked(p_intUserIDToDisplay))
			{
				this.lblUnlock.Visible = true;
				this.chkUnlock.Visible = true;
			}
			else
			{
				this.lblUnlock.Visible = false;
				this.chkUnlock.Visible = false;
			}

		}
		/// <summary>
		/// Loads the unit tree view control
		/// </summary>
		private void LoadUnitTreeView()
		{
            DataSet dstUnits;

            if (p_intUserIDToDisplay == 0)
            {
                BusinessServices.Unit objUnit = new BusinessServices.Unit();
				if (Request.QueryString["UnitID"]==null)
				{
					dstUnits = objUnit.GetUnitsTreeByUserID(p_intParentOrgID, UserContext.UserID, 'A');
				}
				else
				{
					int intUnitID = int.Parse (Request.QueryString["UnitID"].ToString());
					dstUnits = objUnit.GetUnitsTreeByUserID(p_intParentOrgID, UserContext.UserID, 'A', intUnitID);
				}
            }
            else
            {
                BusinessServices.User objUser = new BusinessServices.User();
                dstUnits = objUser.GetUnitsTree(p_intUserIDToDisplay, UserContext.UserID);
            }

            if (dstUnits.Tables[0].Rows.Count > 0)
            {
            
                // Reset the tree view control on each load
                clearUnitTreeView();

                string strUnits = UnitTreeConvert.ConvertXml(dstUnits);
                if (strUnits=="")
                {
                    this.trvUnitsSelector.Visible= false;
                    this.lblUnits.Visible = true;
                }
                else
                {
                    this.trvUnitsSelector.Visible= true;
                    this.lblUnits.Visible = false;
                    this.trvUnitsSelector.LoadXml(strUnits);
                }
            }
            else
            {
                this.lblMessageUnit.Text = ResourceManager.GetString("lblMessageUnit"); //"No units exist.";
                this.lblMessageUnit.CssClass = "FeedbackMessage";
                this.plhMainForm.Visible=false;
            }
		}


		/// <summary>
		/// clearUnitTreeView clears the selected option from the tree without
		/// collapsing or reloading the tree control
		/// </summary>
		private void clearUnitTreeView()
		{
			
			if (trvUnitsSelector.GetSelectedValue().Length > 0)
			{
				trvUnitsSelector.ClearSelection();
			}
		}

		/// <summary>
		/// Loads the tree view for an Administrator base on the user ID
		/// </summary>
		/// <param name="intUserID">ID of the user being edited</param>
		private void LoadAdminTreeView(int intUserID)
		{
			BusinessServices.User objUser = new BusinessServices.User();
			
			DataSet dstUnits = objUser.GetAdminUnitsTree(intUserID);
			
			// reset the tree view control on each load
			clearAdminTreeView();

			string strUnits = UnitTreeConvert.ConvertXml(dstUnits);
			if (strUnits=="")
			{
				this.trvUnitPrivileges.Visible= false;
				this.lblNoAdminPrivileges.Visible = true;
			}
			else
			{
				this.trvUnitPrivileges.Visible= true;
				this.lblNoAdminPrivileges.Visible = false;
				this.trvUnitPrivileges.LoadXml(strUnits);
			}
		}

		/// <summary>
		/// clearAdminTreeView clears the selected option from the tree without
		/// collapsing or reloading the tree control
		/// </summary>
		private void clearAdminTreeView()
		{
			if(trvUnitPrivileges.GetSelectedValues().Length > 0)
			{
				trvUnitPrivileges.ClearSelection();
			}
		}

		/// <summary>
		/// Updates the user object
		/// </summary>
		/// <param name="objUser">current user object being updated</param>
		/// <param name="UnitID">The Unit ID</param>
		/// <param name="Active">Boolean for Active or Inactive</param>
		/// <param name="UserType">The type of the user</param>
		/// <remarks>
		/// Notes:
		/// Executes the update depending on the password changes
		/// if txtPassword has no value then no password change
		/// elseif Oldpassword is invisible then administration password change
		///		or new user
		/// else salt user password change
		/// </remarks>
		private void UpdateUser(BusinessServices.User objUser, int UnitID, bool Active, UserType UserType)
		{
			int intUserType;

			intUserType = (int) UserType;

			try
			{
                String NewTimeZone = null;
                if (listTimeZone.SelectedItem != null) NewTimeZone = listTimeZone.SelectedItem.Text;
                string NewTimeZoneId = listTimeZone.SelectedValue;
                string orgTimeZoneId = getOrgTimezoneIdByOrgId(Convert.ToString(UserContext.UserData.OrgID));
                if (NewTimeZoneId.CompareTo(orgTimeZoneId) == 0) 
                {
                    NewTimeZone = null;
                }
    
				if (txtPassword.Text.Length == 0) 
				{
					// No password update
					objUser.UpdateUser(p_intUserIDToDisplay, 
						UnitID,
						txtFirstName.Text,
						txtLastName.Text,
						txtUserName.Text,
						txtEmail.Text,
						Active,
						intUserType,
						UserContext.UserID,
                        ViewState[viewstate_dateupdated].ToString(),
                        txtExternalID.Text,
                        NewTimeZone, txtEmail2.Text, chkEmailUnitAdmin.Checked, chkEmailOrgAdmin.Checked, chkNotifyManager.Checked, chkEbookNotification.Checked);
				} 
				else if (!txtOldPassword.Visible)
				{
					// Administration password update or new User
					string strPassword = txtPassword.Text.Trim().ToLower();
					if (strPassword=="password")
					{
						throw new ApplicationException(ResourceManager.GetString("Error.Password"));//"That password is not secure"
					}


					// If the UserID is 0 then it is a new User
					if ( (p_intUserIDToDisplay == 0) || (p_intUserIDToDisplay == -1) )
					{
						// Create a new User
						p_intUserIDToDisplay = objUser.Create(p_intParentOrgID,
							UnitID,
							txtFirstName.Text,
							txtLastName.Text,
							txtUserName.Text,
							txtEmail.Text,
							Active,
							intUserType,
							UserContext.UserID,
							txtPassword.Text,
                            txtExternalID.Text,
                            NewTimeZone, txtEmail2.Text,
                            chkEmailUnitAdmin.Checked,
                            chkEmailOrgAdmin.Checked,
                            chkNotifyManager.Checked,
                            chkEbookNotification.Checked);
                    }
					else
					{
						// Update an existing User
						objUser.Update(p_intUserIDToDisplay, 
							UnitID,
							txtFirstName.Text,
							txtLastName.Text,
							txtUserName.Text,
							txtEmail.Text,
							Active,
							intUserType,
							UserContext.UserID,
							ViewState[viewstate_dateupdated].ToString(),
							txtPassword.Text, 
                            txtExternalID.Text,
                            NewTimeZone, txtEmail2.Text,
                            chkEmailUnitAdmin.Checked,
                            chkEmailOrgAdmin.Checked,
                            chkNotifyManager.Checked,
                            chkEbookNotification.Checked);
					}
				} 
				else 
				{
					// salt user update
					objUser.Update(p_intUserIDToDisplay, 
						UnitID,
						txtFirstName.Text,
						txtLastName.Text,
						txtUserName.Text,
						txtEmail.Text,
						Active,
						intUserType,
						UserContext.UserID,
						ViewState[viewstate_dateupdated].ToString(),
						txtPassword.Text,
                        txtOldPassword.Text, txtExternalID.Text, NewTimeZone, txtEmail2.Text,
                        chkEmailUnitAdmin.Checked,
                            chkEmailOrgAdmin.Checked,
                            chkNotifyManager.Checked, 
                            chkEbookNotification.Checked);
				}

				// Update classification details
				if (cboCustomClass.SelectedValue == "0")
				{
					// passing in an empty string causes the stored proc to
					// delete all existing userClassifications.
					objUser.ClassificationUpdate(p_intUserIDToDisplay, "");
				} 
				else 
				{
					objUser.ClassificationUpdate(p_intUserIDToDisplay, cboCustomClass.SelectedValue);
				}
			}
			catch(RecordNotFoundException ex)
			{
				this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
			}
			catch(IntegrityViolationException ex)
			{
				this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
			}
			catch(UniqueViolationException ex)
			{
				this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
			}
			catch(ApplicationException ex)
			{
				this.lblMessage.Text = ex.Message;
				this.lblMessage.CssClass = "WarningMessage";
			}
			catch(Exception ex)
			{
				throw ex;
			}


		}

		#endregion

		#region Web Form Designer generated code

        /// <summary>
        /// his call is required by the ASP.NET Web Form Designer.
        /// </summary>
        /// <param name="e"></param>
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
			//this.rvlPassword.ServerValidate +=new ServerValidateEventHandler(rvlPassword_ServerValidate);
			//this.rvlConfirmPassword.ServerValidate +=new ServerValidateEventHandler(rvlConfirmPassword_ServerValidate);
		}
		#endregion
		protected override void Render(HtmlTextWriter writer)
		{
			//-- Hack. Could not work out how to use the render event in the tree view, therefore this code is run on every page that has a tree view. Hope to refactor after discovering the solution.
			System.Text.StringBuilder sb = new System.Text.StringBuilder();
			System.IO.StringWriter sw = new System.IO.StringWriter(sb);
			HtmlTextWriter newWriter = new HtmlTextWriter(sw);
                  
			base.Render(newWriter);
                  
			sb.Replace("Clear All", ResourceManager.GetString("treeClearAll"));
			sb.Replace("Collapse All", ResourceManager.GetString("treeCollapseAll"));
			sb.Replace("Expand All", ResourceManager.GetString("treeExpandAll"));
			sb.Replace("class=\"TreeView_Node\">Help</a>", "class=\"TreeView_Node\">" + ResourceManager.GetString("treeHelp") + "</a>");
			sb.Replace("Select All", ResourceManager.GetString("treeSelectAll"));

			Response.Write(sb.ToString());
			// -End Hack
			
		}
		private void rvlPassword_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			if (txtOldPassword.Text.Length != 0 && txtPassword.Text.Length == 0)
			{
				args.IsValid = false;
			} 
			else 
			{
				args.IsValid = true;
			}
		}

		private void rvlConfirmPassword_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			if (txtOldPassword.Text.Length != 0 && txtConfirmPassword.Text.Length == 0)
			{
				args.IsValid = false;
			} 
			else 
			{
				args.IsValid = true;
			}
		}

        protected void butRamdonPwd_Click(object sender, EventArgs e)
        {
            //txtPassword.Text = MakePassword();
            txtPassword.Attributes["value"] = MakePassword();
            txtConfirmPassword.Attributes["value"] = txtPassword.Attributes["value"];
            if (p_intUserIDToDisplay == 0)
            {
                this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle.3");
            }
        }


        public string MakePassword() 
        { 
            string pwdchars ="abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ$@!%&*(){,}";
            string nonalphas = "0123456789$@!%&*(){,}";
            string tmpstr=""; 

            Random rnd=new Random(); 
            int iRandNum;
            
            char c = ' ';
            for(int i=0; i < 8; i++)  { 

                if (tmpstr.Length >= 3)
                {
                    char last1 = tmpstr[tmpstr.Length-1];
                    char last2 = tmpstr[tmpstr.Length-2];
                    char last3 = tmpstr[tmpstr.Length-3];

                    if (isAlpha(last1) && isAlpha(last2) && isAlpha(last3))
                    {
                        iRandNum = rnd.Next(nonalphas.Length);
                        c = nonalphas[iRandNum];
                    }
                    else
                    {
                        iRandNum = rnd.Next(pwdchars.Length);
                        c = pwdchars[iRandNum];
                    }
                }
                else
                {
                    iRandNum = rnd.Next(pwdchars.Length);
                    c = pwdchars[iRandNum];
                }

                tmpstr += c;
            } 
            
            return tmpstr; 
        }

        private Boolean isAlpha(char c)
        {
            if ((c >= 65 && c <= 90) || (c >= 97 && c <= 122))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private string getOrgTimezoneIdByOrgId(string orgId)
        {
            string tzId = "";
            SqlParameter[] sqlParams = new SqlParameter[] { new SqlParameter("@orgId", orgId) };
            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";
            string sqlSelect = "select TimeZoneID from tblOrganisation where OrganisationID=@orgId";

            DataTable dtbOrg = Microsoft.ApplicationBlocks.Data.SqlHelper.ExecuteDataset(connectionString, System.Data.CommandType.Text, sqlSelect, sqlParams).Tables[0];
            if (dtbOrg.Rows.Count > 0)
            {
                tzId = dtbOrg.Rows[0]["TimeZoneID"].ToString().Trim();
            }
            return tzId;
        }
	}
}
