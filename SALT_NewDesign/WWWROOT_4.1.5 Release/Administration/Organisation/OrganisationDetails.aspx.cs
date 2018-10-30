using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Configuration;
using System.Text.RegularExpressions;
using System.Linq;

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.Data;
using Localization;
using System.Collections.ObjectModel;
using tinyMCE;


namespace Bdw.Application.Salt.Web.Administration.Organisation
{
	/// <summary>
	/// This class controls the page and business logic for the ModifyLinks.aspx page.
	/// </summary>
	/// <remarks>
	/// Assumptions: None.
	/// Notes: None.
	/// Author: Peter Vranich
	/// Date: 18/02/0/2004
	/// Changes:
	/// </remarks>
	public partial class OrganisationDetails : System.Web.UI.Page
	{
		#region Protected Controls
		/// <summary>
		/// The label to hold any messages that need to be displayed to the user.
		/// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;
		
		/// <summary>
		/// TextBox for the organisation name.
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtOrganisationName;
		
		/// <summary>
		/// TextBox for the organisation notes.
		/// </summary>
		protected TextEditor txtOrganisationNotes;
		
		/// <summary>
		/// Drop down list for the default organisation lesson frequency.
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList cboDefaultLessonFrequency;
		
		/// <summary>
		/// Drop down list for the default organisation quiz frequency.
		/// </summary>
		protected System.Web.UI.WebControls.DropDownList cboDefaultQuizFrequency;
		
		/// <summary>
		/// Text box for the default organisation quiz pass mark.
		/// </summary>
		protected System.Web.UI.WebControls.TextBox txtDefaultQuizPassMark;
		
		/// <summary>
		/// Html input field control for the organisations logo.
		/// </summary>
		protected System.Web.UI.HtmlControls.HtmlInputFile fileLogo;
		
		/// <summary>
		/// Label to display the organisations logo.
		/// </summary>
		protected System.Web.UI.WebControls.Label lblLogo;

		/// <summary>
		/// Placeholder surrounding organisation details
		/// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhOrganisationDetails;


		/// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;




		#endregion

		#region Constants
		/// <summary>
		/// Constant to hold the root relative path to the organisation images folder.
		/// </summary>
		private string m_strOrganisationImagesPath = ConfigurationSettings.AppSettings["OrganisationImagesPath"];
		#endregion
		
		#region Private Properties
		/// <summary>
		/// Gets the page action from the query string.
		/// </summary>
		private string PageAction
		{
			get
			{
				if (Request.QueryString["action"] != null && Request.QueryString["action"].ToLower() == "add")
				{
					return "add";
				}
				else
				{
					return "edit";
				}
			}
		}
		
