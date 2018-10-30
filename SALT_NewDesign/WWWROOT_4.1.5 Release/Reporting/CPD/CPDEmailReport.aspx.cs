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
using Localization;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Utilities;

namespace Bdw.Application.Salt.Web.Reporting.CPD
{
	/// <summary>
	/// Summary description for CPDEmailReport.
	/// </summary>
	public partial class CPDEmailReport : System.Web.UI.Page
	{
		protected System.Web.UI.WebControls.Label lblMessage;

		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			// Put user code to initialize the page here
			if(!Page.IsPostBack)
			{
				this.plhSearchCriteria.Visible = true;
				this.plhReportResults.Visible = false;
				this.plhComplete.Visible = false;
				this.LoadProfile();
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
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
            this.grdPagination.SortCommand += new System.Web.UI.WebControls.DataGridSortCommandEventHandler(this.grdPagination_SortCommand);
            this.grdPagination.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.grdPagination_ItemDataBound);
            this.cboPage.SelectedIndexChanged += new System.EventHandler(this.cboPage_SelectedIndexChanged);
            this.btnPrev.Click += new System.EventHandler(this.btnPrev_Click);
            this.btnNext.Click += new System.EventHandler(this.btnNext_Click);
            this.btnBack.Click += new System.EventHandler(this.btnBack_Click);
            this.Load += new System.EventHandler(this.Page_Load);
            this.btnReset.Click += new System.EventHandler(this.btnReset_Click);
            this.btnGenerate.Click += new System.EventHandler(this.btnGenerate_click);
            this.btnSendEmail.Click += new System.EventHandler(this.btnSendEmail_Click);
            this.btnBackToMain.Click += new System.EventHandler(this.btnBackToMain_Click);


		}

		private void LoadProfile()
		{
			LoadUnitTree();
			int intOrganisationID = UserContext.UserData.OrgID; // organisation ID
			BusinessServices.Profile objProfile = new BusinessServices.Profile(); //Profile Object
			DataTable dtbProfile = objProfile.GetProfilesForCurrentOrg(intOrganisationID); // List of profiles accesable to the organisation
			if (dtbProfile.Rows.Count==0)
			{
				this.plhSearchCriteria.Visible=false;
				this.lblError.Text=ResourceManager.GetString("lblError.NoProfile");//"No profiles exist within this organisation.";
				this.lblError.CssClass = "FeedbackMessage";
				this.lblError.Visible=true;
				return;
			}
			cboProfile.DataSource = dtbProfile;
			cboProfile.DataValueField = "ProfileID";
			cboProfile.DataTextField = "ProfileName";
			cboProfile.DataBind();			
		}

		private void btnReset_Click(object sender, System.EventArgs e)
		{
			// Re-call the same page so that the default search criteria values are shown
			Response.Redirect(Request.RawUrl);
		}

		private void btnGenerate_click(object sender, System.EventArgs e)
		{
			// set this to null so all users can get selected initially
			ViewState["UserIDsHaveBeenPopulated"]=null;
			this.txtUserIDs.Text = "";
			this.plhSearchCriteria.Visible = false;
			this.plhReportResults.Visible = true;
			StartPagination();
		}

		private void btnBack_Click(object sender, System.EventArgs e)
		{
			this.plhSearchCriteria.Visible = true;
			this.plhReportResults.Visible = false;
		}

