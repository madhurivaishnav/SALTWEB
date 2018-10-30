namespace Bdw.Application.Salt.Web.General.UserControls
{
	using System;
	using System.Configuration;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;
	using System.IO;
	using System.Text;
	using System.Text.RegularExpressions;
	using Bdw.Application.Salt.Data;
	using Bdw.Application.Salt.Utilities;
	using Bdw.Application.Salt.Web.Utilities;
	using Localization;
	using System.Data.SqlTypes;
    using System.Collections.Generic;
    using Bdw.Application.Salt.Web.Reporting;
    using System.Data.Linq;
    using System.Linq;

	/// <summary>
	///		Summary description for ImportUsers.
	/// </summary>
	public partial class ImportUsers : System.Web.UI.UserControl
	{
		#region Private Variables
		private string m_strXMLNamespace = ConfigurationSettings.AppSettings["XMLNamespace"];
		private string m_strImportUsersXSD = ConfigurationSettings.AppSettings["ImportUsersXSD"];
		private string m_strUploadedFilePath = ConfigurationSettings.AppSettings["UploadedFilePath"];
		#endregion
		
		#region Protected Variables

        /// <summary>
        /// Label to display messages
        /// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// Datagrid to show total results
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid dtgUploadResultTotals;

        /// <summary>
        /// Datagrid to show details of upload
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid dtgUploadResultDetails;

        /// <summary>
        /// Datagrid for pagination
        /// </summary>
		protected System.Web.UI.WebControls.DataGrid grdPagination;

        /// <summary>
        /// Page selector to jump to a selected page
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboPage;

        /// <summary>
        /// Label to display page count
        /// </summary>
		protected System.Web.UI.WebControls.Label lblPageCount;

        /// <summary>
        /// Label to display current records on page
        /// </summary>
		protected System.Web.UI.WebControls.Label lblCurrentPageRecordCount;

        /// <summary>
        /// Label to record total records
        /// </summary>
		protected System.Web.UI.WebControls.Label lblTotalRecordCount;

        /// <summary>
        /// Table surrounding pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTable tblPagination;

        /// <summary>
        /// Table row surrounding pagination
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlTableRow trPagination;

        /// <summary>
        /// Html upload control for the csv file.
        /// </summary>
		protected System.Web.UI.HtmlControls.HtmlInputFile fileUserCSV;

        /// <summary>
        /// Html upload control for the xml file.
        /// </summary>
        protected System.Web.UI.HtmlControls.HtmlInputFile fileUserXML;

        /// <summary>
        /// Validator for the file upload control
        /// </summary>
		protected System.Web.UI.WebControls.RequiredFieldValidator requiredFieldFileUserXML;

        /// <summary>
        /// Label for unit name
        /// </summary>
        protected System.Web.UI.WebControls.Label lblUnitName;

        /// <summary>
        /// Label for unit name
        /// </summary>
        protected System.Web.UI.WebControls.Label lblUnitNameLabel;

        /// <summary>
        /// Placeholder for results
        /// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhResults;

		protected System.Web.UI.WebControls.PlaceHolder plhErrMsg;
		protected System.Web.UI.HtmlControls.HtmlTableCell tdRowNumber;
		protected System.Web.UI.HtmlControls.HtmlTableCell tdUsername;
		protected System.Web.UI.HtmlControls.HtmlTableCell tdFirstName;
		protected System.Web.UI.HtmlControls.HtmlTableCell tdLastNamer;
		protected System.Web.UI.HtmlControls.HtmlTableCell tdEmail;
		protected System.Web.UI.HtmlControls.HtmlTableCell tdUnitID;
		protected System.Web.UI.HtmlControls.HtmlTableCell tdReason;
		protected System.Web.UI.HtmlControls.HtmlTableCell tdPassword;
		protected System.Web.UI.HtmlControls.HtmlTableCell tdClassification;
        protected System.Web.UI.HtmlControls.HtmlTableCell tdExternalID;
        protected System.Web.UI.HtmlControls.HtmlTableCell NotifyUnitAdmin;
        protected System.Web.UI.HtmlControls.HtmlTableCell NotifyOrgAdmin;
        protected System.Web.UI.HtmlControls.HtmlTableCell ManagerNotification;
        protected System.Web.UI.HtmlControls.HtmlTableCell ManagerToNotify;
		protected System.Web.UI.WebControls.PlaceHolder plhErrField;
		protected System.Web.UI.HtmlControls.HtmlTableRow trUserRecord;
		/// <summary>
        /// Placeholder for search criteria
        /// </summary>
		protected System.Web.UI.WebControls.PlaceHolder plhSearchCriteria;
	
		
		#endregion
		
		#region Private Properties
		/// <summary>
		/// Gets the Hierachy of where the call to Import Users was made from.
		/// </summary>
		private string Hierachy
		{
			get
			{
				return HttpContext.Current.Items["Hierachy"].ToString();
			}
		}
		
		/// <summary>
		/// Gets the OranisationID or UnitID depending on where the call to import users was made from.
		/// </summary>
		/// <remarks> If the User is a SatAdmin then the UnitID is retrieved from the QueryString.</remarks>
		private int HierachyID
		{
			get
			{
				if (this.Hierachy == "Organisation")
				{
					return UserContext.UserData.OrgID;
                }
				else //UnitAdmin
				{
					// Get UnitID from the QueryString.
					return Int32.Parse(Request.QueryString["UnitID"]);
				}
			}
		}
		#endregion

        public List<string> InactivatedUsernames
        {
            get
            {
                if ((object)Session["InactivatedUsernames"] == null)
                {
                    return new List<string>();
                }
                else
                    return (List<string>)Session["InactivatedUsernames"];
            }
            set
            {
                Session["InactivatedUsernames"] = value;
            }
        }

        public List<string> InactivatedEmails
        {
            get
            {
                if ((object)Session["InactivatedEmails"] == null)
                {
                    return new List<string>();
                }
                else
                    return (List<string>)Session["InactivatedEmails"];
            }
            set
            {
                Session["InactivatedEmails"] = value;
            }
        }

		#region Private Methods		
		/// <summary>
		/// Event handler for the page load.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{

			ResourceManager.RegisterLocaleResource("ConfirmMessage");
			if(!Page.IsPostBack)
			{
				ListItem liEmail = new ListItem(ResourceManager.GetString("EmailAddress"),"1");
				ListItem liUser = new ListItem(ResourceManager.GetString("cmnUserName"),"2");
				cboUniqueField.Items.Add(liEmail);
				cboUniqueField.Items.Add(liUser);
				this.SetControlState();

				// initializ show type
				ViewState["showType"] ="";
				this.btnCommitImport.Attributes.Add("onclick", "return ConfirmCommitImport();");
			}


		}
		
		private void repPreView_ItemDataBound(Object Sender, RepeaterItemEventArgs e) 
		{
            

			// This event is raised for the header, the footer, separators, and items.

			// Execute the following logic for Items and Alternating Items. 
			if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem) 
			{
				string t = "";

				t = (string)ViewState["showType"];

				if (t=="")
				{
					this.plhPreview.Visible = false;
				}
				else
				{
					this.plhPreview.Visible = true;
				}

				if (((DataRowView)(e.Item.DataItem)).Row.ItemArray.GetValue(7).ToString() == "1") 
				{
					if (t == "Error")
					{
						((System.Web.UI.HtmlControls.HtmlTableRow)e.Item.FindControl("trUserRecord")).Visible = true;
					
						string[] arr=null;
						char[] delimiter ={Char.Parse(";")};
						string tmp ="";
						((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdReason")).BgColor = "lightpink";
						tmp =  ((DataRowView)(e.Item.DataItem)).Row.ItemArray.GetValue(12).ToString();
						//if(((DataRowView)(e.Item.DataItem)).Row.ItemArray.GetValue(11).ToString().LastIndexOf(";") > 1)
						if(tmp.Length>0)
						arr = tmp.Split(delimiter);
						
						if (arr != null)
						for(int i = 0; i < arr.Length; i++)
						{//highlight problematic data cell
							if(arr[i] != null && arr[i].ToString() != "")
							{
								if(Int32.Parse(arr[i]) == 1)
								{
									((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdUsername")).BgColor = "lightpink";
								}
								if(Int32.Parse(arr[i]) == 2)
								{
									((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdPassword")).BgColor = "lightpink";
								}
								if(Int32.Parse(arr[i]) == 3)
								{
									((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdFirstName")).BgColor = "lightpink";
								}
								if(Int32.Parse(arr[i]) == 4)
								{
									((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdLastName")).BgColor = "lightpink";
								}
								if(Int32.Parse(arr[i]) == 5)
								{
									((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdEmail")).BgColor = "lightpink";
								}
								if(Int32.Parse(arr[i]) == 6)
								{
									((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdUnitID")).BgColor = "lightpink";
								}
								if(Int32.Parse(arr[i]) == 7)
								{
									((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdArchive")).BgColor = "lightpink";
								}
								if(Int32.Parse(arr[i]) == 9)
								{
									((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdClassification")).BgColor = "lightpink";
								}
								if(Int32.Parse(arr[i]) == 10)
								{
									((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdExternalID")).BgColor = "lightpink";
								}
							}
						}
					}
					else
					{

						((System.Web.UI.HtmlControls.HtmlTableRow)e.Item.FindControl("trUserRecord")).Visible = false;
						((System.Web.UI.WebControls.PlaceHolder)e.Item.FindControl("plhErrMsg")).Visible = false;
					}

				}
				else if (((DataRowView)(e.Item.DataItem)).Row.ItemArray.GetValue(7).ToString() == "2")
				{
			
					if (t == "Update")
					{
						((System.Web.UI.HtmlControls.HtmlTableRow)e.Item.FindControl("trUserRecord")).Visible = true;

                        string[] arr = null;
                        char[] delimiter = { Char.Parse(";") };
                        string tmp = "";
                        
                        tmp = ((DataRowView)(e.Item.DataItem)).Row.ItemArray.GetValue(13).ToString();
                        
                        if (tmp.Length > 0)
                            arr = tmp.Split(delimiter);

                        if (arr != null)
                            for (int i = 0; i < arr.Length; i++)
                            {//highlight cells that have their data changed
                                if (arr[i] != null && arr[i].ToString() != "")
                                {
                                    if (Int32.Parse(arr[i]) == 1)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdUsername")).BgColor = "lightblue";
                                    }
                                    if (Int32.Parse(arr[i]) == 2)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdPassword")).BgColor = "lightblue";
                                    }
                                    if (Int32.Parse(arr[i]) == 3)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdFirstName")).BgColor = "lightblue";
                                    }
                                    if (Int32.Parse(arr[i]) == 4)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdLastName")).BgColor = "lightblue";
                                    }
                                    if (Int32.Parse(arr[i]) == 5)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdEmail")).BgColor = "lightblue";
                                    }
                                    if (Int32.Parse(arr[i]) == 6)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdExternalID")).BgColor = "lightblue";
                                    }
                                    if (Int32.Parse(arr[i]) == 7)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdUnitID")).BgColor = "lightblue";
                                    }
                                    if (Int32.Parse(arr[i]) == 8)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdArchive")).BgColor = "lightblue";
                                    }
                                    if (Int32.Parse(arr[i]) == 9)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdClassification")).BgColor = "lightblue";
                                    }
                                    if (Int32.Parse(arr[i]) == 10)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdNotifyUnitAdmin")).BgColor = "lightblue";
                                    }
                                    if (Int32.Parse(arr[i]) == 11)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdNotifyOrgAdmin")).BgColor = "lightblue";
                                    }
                                    if (Int32.Parse(arr[i]) == 12)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdManagerNotification")).BgColor = "lightblue";
                                    }
                                    if (Int32.Parse(arr[i]) == 13)
                                    {
                                        ((System.Web.UI.HtmlControls.HtmlTableCell)e.Item.FindControl("tdManagerToNotify")).BgColor = "lightblue";
                                    }
                                }
                            }

					}
					else
					{
						((System.Web.UI.HtmlControls.HtmlTableRow)e.Item.FindControl("trUserRecord")).Visible = false;

					}

					((System.Web.UI.WebControls.PlaceHolder)e.Item.FindControl("plhErrMsg")).Visible = false;
				}
				else if (((DataRowView)(e.Item.DataItem)).Row.ItemArray.GetValue(7).ToString() == "3")
				{

					if (t == "Add")
					{
						((System.Web.UI.HtmlControls.HtmlTableRow)e.Item.FindControl("trUserRecord")).Visible = true;
	
					}
					else
					{
						((System.Web.UI.HtmlControls.HtmlTableRow)e.Item.FindControl("trUserRecord")).Visible = false;
			
					}
				
					((System.Web.UI.WebControls.PlaceHolder)e.Item.FindControl("plhErrMsg")).Visible = false;
				}
				
			}
			
			
		} 

		protected void btnShowAddedUsers_Click(object sender, EventArgs e)
		{
			showUsers("Add");
		}

		protected void btnShowUpdatedUsers_Click(object sender, EventArgs e)
		{
			showUsers("Update");
		}

		protected void btnShowDetectedError_Click(object sender, EventArgs e)
		{
			showUsers("Error");
		}

		private void showUsers(string showType)
		{
			ViewState["showType"] = showType;

			this.ShowPagination((int)ViewState["currentPageIndex"]);
		}
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnUploadCSV_Click(object sender, EventArgs e)
        {
			lblMessage.Text = "";
			if(cboUniqueField.SelectedValue == "")
			{
				lblMessage.Text = ResourceManager.GetString("lblMessage.SelectUniqueField");
				lblMessage.CssClass = "WarningMessage";
			}
			else
			{
				if (fileUserCSV.PostedFile.FileName.Length == 0 )
				{
					this.lblMessage.Text = ResourceManager.GetString("lblMessage.NoCSV");//"An CSV file must be provided to upload.";
					this.lblMessage.CssClass = "WarningMessage";
				}
				else
				{    
					try
					{	
						LoadXMLFile("CSV");		
				
					}
					catch (Exception ex)
					{
						this.lblMessage.Text = ResourceManager.GetString("lblMessage.Invalid") + " " + Environment.NewLine + ex.Message;
						this.lblMessage.CssClass = "WarningMessage";
					}
				}
			}
        }

		private void setLabelText(int totUpdated, int totAdded, int totErrorFound)
		{
			this.litPreviewData.Text = ResourceManager.GetString("litPreviewData");
			if (totAdded > 0)
			{
				this.litUsersAdd.Text = String.Format(ResourceManager.GetString("litUsersAdded"),totAdded.ToString());
			}
			else
			{
				this.btnShowAddedUsers.Visible = false;
				this.litUsersAdd.Visible = false;
			}
			if(totUpdated > 0)
			{
				this.litUsersUpdate.Text = String.Format(ResourceManager.GetString("litUsersUpdated"),totUpdated.ToString());
			}
			else
			{
				this.btnShowUpdatedUsers.Visible = false;
				this.litUsersUpdate.Visible = false;

			}

			if(totErrorFound > 0)
			{
				this.litDetectedError.Text = String.Format(ResourceManager.GetString("litDetectedError"),totErrorFound.ToString());
			}
			else
			{
				this.litDetectedError.Visible = false;
				this.btnShowDetectedError.Visible = false;
			}
		}

        protected void btnPeriodicReport_Click(object sender, EventArgs e)
        {
            int periodicReportsCount = 0;
            string uniqueField = this.cboUniqueField.SelectedValue;
            if (uniqueField == "2") //username
                periodicReportsCount = SelectCountUsers();
            else if (uniqueField == "1") //email
                periodicReportsCount = SelectCountEmails();

            if (periodicReportsCount > 0)
                Response.Redirect("~/Reporting/PeriodicReportList.aspx?isoninactivate=true");
            else
            {
                // todo: localise
                this.lblMessage.Visible = true;
                this.lblMessage.Text = "No Periodic Reports found";
                this.lblMessage.CssClass = "FeedbackMessage";
            }

        }

        private int SelectCountUsers()
        {
            int OrgID = UserContext.UserData.OrgID;
            List<string> inactivatedUsernames = (List<string>)InactivatedUsernames;

            List<prcGetPeriodicReportListOnInactivateUserResult> InactiveSchedules = new List<prcGetPeriodicReportListOnInactivateUserResult>();

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            PeriodicReportListDataContext prl = new PeriodicReportListDataContext(connectionString);

            foreach (string username in inactivatedUsernames)
            {
                ISingleResult<prcGetPeriodicReportListOnInactivateUserResult> result = prl.prcGetPeriodicReportListOnInactivateUser(OrgID, username);
                var qry = from pr in result.AsQueryable<prcGetPeriodicReportListOnInactivateUserResult>() select pr;
                InactiveSchedules.AddRange(qry.ToList<prcGetPeriodicReportListOnInactivateUserResult>());
            }

            var query = InactiveSchedules.AsQueryable<prcGetPeriodicReportListOnInactivateUserResult>();

            return query.Count<prcGetPeriodicReportListOnInactivateUserResult>();
        }

        private int SelectCountEmails()
        {
            int OrgID = UserContext.UserData.OrgID;
            List<string> inactivatedEmails = (List<string>)InactivatedEmails;

            List<prcGetPeriodicReportListOnInactivateEmailResult> InactiveSchedules = new List<prcGetPeriodicReportListOnInactivateEmailResult>();

            string connectionString = ConfigurationSettings.AppSettings["ConnectionString"] + "password=" + HttpContext.Current.Application["password"] + ";";

            PeriodicReportListDataContext prl = new PeriodicReportListDataContext(connectionString);

            foreach (string email in inactivatedEmails)
            {
                ISingleResult<prcGetPeriodicReportListOnInactivateEmailResult> result = prl.prcGetPeriodicReportListOnInactivateEmail(OrgID, email);
                var qry = from pr in result.AsQueryable<prcGetPeriodicReportListOnInactivateEmailResult>() select pr;
                InactiveSchedules.AddRange(qry.ToList<prcGetPeriodicReportListOnInactivateEmailResult>());
            }

            var query = InactiveSchedules.AsQueryable<prcGetPeriodicReportListOnInactivateEmailResult>();

            return query.Count<prcGetPeriodicReportListOnInactivateEmailResult>();
        }


		protected void btnCommitImport_Click(object sender, EventArgs e)
		{

			try
			{	
				
				CommitUserImport();
				//this.lblMessage.Text = ResourceManager.GetString("lblMessage.InvalidXML") + " " + ex.Message;
				int u = 0;
				int a = 0;
				u = Int32.Parse(ViewState["TotalUpdated"].ToString());
				a = Int32.Parse(ViewState["TotalAdded"].ToString());

				if(u != 0)
				{
					//todo: localized  message
					this.lblMessage.Text = u.ToString() + " updated user(s) " ;
                    this.btnPeriodicReport.Visible = true;	
				}
				if(a != 0)
				{
					//todo: localized message
					this.lblMessage.Text = this.lblMessage.Text + a.ToString() + " added user(s)";
				}
				this.lblMessage.CssClass = "SuccessMessage";
				this.tblPagination.Visible = false;
				this.lblMessage.Visible = true;

			}
			catch (Exception ex)
			{
				this.lblMessage.Text = ResourceManager.GetString("lblMessage.InvalidXML") + " " + ex.Message;
				this.lblMessage.CssClass = "WarningMessage";
				this.lblMessage.Visible = true;
			}		
		}

		private void CommitUserImport()
		{
			// get user details DataTable from uploaded XML file
			// DataTable is prepared in LoadXMLFile() method
			DataTable dt = (DataTable)ViewState["UploadDetails"];
			int totalAdded = 0; // total count of added user
			int totalUpdated = 0;
			System.Data.SqlTypes.SqlString userName = "";
			System.Data.SqlTypes.SqlString password = "";
			System.Data.SqlTypes.SqlString firstName = "";
			System.Data.SqlTypes.SqlString lastName = "";
			System.Data.SqlTypes.SqlString email = "";
			System.Data.SqlTypes.SqlString externalID = "";
			System.Data.SqlTypes.SqlInt32 unitID = 0;
			System.Data.SqlTypes.SqlInt32 orgID = 0;
			System.Data.SqlTypes.SqlString classificationName = "";
			System.Data.SqlTypes.SqlString classificationOption = "";
            System.Data.SqlTypes.SqlString NotifyUnitAdmin = "";
            System.Data.SqlTypes.SqlString NotifyOrgAdmin = "";
            System.Data.SqlTypes.SqlString ManagerNotification = "";
            System.Data.SqlTypes.SqlString ManagerToNotify = "";
			System.Data.SqlTypes.SqlInt32 archive=-1 ;
			System.Data.SqlTypes.SqlBoolean isUpdate = false;
			System.Data.SqlTypes.SqlInt32 userID = 0;
			System.Data.SqlTypes.SqlInt32 uniqueField = 0;
			Bdw.Application.Salt.BusinessServices.User u = new Bdw.Application.Salt.BusinessServices.User();
			uniqueField = System.Data.SqlTypes.SqlInt32.Parse(this.cboUniqueField.SelectedValue);

            InactivatedUsernames = null;
            List<string> inactivatedUsernames = InactivatedUsernames;

            InactivatedEmails = null;
            List<string> inactivatedEmails = InactivatedEmails;

			foreach(DataRow dr in dt.Rows)
			{
                // set the variables
				if (dr["Status"].ToString() != "1")
				{
					userName = dr["Username"] == System.DBNull.Value?System.Data.SqlTypes.SqlString.Null:(string)dr["Username"];
					password = dr["Password"] == System.DBNull.Value?System.Data.SqlTypes.SqlString.Null:(string)dr["Password"];
					firstName = dr["Firstname"] == System.DBNull.Value?System.Data.SqlTypes.SqlString.Null:(string)dr["Firstname"];
					lastName = dr["Lastname"] == System.DBNull.Value?System.Data.SqlTypes.SqlString.Null:(string)dr["Lastname"];
					email = dr["Email"] == System.DBNull.Value?System.Data.SqlTypes.SqlString.Null:(string)dr["Email"];
					externalID = dr["ExternalID"] == System.DBNull.Value?System.Data.SqlTypes.SqlString.Null:(string)dr["ExternalID"];
					//System.Diagnostics.Debug.WriteLine("StrUnitID is null: " + dr["UnitID"] == null?"true":"false");
					unitID = (dr["UnitID"] == System.DBNull.Value)||(dr["UnitID"].ToString()=="")?System.Data.SqlTypes.SqlInt32.Null:(int)dr["UnitID"];
					orgID = System.Data.SqlTypes.SqlInt32.Parse(UserContext.UserData.OrgID.ToString());
					classificationName = dr["ClassificationName"] == System.DBNull.Value?System.Data.SqlTypes.SqlString.Null:(string)dr["ClassificationName"];
					classificationOption = dr["ClassificationOption"] == System.DBNull.Value?System.Data.SqlTypes.SqlString.Null:(string)dr["ClassificationOption"];

                    archive = (dr["Archive"] == System.DBNull.Value) || (dr["Archive"].ToString() == "") ? System.Data.SqlTypes.SqlInt32.Null : System.Data.SqlTypes.SqlInt32.Parse(dr["Archive"].ToString());
                    
                    NotifyUnitAdmin = dr["NotifyUnitAdmin"] == System.DBNull.Value?System.Data.SqlTypes.SqlString.Null : (string)dr["NotifyUnitAdmin"];
                    NotifyOrgAdmin = dr["NotifyOrgAdmin"] == System.DBNull.Value ? System.Data.SqlTypes.SqlString.Null : (string)dr["NotifyOrgAdmin"];
                    ManagerNotification = dr["ManagerNotification"] == System.DBNull.Value ? System.Data.SqlTypes.SqlString.Null : (string)dr["ManagerNotification"];
                    ManagerToNotify = dr["ManagerToNotify"] == System.DBNull.Value ? System.Data.SqlTypes.SqlString.Null : (string)dr["ManagerToNotify"];

					isUpdate = System.Data.SqlTypes.SqlBoolean.Parse("false");
					userID = System.Data.SqlTypes.SqlInt32.Parse(UserContext.UserID.ToString());

                    if (archive == 1)
                    {
                        if (uniqueField == 2)//username
                        {
                            string username = dr["Username"].ToString();
                            inactivatedUsernames.Add(username);
                        }
                        else if (uniqueField == 1)//email 
                        {
                            string useremail = dr["Email"].ToString();
                            inactivatedEmails.Add(useremail);
                        }
                    }
				}

                InactivatedUsernames = inactivatedUsernames;

                InactivatedEmails = inactivatedEmails;

                // update count
				if ((int)dr["Status"] == 2)
				{
					isUpdate = true;
					totalUpdated = totalUpdated + 1;					
				}

                // insert count
				if ((int)dr["Status"] == 3)
				{
                    isUpdate = false;
					totalAdded = totalAdded + 1;
				}

                // do the insert/update
                try
                {
                    u.ImportUser(userName, password, firstName, lastName, email, unitID, classificationName, classificationOption, externalID, archive, isUpdate, uniqueField, userID, orgID, NotifyUnitAdmin, NotifyOrgAdmin, ManagerNotification, ManagerToNotify);
                }
                catch (Exception ex)
                {
                    ex.ToString();
                }

			}
			// update total count for updating/adding users
			ViewState["TotalUpdated"] = totalUpdated;
			ViewState["TotalAdded"] = totalAdded;
		}

		private void LoadXMLFile(string inputFileType)
		{
			string strUserCsvFile = "";
			string strUserXmlFile="";
			DataSet dsUploadResults;
			int uniqueField = 1;
			int totUpdated = 0;
			int totAdded = 0;
			int totErrorFound = 0;

			if(cboUniqueField.SelectedValue != "")
			{
				uniqueField = Int32.Parse(cboUniqueField.SelectedValue); 
			}

			if (inputFileType == "CSV")
			{
			
				strUserCsvFile = this.SaveUserCsvFile();
				strUserXmlFile = strUserCsvFile.Remove (strUserCsvFile.Length-4,4);
				strUserXmlFile += ".XML";

				// convert csv to xml file
				using (CSVtoXMLConverter.User csvUserFile = new CSVtoXMLConverter.User(strUserCsvFile,strUserXmlFile))
				{
					csvUserFile.Generate();
				}
			}
			else
			{
				try
				{
					//get user provided XML file
					strUserXmlFile = this.SaveUserXmlFile();
				}
				catch(Exception ex)
				{
					ex.ToString();
				}
			}
			
                
			Bdw.Application.Salt.Utilities.ImportUsersPreview objImport = new Bdw.Application.Salt.Utilities.ImportUsersPreview(strUserXmlFile, Server.MapPath(m_strImportUsersXSD), m_strXMLNamespace, uniqueField);
				
			//1. Set the Hierachy for the Import User call.
			objImport.Hierachy = this.Hierachy;
				
			//2. Set the HierachyID
			objImport.ID = this.HierachyID;
				
			//3. Set the UserID
			objImport.UserID = UserContext.UserID;

			//4. Set the IsPreview
			//objImport.IsPreview = isPreview;

			//5. Set the UniuqeField
			objImport.UniqueField = uniqueField;
				
			//6. Import the Details and get the results.
			dsUploadResults = objImport.Load();

			foreach(DataRow dr in dsUploadResults.Tables[0].Rows)
			{
				for (int statusError = 4; statusError >= 1; statusError--)
				{
					string statusErrorString = "Status" + statusError.ToString();
					dr["Status"] = dr["Status"].ToString().Replace(statusErrorString, ResourceManager.GetString(statusErrorString));
				}
			}
			foreach(DataRow dr in dsUploadResults.Tables[1].Rows)
			{
				// Go through and perform check for valid emails in datarow
				string strEmail = dr["Email"].ToString();
				Regex objValidEmail = new Regex(@"([a-z]|[A-Z]|[0-9]|\.|-|_|\')+@([a-z]|[A-Z]|[0-9]|\.|-|_)+");
				// Email doesn't match regular expression so mark as 
				// an error with Reason Code 10 (Invalid email address)
                // logic change to include check that the email address is not blank
                if (!objValidEmail.IsMatch(strEmail) && !strEmail.Equals(""))
				{
					dr["Status"] = 1;
					if(dr["Reason"].ToString().Length == 0)
					{
						dr["Reason"] = "Reason10";
					}
					else
					{
						dr["Reason"] = dr["Reason"] + "; Reason10";
					}
					dr["ErrField"] = dr["ErrField"] + ";5";					
				}

                //unique field is user name
				if(uniqueField == 2)
				{
                     bool DupEmailExists = false;
                    if (dr["email"].ToString() != "")
                    {
                        DupEmailExists = this.CheckUniqueField(uniqueField, dr["email"].ToString(), dr["username"].ToString());
                    }
                    
                    // Check for duplicate emails within org
					if (DupEmailExists)
					{
						dr["Status"] = 1;
						if(dr["Reason"].ToString().Length == 0)
						{
							dr["Reason"] = "Reason5";
						}
						else
						{
							dr["Reason"] = dr["Reason"] + "; Reason5";
						}
						dr["ErrField"] = dr["ErrField"] + ";5";	
					}

                    if (dr["username"].ToString() == "")
                    {
                        dr["Status"] = 1;
                        dr["Reason"] = String.Format(ResourceManager.GetString("lblMessage.RequiredField"), "Username");
                        dr["ErrField"] = ";1";	
                    }
				}
                // email is the unique field
                else if (uniqueField == 1)
                {
                    if (dr["email"].ToString() == "")
                    {
                        dr["Status"] = 1;
                        dr["Reason"] = String.Format(ResourceManager.GetString("lblMessage.RequiredField"), "Email");
                        dr["ErrField"] = ";5";
                    }
                }
			}
			//count total updated user records
			//count total added user records
			//count total error detected records
			//validate each column in the record to locate all possible errors
			foreach(DataRow dr in dsUploadResults.Tables[1].Rows)
			{
				string errMsgs = "";
				string errField = "";

				for (int reasonError = 11; reasonError >= 0; reasonError--)
				{
						dr.BeginEdit();					
					//get actual error messages
					string reasonErrorString = "Reason" + reasonError.ToString();
					dr["Reason"] = dr["Reason"].ToString().Replace(reasonErrorString, ResourceManager.GetString(reasonErrorString));
					dr.EndEdit();
				}
				if(dr["Status"].ToString() == "1")
				{// Status = 1: Error found in user data record
					string[] strArr;
					totErrorFound = totErrorFound + 1;
					strArr = CheckUser(dr,false);
					if (strArr[0].Length > 0)
					{
						dr.BeginEdit();
						dr["ErrField"] = dr["ErrField"].ToString() + strArr[1];
						dr["Reason"] = dr["Reason"].ToString() + strArr[0];
						dr.EndEdit();
					}
				}

				if(dr["Status"].ToString() == "2")
				{// Status = 2: Update user data record
					string[] strArr;
					totUpdated = totUpdated + 1;
					strArr = CheckUser(dr,true);

					if(strArr[0].Length > 0 || strArr[1].Length > 0)
					{
						totUpdated = totUpdated - 1;
						totErrorFound = totErrorFound + 1;
						dr.BeginEdit();
						dr["Status"] = 1;
						dr["Reason"] = dr["Reason"].ToString() + strArr[0];
						//todo: update dr["ErrField"]
						dr["ErrField"] = dr["ErrField"].ToString()+strArr[1];
						dr.EndEdit();
					}
				}

				if(dr["Status"].ToString() == "3")
				{// Status = 3: Add user data record
					string [] strArr;
					totAdded = totAdded + 1;

					strArr = CheckUser(dr,false);
					errMsgs = strArr[0];
					errField = strArr[1];
			
					//Error found.Update user data record 
					if(errMsgs.Length > 0 || errField.Length > 0)
					{
						totAdded = totAdded - 1;
						totErrorFound = totErrorFound + 1;

						dr.BeginEdit();
						dr["Status"] = 1;
						dr["Reason"] = dr["Reason"].ToString() + strArr[0];
						//todo: update dr["ErrField"]
						dr["ErrField"] = dr["ErrField"].ToString()+strArr[1];
						dr.EndEdit();
					}
				}
			}
			//5. Show Result totals
			//Set the DataGrid Source and Bind the Data for the result totals.
			this.repPreView.DataSource = dsUploadResults.Tables[1];
			this.repPreView.DataBind();
			//Make the DataGrid visible.
				
			//6. Show Upload Details
			//Save the Details DataView in the ViewState
			ViewState["UploadDetails"] = dsUploadResults.Tables[1];
			
			ViewState["TotalUpdated"] = totUpdated;
			ViewState["TotalAdded"] = totAdded;
			ViewState["TotalErrorFound"] = totErrorFound;
			ViewState["UserXMLFileName"] = strUserXmlFile;

			//-- LICENSING
				BusinessServices.CourseLicensing.LicenseAuditByOrg(UserContext.UserData.OrgID);
				this.tblPagination.Visible = false;
				//todo: show commit sucess message
			this.StartPagination();
		}

		private bool CheckUniqueField(int UniqueField, string Value, string UserName)
		{
			BusinessServices.User objUser = new BusinessServices.User();
			bool UniqueFieldOK = objUser.ImportCheck(UniqueField, Value, UserContext.UserData.OrgID, UserName);
			return UniqueFieldOK;
		}

		protected void btnCancel_Click(object sender, EventArgs e)
		{
			Response.Redirect("~/Administration/Organisation/ImportUsers.aspx");
		}
		/// <summary>
		/// Event handler for the import users button.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void btnUploadXML_Click(object sender, EventArgs e)
		{
			lblMessage.Text = "";
			if(cboUniqueField.SelectedValue == "")
			{
				lblMessage.Text = ResourceManager.GetString("lblMessage.SelectUniqueField");
				lblMessage.CssClass = "WarningMessage";
			}
			else
			{
				if (fileUserXML.PostedFile.FileName.Length == 0 )
				{
					this.lblMessage.Text = ResourceManager.GetString("lblMessage.NoXML");//"An XML file must be provided to upload.";
					this.lblMessage.CssClass = "WarningMessage";
				}
				else
				{
					try
					{	
						LoadXMLFile("XML");					
					}
					catch (Exception ex)
					{
						this.lblMessage.Text = ResourceManager.GetString("lblMessage.InvalidXML") + " " + ex.Message;
						this.lblMessage.CssClass = "WarningMessage";
					}
				}
			}
		}

		private string[] CheckUser(DataRow dr, bool isUpdate)
		{
			string errMsg = "";
			string errField = "";
			string[] strArray = {"",""};
	
			//Checking all required fields for a user data reocrd
			if(!isUpdate)
			{
                if (dr["Username"].ToString().Length == 0 && dr["Status"].ToString() == "3")
				{
					errField = ";1";
					//todo: localized error message
					errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.RequiredField"), "Username");
					
				}
			}
			if (dr["Username"].ToString().Length >0 && dr["Username"].ToString().Length < 3)
			{
				//todo: localized error message

				errField = ";1";
				errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.MinimumLength"),";Username", "3");
				
				
			}
			if (dr["Username"].ToString().Length > 100)
			{
					errField = ";1";
				//todo: localized error message
				errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.ExceedsLengthLimit"), ";Username", "100");
			}
			
			if(!isUpdate)
			{
				if(dr["Password"].ToString().Length == 0)
				{
					errField = errField + ";2";
					//todo: localized error message
					errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.RequiredField"), ";Password");
                }
			}
            if (dr["Password"].ToString().Length < 8 && dr["Password"].ToString().Length > 0)
			{
				if (errField.LastIndexOf("2") == 0)
				{
					errField = errField + ";2";
				}
				else
				{
					errField ="2";
				}
				//todo: localized error message
				errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.MinimumLength"),";Password", "8");
				
			}

			if(!isUpdate)
			{
				if(dr["Firstname"].ToString().Length == 0)
				{
					//todo: localized error message
					errField = errField + ";3";
					errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.RequiredField"), ";Firstname");
					
				}
			}
			if (dr["Firstname"].ToString().Length > 50)
			{
				//todo: localized error message

				
				if(errField.LastIndexOf("3")== 0)
				{
					errField = errField + ";3";
				}
				errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.ExceedsLengthLimit"), ";FirstName", "50");

			}

			if(!isUpdate)
			{
				if(dr["Lastname"].ToString().Length == 0)
				{
					//todo: localized error message
					
					errField = errField + ";4";
					errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.RequiredField"), ";Lastname");
				}
			}
			if(dr["Lastname"].ToString().Length >50)
			{
				//todo: localized error message
				
				if(errField.LastIndexOf("4") == 0)
				{
					errField = errField + ";4";
				}
				errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.ExceedsLengthLimit"), ";LastName", "50");
				
				
			}

			if(!isUpdate)
			{
                if (dr["Email"].ToString().Length == 0 && dr["Status"].ToString() != "1")
				{
					errField = errField + ";5";
					//todo: localized error message
					errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.RequiredField"), ";Email");
					
				}
			}
			if(dr["Email"].ToString().Length > 100)
			{
				//todo: localized error message

				if(errField.LastIndexOf("5") == 0)
				{
					errField = errField + ";5";		
				}
				errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.ExceedsLengthLimit"), ";Email", "100");
				
				
										
			}

			/*if(isUpdate)
			{
				if(dr["UnitID"].ToString().Length == 0)
				{
					//todo: localized error message
					errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.RequiredField"), ";UnitID");
					
					errField = errField + ";6";		
					
				}
			}*/

			if(dr["Archive"].ToString().Length == 0 && !isUpdate)
			{
				//todo: localized error message
				errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.RequiredField"), ";Archive");
					
				errField = errField + ";7";		
					
			}

			if(dr["ExternalID"].ToString().Length > 50)
			{
				//todo: localized error message
				errMsg = errMsg + String.Format(ResourceManager.GetString("lblMessage.ExceedsLengthLimit"), ";ExternalID", "50");
				
				errField = errField + ";10";
			}

			if(errMsg.StartsWith(";"))
			{
				errMsg = errMsg.Substring(1);
			}

            errField = errField + dr["ErrField"].ToString();

			if(errField.StartsWith(";"))
			{
				errField = errField.Substring(1);
			}
			strArray[0] = errMsg;
			strArray[1] = errField;

			return strArray;

		}


        /// <summary>
        /// Saves the uploaded csv file to the uploaded file folder.
        /// </summary>
        private string SaveUserCsvFile()
        {
            string strFileName;

            strFileName = 	Server.MapPath(m_strUploadedFilePath) + "user" + this.Hierachy + this.HierachyID.ToString() + ".csv"; 
            this.fileUserCSV.PostedFile.SaveAs(strFileName);
            return strFileName;
        } 

		/// <summary>
		/// Saves the uploaded xml file to the uploaded file folder.
		/// </summary>
		private string SaveUserXmlFile()
		{
			string strFileName;

			strFileName = 	Server.MapPath(m_strUploadedFilePath) + "user" + this.Hierachy + this.HierachyID.ToString() + ".xml"; 
			this.fileUserXML.PostedFile.SaveAs(strFileName);
			return strFileName;
		} 
		
		/// <summary>
		/// 
		/// </summary>
		private void SetControlState()
		{
			//1. Hide the results total datagrid
			//this.dtgUploadResultTotals.Visible = false;
			
			//2. Hide the result details datagrid.
			this.tblPagination.Visible = false;
            this.btnPeriodicReport.Visible = false;

            if (this.Hierachy == "Organisation")
            {
                this.lblUnitNameLabel.Visible = false;
                this.lblUnitName.Visible = false;
            }
            else //UnitAdmin
            {
                // 3.Get the unit name to display
                BusinessServices.Unit objUnit = new BusinessServices.Unit();
                DataTable dtbUnit = objUnit.GetUnit(Int32.Parse(Request.QueryString["UnitID"]));

                this.lblUnitNameLabel.Text = ResourceManager.GetString("cmnUnitName");//"Unit Name";
                this.lblUnitName.Text = dtbUnit.Rows[0]["Pathway"].ToString();
            }
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
			this.repPreView.ItemDataBound += new System.Web.UI.WebControls.RepeaterItemEventHandler(this.repPreView_ItemDataBound); 

			//grdPagination.Columns[0].HeaderText = ResourceManager.GetString("grid_Record");
			//grdPagination.Columns[1].HeaderText = ResourceManager.GetString("cmnFirstName");
			//grdPagination.Columns[2].HeaderText = ResourceManager.GetString("cmnLastName");
			//grdPagination.Columns[3].HeaderText = ResourceManager.GetString("cmnUserName");
			//grdPagination.Columns[4].HeaderText = ResourceManager.GetString("cmnEmail" );
			//grdPagination.Columns[5].HeaderText = ResourceManager.GetString("grid_UnitID");
			//grdPagination.Columns[6].HeaderText = ResourceManager.GetString("grid_Reason");
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
		}
		#endregion
		
		#region Pagination customization(Change this section according to business logic)
		/// <summary>
		/// Start Pagination
		/// </summary>
		private void StartPagination()
		{
			//Initialize Pagination settings
			//ViewState["OrderByField"] = "RecordNumber";
			//ViewState["OrderByDirection"] = "DESC";
			//this.SetPaginationOrder("RecordNumber"); //customization

			this.tblPagination.Visible = true;
			
			this.ShowPagination(0);
		}
		
		/// <summary>
		/// Get Pagination Data
		/// </summary>
		/// <returns></returns>
		private DataView GetPaginationData()
		{
			//Customize, and return DataView
			return ((DataTable)ViewState["UploadDetails"]).DefaultView;
		}
		#endregion

		#region Pagination event handler(Don't make any changes to this section)
		/// <summary>
		/// Go to previous page
		/// </summary>
		protected void btnPrev_Click(object sender, System.EventArgs e)
		{
			int p = 0;
			p = (int) ViewState["currentPageIndex"];
			this.ShowPagination(p - 1);
		}
		/// <summary>
		/// Go to next page	
		/// </summary>
		protected void btnNext_Click(object sender, System.EventArgs e)
		{
			int p = 0;
			p = (int) ViewState["currentPageIndex"];
			this.ShowPagination(p + 1);
		}

		/// <summary>
		/// Go to a specific page
		/// </summary>
		protected void cboPage_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			int intPageIndex;
			intPageIndex = int.Parse(this.cboPage.SelectedValue);
			this.ShowPagination(intPageIndex - 1);
		}

		/// <summary>
		///Sort data
		/// </summary>
		private void grdPagination_SortCommand(object source, System.Web.UI.WebControls.DataGridSortCommandEventArgs e)
		{
			this.SetPaginationOrder(e.SortExpression);
			this.ShowPagination(0);
		}

		/// <summary>
		/// Set order field
		/// </summary>
		/// <param name="orderByField"></param>
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
		/// <summary>
		/// Show Paging Data
		/// </summary>
		/// <param name="currentPageIndex"></param>
		private void ShowPagination(int currentPageIndex)
		{
			//1. Get data
			DataView dvwPagination = this.GetPaginationData();
				
			setLabelText((int)ViewState["TotalUpdated"],(int)ViewState["TotalAdded"],(int)ViewState["TotalErrorFound"]);
			
			if(dvwPagination.Count <= ApplicationSettings.PageSize)
			{
				this.trPagination.Visible = false;
			} 
			else 
			{
				this.trPagination.Visible = true;
			}
			
			if(dvwPagination.Count == 0)
			{
				this.tblPagination.Visible = false;
			}
			

			//2. Sort Data
			//string strOrderByField, strOrderByDirection;
			//strOrderByField = (string)ViewState["OrderByField"];
			//strOrderByDirection = (string)ViewState["OrderByDirection"];

			//dvwPagination.Sort = strOrderByField + " " + strOrderByDirection;
			
			//3. Set pagination panel
			int intPageSize;
			intPageSize = ApplicationSettings.PageSize ;
			this.SetPaginationPanel(intPageSize, dvwPagination.Count, currentPageIndex);


			//4. Bind Data
			this.repPreView.DataSource  = dvwPagination;
			this.repPreView.DataBind();

			this.plhSearchCriteria.Visible=false;
			this.plhResults.Visible=true;
		}


		/// <summary>
		///Set pagination panel 
		/// </summary>
		/// <param name="pageSize"></param>
		/// <param name="totalRecordCount"></param>
		/// <param name="currentPageIndex"></param>
		private void SetPaginationPanel(int pageSize, int totalRecordCount, int currentPageIndex)
		{
			//1. Get pagination info
			int intPageSize,intTotalRecordCount,intPageCount,intCurrentPageStart, intCurrentPageEnd;
			ListItem objItem;

			intPageSize = pageSize;
			intTotalRecordCount = totalRecordCount;
			intPageCount = ((int)(intTotalRecordCount - 1) / intPageSize) + 1;
			//Page start record number
			if (intTotalRecordCount!=0)
			{
				intCurrentPageStart = intPageSize * currentPageIndex + 1;
			}
			else
			{
				intCurrentPageStart = 0;
			}
			//Page end record number
			if (currentPageIndex < intPageCount - 1)
			{
				intCurrentPageEnd =  intPageSize * (currentPageIndex + 1);
			}
				//Last page, the page record count is the remaining records
			else
			{
				intCurrentPageEnd = intTotalRecordCount;
			}		
			//2. Set  pagination
			//2.1 Set dropdown page selector
			this.cboPage.Items.Clear();
			for(int i = 1; i <=  intPageCount; i++)
			{
				objItem = new ListItem(i.ToString());
				if (i == currentPageIndex + 1)
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
			if (currentPageIndex == 0)
			{	
				this.btnPrev.Enabled = false;
			}
			//Last Page
			if (currentPageIndex == intPageCount - 1)
			{	
				this.btnNext.Enabled = false;
			}
			//update page index for showing specific user data record
			//used in showUsers() method
			ViewState["currentPageIndex"] = currentPageIndex;
		}
		#endregion

	}
}