        private bool AddSuccess
		{
			get
			{
				if (Request.QueryString["adsx"] != null && Request.QueryString["adsx"].ToLower() == "true")
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		
		/// <summary>
		/// Gets or Sets the ClassificationTypeID.
		/// </summary>
		/// <remarks> The ClassificationTypeID is stored in the ViewState.</remarks>
		private int ClassificationTypeID
		{
			get
			{
				if(ViewState["ClassificationTypeID"] != null)
				{
					return Int32.Parse(ViewState["ClassificationTypeID"].ToString());
				}
				else
				{
					return 0;
				}
			}
			set
			{
				ViewState["ClassificationTypeID"] = value;
			}
		}
		
		/// <summary>
		/// Gets or Sets the OriginalDateUpdated for this Organisation.
		/// </summary>
		/// <remarks> The OriginalDateUpdated is stored in the ViewState.</remarks>
		private string OriginalDateUpdated
		{
			get
			{
				return (string)ViewState["OriginalDateUpdated"];
			}
			set
			{
				ViewState["OriginalDateUpdated"] = value;
			}
		}
		#endregion
		
		#region Private Event Handlers
		/// <summary>
		/// Event Handler method for the Page Load event.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
            //document.frmOrgDetails.txtOrganisationName.focus();
                

			this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle");
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			if(!Page.IsPostBack)
			{
				//By default hide the CPD Report Name and Disk Allocation controls
				//These will only be shown if Organisation has access to CPD or Policy
				//Fix for Issue ID BD100
				this.lblCPDReportName.Visible = false;
				this.txtCPDReportName.Visible = false;
				this.divDiskSpace.Visible = false;
				this.lblDiskSpace.Visible = false;
				this.txtDiskSpace.Visible = false;
				this.litMegabytes.Visible = false;

				Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(cboLCompletionDay, cboLCompletionMonth, cboLCompletionYear, System.DateTime.Today.Year, 5);
				Bdw.Application.Salt.Web.Utilities.WebTool.SetupDateControl(cboQCompletionDay, cboQCompletionMonth, cboQCompletionYear, System.DateTime.Today.Year, 5);

				if (UserContext.UserData.UserType == UserType.SaltAdmin)
				{
					if(this.PageAction != "add")
					{
						this.validatorOrganisationLogo.Visible = false;
						this.LoadData();
						this.SetPageState();
					}
					else // Add Organisation
					{
						this.ClassificationTypeID = 0;
                        LoadTimeZone();
						this.SetPageState();
						this.lblPageTitle.Text = ResourceManager.GetString("lblPageTitle.Add");//"Add Organisation";
					}
					
				}
				else
				{
					this.validatorOrganisationLogo.Visible = false;
					this.LoadData();
					this.SetPageState();
				}
				// message for successful addition
				if(this.AddSuccess)
				{
					this.lblMessage.Text = ResourceManager.GetString("lblMessage.Added");//"The Organisation's Details have been added successfully";
					this.lblMessage.CssClass = "SuccessMessage";
				}
                Calendar1.YearFieldName = "cboQCompletionYear";
                Calendar1.MonthFieldName = "cboQCompletionMonth";
                Calendar1.DayFieldName = "cboQCompletionDay";

                


            }			
		} // Page_Load
		
		/// <summary>
		/// Event handler method for the Save button click event.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void btnSave_Click(object sender, EventArgs e)
		{
			this.lblMessage.Text = String.Empty;
			if (this.txtDiskSpace.Visible)
			{
				this.cvDiskSpace.Validate();
			}
			if (Page.IsValid)
			{
				//1. If the page action is add then create a new organisation.
				if(this.PageAction == "add")
				{
					this.AddOrganisation();
				}
				else //2. Update the organisation details.
				{
					this.UpdateOrganisation();
				}
			}
		} // btnSave_Click
		
		/// <summary>
		/// Event handler method for the ModifyClassificationOptions link button click event.
		/// </summary>
		/// <param name="sender"> The source of the event.</param>
		/// <param name="e"> Any arguments that the event fires.</param>
		protected void lnkModifyClassificationOptions_Click(object sender, EventArgs e)
		{
			Response.Redirect("ModifyCustomClassification.aspx?ClassificationTypeID=" + this.ClassificationTypeID.ToString());
		} // lnkModifyClassificationOptions_Click
		#endregion
		
		#region Private Methods
		/// <summary>
		/// Sets the state of the page.
		/// </summary>
		private void SetPageState()
		{

            // Disable to organisation logo vaildator if label is set
            if (this.lblLogo.Text.Length == 0)
            {
                this.validatorOrganisationLogo.Enabled = true;
            }
            else
            {
                this.validatorOrganisationLogo.Enabled = false;
            }

            // Hide the link to modify custom classification options if no type ID set
            if (this.ClassificationTypeID == 0)
            {
                this.lnkModifyClassificationOptions.Visible = false;
            }
            else
            {
                this.lnkModifyClassificationOptions.Visible = true;
            }

			if (UserContext.UserData.UserType ==UserType.SaltAdmin)
			{
				this.chkAdvancedReporting.Visible = true;
				this.lblAdvancedReporting.Visible = false;
			}
			else
			{
				this.chkAdvancedReporting.Visible = false;
				this.lblAdvancedReporting.Visible = true;
			}

			//Only perform this check for OrganisationCPDAccess and OrganisationPolicyAccess if existing Org
			//Fix for Issue ID BD100
			if (this.PageAction != "add")
			{
				Bdw.Application.Salt.BusinessServices.Organisation objOrganisation = new Bdw.Application.Salt.BusinessServices.Organisation();
				if (objOrganisation.GetOrganisationCPDAccess(UserContext.UserData.OrgID))
				{
					this.lblCPDReportName.Visible = true;
					this.txtCPDReportName.Visible = true;
				}

				if (objOrganisation.GetOrganisationPolicyAccess(UserContext.UserData.OrgID))
				{
					this.lblDiskSpace.Visible = true;
					if (UserContext.UserData.UserType == UserType.SaltAdmin)
					{
						this.txtDiskSpace.Visible = true;
						this.lblDiskSpaceDisplay.Visible = false;
					}
					else
					{
						this.lblDiskSpaceDisplay.Visible = true;
						this.txtDiskSpace.Visible = false;
					}
					this.litMegabytes.Visible = true;
					this.divDiskSpace.Visible = true;
				}
			}


			this.lblIncludeLogo.Text = ResourceManager.GetString("lblIncludeLogo");
			this.lblInclLogoMsg.Text = ResourceManager.GetString("lblInclLogoMsg");

		} // SetPageState
		
		/// <summary>
		/// Loads the Data from the database for the speciied Organisation.
		/// </summary>
		private void LoadData()
		{
			DataTable dtLoadOrg;

			string strLangCode = Request.Cookies["currentCulture"].Value;
			
			Bdw.Application.Salt.BusinessServices.Organisation objOrganisation = new Bdw.Application.Salt.BusinessServices.Organisation();
			dtLoadOrg = objOrganisation.GetOrganisation(strLangCode, UserContext.UserData.OrgID);

            // If an organisation Exists
			if (dtLoadOrg.Rows.Count > 0)
			{
		
				if (dtLoadOrg.Rows[0]["AllocatedDiskSpace"].ToString().Trim() != "")
				{
					long lngDiskSpace = (long)dtLoadOrg.Rows[0]["AllocatedDiskSpace"];
					lngDiskSpace = lngDiskSpace / (1024 * 1024); //Convert from bytes to MegaBytes
					if (UserContext.UserData.UserType == UserType.SaltAdmin)
					{
						this.lblDiskSpaceDisplay.Visible = false;
						this.txtDiskSpace.Visible = true;
						this.txtDiskSpace.Text = lngDiskSpace.ToString();
						this.lblDiskSpaceDisplay.Text = lngDiskSpace.ToString();
					}
					else
					{
						this.txtDiskSpace.Visible = false;
						this.lblDiskSpaceDisplay.Visible = true;
						this.lblDiskSpaceDisplay.Text = lngDiskSpace.ToString();
						this.txtDiskSpace.Text = lngDiskSpace.ToString();
					}
				}
                this.chkBxShowLastPassDate.Checked = Boolean.Parse(dtLoadOrg.Rows[0]["ShowLastPassed"].ToString());
                this.chkDisablePasswordField.Checked = Boolean.Parse(dtLoadOrg.Rows[0]["DisablePasswordField"].ToString());
                if (chkDisablePasswordField.Checked)
                {
                    chkurlrequest.Enabled = false;
                    chkurlrequest.Checked = false;
                }
                else
                {
                    chkurlrequest.Checked = Boolean.Parse(dtLoadOrg.Rows[0]["EnableUniqueURL"].ToString());
                    chkurlrequest.Enabled = true;
                }

                int OrganisationID = UserContext.UserData.OrgID;            

                if (objOrganisation.GetOrganisationCPDEventAccess(UserContext.UserData.OrgID))
                {
                    truserevent.Visible = true;
                   
                }
                else
                {
                    truserevent.Visible = false;
                    
                }

                this.chkuserCPDEvent.Checked = Boolean.Parse(dtLoadOrg.Rows[0]["EnableUserCPDEvent"].ToString());
                
				this.txtOrganisationName.Text = dtLoadOrg.Rows[0]["OrganisationName"].ToString();
				this.txtOrganisationNotes.Text = Server.HtmlDecode(dtLoadOrg.Rows[0]["Notes"].ToString());
				this.lblLogo.Text = dtLoadOrg.Rows[0]["Logo"].ToString() + " ";
				this.cboDefaultLessonFrequency.SelectedValue = dtLoadOrg.Rows[0]["DefaultLessonFrequency"].ToString();
				this.cboDefaultQuizFrequency.SelectedValue = dtLoadOrg.Rows[0]["DefaultQuizFrequency"].ToString();
				this.txtDefaultQuizPassMark.Text = dtLoadOrg.Rows[0]["DefaultQuizPassMark"].ToString();
                this.chkEbookNotification.Checked = Boolean.Parse(dtLoadOrg.Rows[0]["DefaultEbookEmailNotification"].ToString());
				if (dtLoadOrg.Rows[0]["CPDReportName"].ToString().Equals(String.Empty))
				{
					this.txtCPDReportName.Text = "Continuing Professional Development";
				}
				else
				{
					this.txtCPDReportName.Text = dtLoadOrg.Rows[0]["CPDReportName"].ToString();
				}
				this.ckbIncludeLogo.Checked = dtLoadOrg.Rows[0]["IncludeCertificateLogo"].ToString().Trim()==""?false:Boolean.Parse(dtLoadOrg.Rows[0]["IncludeCertificateLogo"].ToString());
				this.chkActivatePassword.Checked = Boolean.Parse(dtLoadOrg.Rows[0]["PasswordLockout"].ToString());

				// Setup date dropdowns with value
				if (dtLoadOrg.Rows[0]["DefaultLessonCompletionDate"] != System.DBNull.Value)
				{
					DateTime defaultLessonCompletionDate = (DateTime)dtLoadOrg.Rows[0]["DefaultLessonCompletionDate"];
					cboLCompletionDay.SelectedValue = defaultLessonCompletionDate.Day.ToString();
					cboLCompletionMonth.SelectedValue = defaultLessonCompletionDate.Month.ToString();
					cboLCompletionYear.SelectedValue = defaultLessonCompletionDate.Year.ToString();
				}

				if (dtLoadOrg.Rows[0]["DefaultQuizCompletionDate"] != System.DBNull.Value)
				{
					DateTime defaultQuizCompletionDate = (DateTime)dtLoadOrg.Rows[0]["DefaultQuizCompletionDate"];
					cboQCompletionDay.SelectedValue = defaultQuizCompletionDate.Day.ToString();
					cboQCompletionMonth.SelectedValue = defaultQuizCompletionDate.Month.ToString();
					cboQCompletionYear.SelectedValue = defaultQuizCompletionDate.Year.ToString();
				}


			
				if (UserContext.UserData.UserType ==UserType.SaltAdmin)
				{
					this.chkAdvancedReporting.Checked = (bool)dtLoadOrg.Rows[0]["AdvancedReporting"];
				}
				else
				{
					this.lblAdvancedReporting.Text = (bool)dtLoadOrg.Rows[0]["AdvancedReporting"]?ResourceManager.GetString("Yes"):ResourceManager.GetString("No");
				}

				DateTime dtOriginalDateUpdated = (DateTime)dtLoadOrg.Rows[0]["DateUpdated"];
				this.OriginalDateUpdated = DatabaseTool.ToLongDateTimeString(dtOriginalDateUpdated);
			
				Classification objClassification = new Classification();
				DataTable dtbClassificationType = objClassification.GetClassificationType(UserContext.UserData.OrgID);
			
				if(dtbClassificationType.Rows.Count > 0)
				{
					this.ClassificationTypeID = Int32.Parse(dtbClassificationType.Rows[0]["ClassificationTypeID"].ToString());
                    //this.lblCustomClasification.Text = dtbClassificationType.Rows[0]["Name"].ToString();
					this.txtClassificationName.Text = dtbClassificationType.Rows[0]["Name"].ToString();
				}
			}
			else
			{
				this.lblMessage.Text=ResourceManager.GetString("lblMessage.NoOrg");//"No Organisations Exist.";
                this.lblMessage.CssClass = "FeedbackMessage";
				this.plhOrganisationDetails.Visible=false;
			}
            
            // hide the ebook checkbox if the organisation does not have ebook feature
            bool hasEbookAccess = objOrganisation.GetOrganisationEbookAccess(UserContext.UserData.OrgID);
            if (!hasEbookAccess)
            {
                this.plhEbookNotification.Visible = false;
            }
            else
            {
                this.plhEbookNotification.Visible = true;
            }


            
            if (!IsPostBack)
            {
                LoadTimeZone();
                int OrgTZId = 0;
                Int32.TryParse(dtLoadOrg.Rows[0]["TimeZoneID"].ToString(), out OrgTZId);
                string orgFLBName = null;

                using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetFLBNamefromTZID",
                    StoredProcedure.CreateInputParam("@TimezoneID", SqlDbType.Int, OrgTZId))
                    )
                {
                    orgFLBName = sp.ExecuteScalar().ToString();
                }
                listTimeZone.SelectedValue = listTimeZone.Items.FindByText(orgFLBName).Value;
            }

		} // LoadData