		private void btnSendEmail_Click(object sender, System.EventArgs e)
		{
			string strSubject = txtsubject.Text; // get the subject
			string strEmailBodyTemplate = txtEmailBody.Text; // get the email text
            string strEmailBody = "";
			string strEmailAddress;
			string strEmailToName;
			string strUsers ="";
			BusinessServices.Email objEmail = new BusinessServices.Email();
			// Get the current users details.
			BusinessServices.User objUser = new BusinessServices.User();
            DataTable dtbCurrentUserDetails = objUser.GetUser(UserContext.UserID);
    				
			// Setup email header
			string strEmailFromName = dtbCurrentUserDetails.Rows[0]["FirstName"].ToString() + " " + dtbCurrentUserDetails.Rows[0]["LastName"].ToString();
			string strEmailFromEmail =  dtbCurrentUserDetails.Rows[0]["Email"].ToString();
			
			// Validate that the user has a valid recipient, subject and body.
            if (this.txtUserIDs.Text.Length > 0 && strSubject.Length > 0 && strEmailBodyTemplate.Length > 0)
			{
				DataTable dtbUsers = objUser.GetEmails(this.txtUserIDs.Text);
			
				DataTable dtbEmailAddresses = objUser.GetEmails(this.txtUserIDs.Text);

                	
				// For each user in the table
				foreach(DataRow drwEmailAddress in dtbEmailAddresses.Rows)
				{						
					// get the email address
					strEmailAddress = drwEmailAddress.ItemArray[3].ToString();
					// Get their Name
					strEmailToName = drwEmailAddress.ItemArray[0].ToString() + " " + drwEmailAddress.ItemArray[1].ToString();

                    // get userid
                    int userID = 0;
                    Int32.TryParse(drwEmailAddress["userID"].ToString(), out userID);

                    objEmail.SetEmailBody(strEmailBodyTemplate, userID, "", "", "", "", "", "", "", "");
                    strSubject = objEmail.emailHeaderSub(strSubject);
					// Attempt to send them an email
                    objEmail.SendEmail(strEmailAddress, strEmailToName, strEmailFromEmail, strEmailFromName, null, null, strSubject, ApplicationSettings.MailServer, UserContext.UserData.OrgID, userID);
					strUsers += "\n\t" + strEmailToName;								
				}
			}
			// send the administrator email
			string strAdminEmail = GetEmailBody(EmailReportType.Email_Incomplete_CPD_Administrator);
            
            objEmail.SetEmailBody(strAdminEmail, UserContext.UserID, "", "", "", strUsers, "", "", "", "");

            objEmail.SendEmail(strEmailFromEmail, strEmailFromName, strEmailFromEmail, strEmailFromName, null, null, strSubject, ApplicationSettings.MailServer, UserContext.UserData.OrgID, UserContext.UserID);

			// done
			this.plhReportResults.Visible=false;
			this.plhComplete.Visible=true;
		}

        protected void btnBackToMain_Click(object sender, System.EventArgs e)
		{
			Response.Redirect("CPDEmailReport.aspx");
		}

		private void StartPagination()
		{
			//Initialize Pagination settings
			ViewState["OrderByField"]="";
			ViewState["OrderByDirection"]="";
			this.SetPaginationOrder("hierarchyname"); //customization
			this.txtEmailBody.Text = GetEmailBody(EmailReportType.Email_Incomplete_CPD_User);
			this.tblPagination.Visible = true;
			this.ShowDataPage(0);
		}

		private string GetEmailBody(EmailReportType emailReportType)
		{
			OrganisationConfig objOrgConfig = new OrganisationConfig();
			BusinessServices.AppConfig objAppConfig = new BusinessServices.AppConfig();
			string strEmailBody="";

			switch (emailReportType)
			{
				case EmailReportType.Email_Incomplete_CPD_User:
				{
					strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Incomplete_CPD_User");
					break;
				}
				
				case EmailReportType.Email_Incomplete_CPD_Administrator:
				{
					strEmailBody = objOrgConfig.GetOne(UserContext.UserData.OrgID,"Email_Incomplete_CPD_Administrator");
					break;
				}
			} // switch

			
			// Get the application conffiguration details
			DataTable dtbAppConfig = objAppConfig.GetList();

			// Setup the email body
			foreach (DataRow drwAppConfig in dtbAppConfig.Rows)
			{
				if (drwAppConfig.ItemArray[0].ToString().ToUpper()=="APPNAME")
				{
					strEmailBody = strEmailBody.Replace("%APP_NAME%",drwAppConfig.ItemArray[1].ToString());
				}
			}
			strEmailBody = strEmailBody.Replace("<BR>",Environment.NewLine);
			return (strEmailBody);
		}