        private void LoadTimeZone()
        {
            List<string> tzList = new List<string>();
            DataTable dtTzTable = new DataTable();

            using (StoredProcedure sp = new StoredProcedure("prcTimeZone_GetList"))
            {
                dtTzTable = sp.ExecuteTable();
            }

            tzList = (from tzRow in dtTzTable.AsEnumerable()
                      select tzRow.Field<string>("FLB_Name")).ToList();
            listTimeZone.DataSource = tzList;
            listTimeZone.DataBind();
            int selectedIndex = tzList.FindIndex(delegate(string s) { return s.Contains("(UTC+10:00) Canberra, Melbourne, Sydney"); });
            listTimeZone.SelectedValue = listTimeZone.Items[selectedIndex].Value;
        }
		/// <summary>
		/// Add the new organisation details to the database.
		/// </summary>
		private void AddOrganisation()
		{
			try
			{
				//2. Add the new organisation.
				string strLogoName = this.GetOrganisationLogo();

				BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
                
				string strOrganisationNotes;				
				strOrganisationNotes = BusinessServices.HTMLSanitizer.Sanitize(this.txtOrganisationNotes.Text);
				strOrganisationNotes= Server.HtmlEncode(strOrganisationNotes);
                
				DateTime defaultLessonCompletionDate = DateTime.Parse("1/1/1900");
				DateTime defaultQuizCompletionDate = DateTime.Parse("1/1/1900");

				// if  txtCPDReportName and/or txtDiskSpace visible then parse values otherwise parse Null
				string strCPDReportName;
				if (this.txtCPDReportName.Visible) 
					{strCPDReportName = this.txtCPDReportName.Text;}
				else {strCPDReportName = "";}

				long lngDiskSpace;
				if (this.txtDiskSpace.Text.Trim() != "")
				{
					lngDiskSpace = long.Parse(this.txtDiskSpace.Text);
					lngDiskSpace = lngDiskSpace * (1024^2); //Convert to  bytes
				}
				else
				{
					lngDiskSpace = 0;
				}
				if (!ValidateOrganisation(ref defaultLessonCompletionDate, ref defaultQuizCompletionDate)) { return; }


				int intOrganisationID = objOrganisation.AddOrganisation(this.txtOrganisationName.Text, strOrganisationNotes, strLogoName,
					Int32.Parse(this.cboDefaultLessonFrequency.SelectedValue), 
					Int32.Parse(this.cboDefaultQuizFrequency.SelectedValue),
					Int32.Parse(this.txtDefaultQuizPassMark.Text), 
					defaultLessonCompletionDate,
					defaultQuizCompletionDate,
					this.chkAdvancedReporting.Checked, 
					UserContext.UserID,
					strCPDReportName,
					lngDiskSpace,
					this.ckbIncludeLogo.Checked,
					this.chkActivatePassword.Checked,
                    this.listTimeZone.SelectedItem.ToString(),
                    chkBxShowLastPassDate.Checked,
                    chkDisablePasswordField.Checked,
                    chkurlrequest.Checked,
					chkuserCPDEvent.Checked,
                    chkEbookNotification.Checked);
					 
				//3. Save the Organisation Logo
				this.SaveOrganisationLogo(strLogoName);
					
				//4. Save the ClassificationName
                if (this.txtClassificationName.Text != "")
                {
                    Classification objClassification = new Classification();
                    objClassification.AddClassificationType(this.txtClassificationName.Text, intOrganisationID);
                }

				// re select the organisation
				WebSecurity.SelectOrganisation(intOrganisationID);
				
				Response.Redirect("OrganisationDetails.aspx?adsx=true");				
			}
			catch(UniqueViolationException ex)
			{
				this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
			}
			catch(ParameterException ex)
			{
				throw ex;
			}
			catch(PermissionDeniedException ex)
			{
				this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
			}
			catch(Exception ex)
			{
				throw new ApplicationException(ex.Message);
			}
		} // AddOrganisation
		
		/// <summary>
		/// Updates the organisation details.
		/// </summary>
		private void UpdateOrganisation()
		{
            try
            {
				DateTime defaultLessonCompletionDate = DateTime.Parse("1/1/1900");
				DateTime defaultQuizCompletionDate = DateTime.Parse("1/1/1900");
				DateTime defaultOriginalDateUpdated = DateTime.Parse("1/1/1990");
				if (!ValidateOrganisation(ref defaultLessonCompletionDate, ref defaultQuizCompletionDate)) { return; }


                string strLogoName = this.GetOrganisationLogo();
                DateTime dtOriginalDateUpdated = DateTime.Parse(this.OriginalDateUpdated);

				string strOrganisationNotes;				
				strOrganisationNotes = BusinessServices.HTMLSanitizer.Sanitize(this.txtOrganisationNotes.Text);
				strOrganisationNotes= Server.HtmlEncode(strOrganisationNotes);
				
				long lngDiskSpace;
				if (this.txtDiskSpace.Text.Trim() != "")
				{
					lngDiskSpace = long.Parse(this.txtDiskSpace.Text);
					lngDiskSpace = lngDiskSpace * (1024 * 1024); //Convert to  bytes
				}
				else
				{
					lngDiskSpace = 0;
				}
				string strLangCode = Request.Cookies["currentCulture"].Value;
                Bdw.Application.Salt.BusinessServices.Organisation objOrganisation = new Bdw.Application.Salt.BusinessServices.Organisation();
				
				objOrganisation.UpdateOrganisation(strLangCode, UserContext.UserData.OrgID, this.txtOrganisationName.Text, strOrganisationNotes,
					strLogoName,
					this.cboDefaultLessonFrequency.SelectedValue==null?System.Data.SqlTypes.SqlInt32.Null:Int32.Parse(this.cboDefaultLessonFrequency.SelectedValue), 
					this.cboDefaultLessonFrequency.SelectedValue==null?System.Data.SqlTypes.SqlInt32.Null:Int32.Parse(this.cboDefaultQuizFrequency.SelectedValue),
                    this.txtDefaultQuizPassMark.Text==""?System.Data.SqlTypes.SqlInt32.Null:Int32.Parse(this.txtDefaultQuizPassMark.Text),
					defaultLessonCompletionDate,
					defaultQuizCompletionDate,
					UserContext.UserData.UserType ==UserType.SaltAdmin?this.chkAdvancedReporting.Checked:System.Data.SqlTypes.SqlBoolean.Null,
					UserContext.UserID, 
					dtOriginalDateUpdated,
					this.txtCPDReportName.Text,
					lngDiskSpace,
					System.Data.SqlTypes.SqlBoolean.Parse(this.ckbIncludeLogo.Checked.ToString()),
					System.Data.SqlTypes.SqlBoolean.Parse(this.chkActivatePassword.Checked.ToString()),
                    this.listTimeZone.SelectedItem.ToString(),
                    chkBxShowLastPassDate.Checked,
                    chkDisablePasswordField.Checked,
                    chkurlrequest.Checked,
					chkuserCPDEvent.Checked,
                    chkEbookNotification.Checked
                    );
			
                //7. Save the Organisation Logo
                this.SaveOrganisationLogo(strLogoName);
			
                if (this.txtClassificationName.Text != "")
                {
                    if(this.ClassificationTypeID == 0)
                    {
                        //4. Save the ClassificationName
                        Classification objClassification = new Classification();
                        objClassification.AddClassificationType(this.txtClassificationName.Text, UserContext.UserData.OrgID);
                    }
                    else
                    {
                        //8. Update the ClassificationType name.
                        Classification objClassification = new Classification();
                        objClassification.UpdateClassificationType(this.txtClassificationName.Text, this.ClassificationTypeID, UserContext.UserData.OrgID);
                    }
                }

				if (ckbOverrideUnitLF.Checked)
					BusinessServices.Unit.OverrideLessonCompliance(UserContext.UserData.OrgID, defaultLessonCompletionDate, Int32.Parse(this.cboDefaultLessonFrequency.SelectedValue));

				if (ckbOverrideUnitQF.Checked)
					BusinessServices.Unit.OverrideQuizCompliance(UserContext.UserData.OrgID, defaultQuizCompletionDate, Int32.Parse(this.cboDefaultQuizFrequency.SelectedValue));

                //9. Reload the page
                //Response.Redirect("OrganisationDetails.aspx");
                this.lblMessage.Text = ResourceManager.GetString("lblMessage.Saved");//"The Organisation's Details have been updated successfully";
                this.lblMessage.CssClass = "SuccessMessage";

                //10. Refresh the UI
                this.LoadData();
                this.SetPageState();
            }
            catch(UniqueViolationException ex)
            {
                this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
            }
            catch(ParameterException ex)
            {
                this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
            }
            catch(PermissionDeniedException ex)
            {
                this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
            }
            catch(IntegrityViolationException ex)
            {
                this.lblMessage.Text = ex.Message;
                this.lblMessage.CssClass = "WarningMessage";
            }
            catch(Exception ex)
            {
                throw new ApplicationException(ex.Message);
            }
		} // UpdateOrganisation
		