		private void ShowDataPage(int currentPageIndex)
		{
			try
			{
				BusinessServices.Profile objProfile = new BusinessServices.Profile();
				int intProfileID = Int32.Parse(cboProfile.SelectedValue.ToString());

				string[] selectUnits;
				selectUnits = trvUnitPath.GetSelectedValues();
				//Double check
				BusinessServices.Unit objUnit = new  BusinessServices.Unit();
				selectUnits = objUnit.ReturnAdministrableUnitsByUserID( UserContext.UserID, UserContext.UserData.OrgID, selectUnits);
				string  strParentUnits  = String.Join(",",selectUnits);

				//1. Get data
				DataView  dvwPagination = objProfile.GetCPDEmailData(intProfileID, strParentUnits);
				
				if ( dvwPagination.Table.Rows.Count==0)
				{
					this.lblError.Text += "<BR>" + ResourceManager.GetString("lblError.NoDataFound");
					this.lblError.CssClass = "FeedbackMessage";
					this.plhSearchCriteria.Visible=false;
					this.plhReportResults.Visible=false;
					this.lblError.Visible=true;
				}
				else
				{
					//1.5 record the user ids to send the emails to
					// Only Populate it the first time
					if (ViewState["UserIDsHaveBeenPopulated"]==null)
					{
						foreach (DataRow drwUser in dvwPagination.Table.Rows)
						{
							this.txtUserIDs.Text += drwUser.ItemArray[1].ToString() + ",";
						}
						// remove trailing comma
						if (this.txtUserIDs.Text.Length > 0)
						{
							this.txtUserIDs.Text = this.txtUserIDs.Text.Substring(0,this.txtUserIDs.Text.Length-1);
						}
						ViewState["UserIDsHaveBeenPopulated"]="Yes";
					}

					//2. Sort Data
					string	strOrderByField, strOrderByDirection;
					strOrderByField =(string)ViewState["OrderByField"];
					strOrderByDirection =(string)ViewState["OrderByDirection"];

					dvwPagination.Sort = strOrderByField + " " + strOrderByDirection;

					//3. Set pagination panel
					int intPageSize;
					intPageSize = ApplicationSettings.PageSize ;
					this.SetPaginationPanel(intPageSize, dvwPagination.Count,ref currentPageIndex);

					//4. Bind Data
					grdPagination.DataSource = dvwPagination;
					grdPagination.PageSize = intPageSize;
					grdPagination.CurrentPageIndex = currentPageIndex;
					grdPagination.DataBind();
				} 
			}
			catch(BusinessServiceException ex)
			{
				this.tblPagination.Visible=false;
				this.lblMessage.Text = ex.Message;
				this.lblMessage.CssClass = "WarningMessage";
			}
		}

		private void SetPaginationOrder(string orderByField)
		{
			string	strOldOrderByField, strOldOrderByDirection;
			string  strOrderByDirection;

			strOldOrderByField =(string)ViewState["OrderByField"];
			strOldOrderByDirection =(string)ViewState["OrderByDirection"];
			//set the orderby direction.
			if(strOldOrderByField == orderByField)
			{
				switch(strOldOrderByDirection.ToUpper())
				{
					case "ASC":
						strOrderByDirection = "DESC";
						break;
					case "DESC":
						strOrderByDirection = "ASC";
						break;
					default:
						strOrderByDirection = "ASC";
						break;
				}
			}
			else
			{
				strOrderByDirection = "ASC";
			}
			//save the order by direction and field to the view state.
			ViewState["OrderByField"] = orderByField;
			ViewState["OrderByDirection"] = strOrderByDirection;
		}