		/// <summary>
		/// Gets the name for the organisation logo.
		/// </summary>
		/// <returns> The name for the organisation logo.</returns>
		private string GetOrganisationLogo()
		{
			if(this.fileLogo.PostedFile.FileName != "")
			{
                string strExtension = Path.GetExtension(this.fileLogo.Value).ToLower();
                if (strExtension != ".gif" && strExtension!=".jpg" && strExtension!=".bmp" && strExtension!=".jpeg")
                {
                    throw new PermissionDeniedException(ResourceManager.GetString("ImageUploadError"));
                }
				string strOrganisationName;
				strOrganisationName = this.txtOrganisationName.Text.Replace(" ", "").Replace("'", "").Replace(".", "");			
				return strOrganisationName + Path.GetExtension(this.fileLogo.Value);
			}
			else
			{
				return this.lblLogo.Text;
			}
		} // GetOrganisationLogo
		
		/// <summary>
		/// Saves the Organisation Logo image to the specified directory.
		/// </summary>
		/// <param name="logoName"> The name of the image to be saved.</param>
		private void SaveOrganisationLogo(string logoName)
		{
			if(this.fileLogo.PostedFile.FileName != "")
			{
				try
				{
					this.fileLogo.PostedFile.SaveAs(Server.MapPath(m_strOrganisationImagesPath) + logoName);
				}
				catch(FieldAccessException ex)
				{
					this.lblMessage.Text = ex.Message;
                    this.lblMessage.CssClass = "WarningMessage";
				}
				catch(Exception ex)
				{
					throw ex;
				}
			}
		} // SaveOrganisationLogo

		private bool ValidateOrganisation(ref DateTime defaultLessonCompletionDate, ref DateTime defaultQuizCompletionDate)
		{
			// The length of the org notes must be validated seperately because
			// the text area control doesnt have a maximum length.
			// There is a Server.HtmlEncode on the data that transforms < to &lt etc. 
			// so some need to encode before checking if will be larger than data limit in db
			string strOrgNotesEncoded = Server.HtmlEncode(this.txtOrganisationNotes.Text);
			if (strOrgNotesEncoded.Length > 4000)
			{
				this.lblMessage.Text = ResourceManager.GetString("lblMessage.Error");//"The Organisation notes may contain no more than 4000 characters.";
				this.lblMessage.CssClass = "WarningMessage";
				return false;
			}

			//-- Emerging Bug Issue 5, 6
			string strErrorMessage = string.Empty;
			strErrorMessage = Bdw.Application.Salt.Web.General.Shared.Validation.Validate_Frequency_CompletionDates(ref defaultLessonCompletionDate, cboDefaultLessonFrequency.SelectedValue, cboLCompletionDay.SelectedValue, cboLCompletionMonth.SelectedValue, cboLCompletionYear.SelectedValue);
			
			if (strErrorMessage == string.Empty)
				strErrorMessage = Bdw.Application.Salt.Web.General.Shared.Validation.Validate_Frequency_CompletionDates(ref defaultQuizCompletionDate, cboDefaultQuizFrequency.SelectedValue, cboQCompletionDay.SelectedValue, cboQCompletionMonth.SelectedValue, cboQCompletionYear.SelectedValue);

			if (strErrorMessage != string.Empty)
			{
				this.lblMessage.Text = strErrorMessage;
				this.lblMessage.CssClass = "WarningMessage";
				return false;
			}

			return true;

		}
		