		private void SetPaginationPanel(int pageSize, int totalRecordCount, ref int currentPageIndex)
		{
			//1. Get pagination info
			int intPageSize,intTotalRecordCount,intPageCount,intCurrentPageStart, intCurrentPageEnd;
			ListItem objItem;
			

			intPageSize = pageSize;
			intTotalRecordCount = totalRecordCount;
			intPageCount = ((int)(intTotalRecordCount-1)/intPageSize)+1;

			//Check currentPageIndex
			if (currentPageIndex<0)
			{
				currentPageIndex=0;
			}
			else if (currentPageIndex>intPageCount-1)
			{
				currentPageIndex=intPageCount-1;
			}

			//Page start record number
			if (intTotalRecordCount!=0)
			{
				intCurrentPageStart = intPageSize * currentPageIndex+1;
			}
			else
			{
				intCurrentPageStart = 0;
			}
			//Page end record number
			if (currentPageIndex<intPageCount-1)
			{
				intCurrentPageEnd =  intPageSize * (currentPageIndex+1);
			}
				//Last page, the page record count is the remaining records
			else
			{
				intCurrentPageEnd = intTotalRecordCount;
			}
			
			//2. Set  pagination
			//2.1 Set dropdown page selector
			this.cboPage.Items.Clear();
			for(int i=1;i<= intPageCount; i++)
			{
				objItem = new ListItem(i.ToString());
				if (i==currentPageIndex+1)
				{
					objItem.Selected = true;
				}		
				this.cboPage.Items.Add(objItem);
			}
			//2.2 Set Page numbers
			this.lblPageCount.Text = intPageCount.ToString();
			this.lblCurrentPageRecordCount.Text = intCurrentPageStart.ToString() +" - " + intCurrentPageEnd.ToString();
			this.lblTotalRecordCount.Text = intTotalRecordCount.ToString();
			//2.3 Disable prev, next buttons
			this.btnPrev.Enabled = true;
			this.btnNext.Enabled = true;
			//First Page
			if (currentPageIndex==0)
			{	
				this.btnPrev.Enabled = false;
			}
			//Last Page
			if (currentPageIndex==intPageCount-1)
			{	
				this.btnNext.Enabled = false;
			}
		}


		#endregion
		#region Pagination event handler(Don't make any changes to this section)
		/// <summary>
		/// Go to previous page
		/// </summary>
		protected void btnPrev_Click(object sender, System.EventArgs e)
		{
			
			this.ShowDataPage(this.grdPagination.CurrentPageIndex-1);
		}
		/// <summary>
		/// Go to next page	
		/// </summary>
		protected void btnNext_Click(object sender, System.EventArgs e)
		{
			this.ShowDataPage(this.grdPagination.CurrentPageIndex+1);
		}

		/// <summary>
		/// Go to a specific page
		/// </summary>
		protected void cboPage_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			int intPageIndex;
			intPageIndex = int.Parse(this.cboPage.SelectedValue);
			this.ShowDataPage(intPageIndex-1);
		}

		/// <summary>
		///Sort data
		/// </summary>
		private void grdPagination_SortCommand(object source, System.Web.UI.WebControls.DataGridSortCommandEventArgs e)
		{
			this.SetPaginationOrder(e.SortExpression);
			this.ShowDataPage(0);
		}

		private void grdPagination_ItemDataBound(object sender, DataGridItemEventArgs e)
		{
			// This event is triggered with ever row drawn by the datagrid
			// but we only want to handle the data rows, not the headers etc.
			if(e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.SelectedItem || e.Item.ItemType == ListItemType.EditItem)
			{
				System.Web.UI.WebControls.CheckBox objCheckbox =(System.Web.UI.WebControls.CheckBox) e.Item.Cells[0].Controls[1];
				objCheckbox.Attributes.Add("onClick","Control_ClickCheckBox('txtUserIDs',this,'" + e.Item.Cells[5].Text +"');");
				objCheckbox.Checked=false;
				string[] astrUserIDs = txtUserIDs.Text.Split(',');

				foreach (string strUserID in astrUserIDs)
				{
					if (strUserID == e.Item.Cells[5].Text)
					{
						objCheckbox.Checked=true;
					}
				}
    				
			}
		}

		private void LoadUnitTree()
		{
			BusinessServices.Unit objUnit= new  BusinessServices.Unit(); // Unit Object
			DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID,UserContext.UserID,'A'); // Data set to contain unit details
			if (dstUnits.Tables[0].Rows.Count==0)
			{
				this.plhSearchCriteria.Visible=false;
				this.lblError.Text=ResourceManager.GetString("lblError.NoUnit");//"No units exist within this organisation.";
				this.lblError.Visible=true;

				return;
			}
			string strUnits = UnitTreeConvert.ConvertXml(dstUnits); // comma seperated list of units
			this.trvUnitPath.LoadXml(strUnits);
		}

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
		#endregion
	}
}