		protected void cvDiskSpace_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			// Get value in txtDiskSpace
			string strDiskSpace = this.txtDiskSpace.Text;

			// If empty then return validation message
			if(strDiskSpace.Equals(String.Empty))
			{
				this.lblMessage.Text = ResourceManager.GetString("rfvDiskSpace");
				this.lblMessage.CssClass = "WarningMessage";
				//((CustomValidator)source).ErrorMessage = ResourceManager.GetString("rfvDiskSpace");
				args.IsValid = false;
				return;
			}

			// If not numeric then return validation message
			if(!IsIntNumeric(strDiskSpace))
			{
				this.lblMessage.Text = ResourceManager.GetString("revDiskSpace");
				this.lblMessage.CssClass = "WarningMessage";
				//((CustomValidator)source).ErrorMessage = ResourceManager.GetString("revDiskSpace");
				args.IsValid = false;
				return;
			}
		}

		private static bool IsIntNumeric(string strToCheck)
		{
			return Regex.IsMatch(strToCheck,@"^[+]?[1-9]\d*\.?[0]*$");
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
            apptitle.Text = ApplicationSettings.AppName;

		} // OnInit
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
          
		}		
        #endregion


        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
            //Calendar1.Visible = !Calendar1.Visible;
        }

        protected void Calendar1_Unload(object sender, EventArgs e)
        {

        }
        
        protected void btnCollapse_Click(object sender, EventArgs e)
        {

        }
    }
}
