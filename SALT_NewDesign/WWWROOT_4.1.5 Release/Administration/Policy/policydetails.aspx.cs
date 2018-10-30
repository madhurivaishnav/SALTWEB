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
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.BusinessServices;

using System.IO;
using Microsoft.ApplicationBlocks.Data;
using System.Configuration;

using Localization;

namespace Bdw.Application.Salt.Web.Administration.Policy
{
	/// <summary>
	/// Summary description for policydetails.
	/// </summary>
	public partial class policydetails : System.Web.UI.Page
	{


		bool CheckCanUpload = true;
		private bool UploadSuccess = false;
		private static bool blnViewUsers = false;
		private static string DisplayType = String.Empty;
		private static bool InitialiseSession = false;


		protected void Page_Load(object sender, System.EventArgs e)
		{
			BusinessServices.Organisation objOrganisation = new BusinessServices.Organisation();
			if (objOrganisation.GetOrganisationPolicyAccess(UserContext.UserData.OrgID))
			{
				//Response.AddHeader("Refresh", Convert.ToString((Session.Timeout*60)-10));
				
				//To get treeview to work correctly when not rendered until link clicked on
				Page.RegisterHiddenField("StaticPostBackScrollVerticalPosition", "0");
				Page.RegisterHiddenField("StaticPostBackScrollHorizontalPosition", "0");

				string Success="";
				ResourceManager.RegisterLocaleResource("ConfirmUpload");
				pagTitle.InnerText = ResourceManager.GetString("pagTitle");
				ddlStatus.Items[0].Text = ResourceManager.GetString("cmnActive" );
				ddlStatus.Items[1].Text = ResourceManager.GetString("cmnInactive");
				int PolicyID;
				try
				{
					PolicyID = Int32.Parse(Session["PolicyID"].ToString());
				}
				catch
				{
					PolicyID = -1;
				}
				if(PolicyID > 0)
				{
					panTabs.Visible = true;
				}
				else
				{
					panTabs.Visible = false;
				}
				if (!Page.IsPostBack)
				{
					InitialiseSession = true;
					Session["PageIndex"] = 0;
					LoadPolicy(PolicyID);
					//Show Parent Units tree
					BusinessServices.Unit objUnit= new  BusinessServices.Unit();
					DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'A',false);
					if (dstUnits.Tables[0].Rows.Count!=0)
					{
						string strUnits = UnitTreeConvert.ConvertXml(dstUnits);

						this.trvUnitsSelector.LoadXml(strUnits);
						this.trvUserUnitsSelector.LoadXml(strUnits);

					}
					// Initially hide all assignment panels until user clicks on them

					this.panAssignUnits.Visible = false;
					this.panUnitSelect.Visible = false;
					this.panAssign.Visible = false;
					this.panUserUnitSelect.Visible = false;
					this.panAssignUsers.Visible = false;
					this.panUserDetails.Visible = false;
					this.panSearchReset.Visible = false;
					this.panUserSearchResults.Visible = false;
					this.panViewUsers.Visible = false;
					this.panUserList.Visible = false;
					this.panUnitSaveAll.Visible = false;
					this.panUserSaveAll.Visible = false;
					this.panUserSearchMessage.Visible = false;

					SetSortOrder("LastName");
				}
				if(Request.QueryString["Success"] != null)
				{
					Success = Request.QueryString["Success"].ToString();
					if (Success == "true")
					{
						this.lblPolicyName.Text = ResourceManager.GetString("PolicySaved");
						this.lblPolicyName.CssClass = "SuccessMessage";
					}
				}
			}
			else
			{
				pagTitle.InnerText = ResourceManager.GetString("pagTitle");
				panPolicy.Visible =false;
				lblMessage.Text = ResourceManager.GetString("NoAccess");
				lblMessage.CssClass = "WarningMessage";
			}
		}
		
		private void SetSortOrder(string orderByField)
		{
			string	strOldOrderByField, strOldOrderByDirection;
			string  strOrderByDirection;

			// Get from viewstate
			strOldOrderByField =(string)ViewState["OrderByField"];
			strOldOrderByDirection =(string)ViewState["OrderByDirection"];

			// Compare to desired sort field
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

		private void LoadPolicy(int PolicyID)
		{
			int OrganisationID = UserContext.UserData.OrgID;
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
            DataTable dtPolicy = objPolicy.GetPolicy(PolicyID, OrganisationID);


			if(dtPolicy.Rows.Count != 0) //Policy exists
			{
				this.lnkResetUsers.Visible = true;

				this.txtName.Text = dtPolicy.Rows[0]["PolicyName"].ToString();
				bool blnActive = bool.Parse(dtPolicy.Rows[0]["Active"].ToString());		
				this.ddlStatus.ClearSelection();
				this.ddlStatus.Items.FindByValue(Convert.ToInt32(blnActive).ToString()).Selected = true;
				string strPolicyFile = dtPolicy.Rows[0]["PolicyFileName"].ToString();
				string strPolicyPath = @"\General\Policy\" + OrganisationID.ToString();
				this.hypFile.NavigateUrl = strPolicyPath + @"\" + strPolicyFile;
				this.hypFile.Target = "_blank";
				this.hypFile.Text = strPolicyFile;
				string ConfirmationMessage = dtPolicy.Rows[0]["ConfirmationMessage"].ToString();
				if(ConfirmationMessage.Equals(String.Empty))
				{
					this.txtConfirmationMsg.Text = ResourceManager.GetString("DefaultConfirmationMsg");
				}
				else
				{
					this.txtConfirmationMsg.Text = ConfirmationMessage;
				}
				//populate user acceptance
				int UsersAcceptedPolicy = objPolicy.GetAcceptedUsers(OrganisationID, PolicyID);
				int UsersTotal = objPolicy.GetTotalUsersAssignedToPolicy(PolicyID);
				this.lblUsersAccepted.Text = UsersAcceptedPolicy.ToString() + @" / " + UsersTotal.ToString();
			}
			else // Policy does not exist -  Upload new file and Reset Users should not be displayed until policy created
			{
				this.lnkResetUsers.Visible = false;
				this.txtConfirmationMsg.Text = ResourceManager.GetString("DefaultConfirmationMsg");
			}
		}

		private void ClearMessages()	
		{
			lblUploadFile.Text = "";
			lblPolicyName.Text = "";
		}

		private bool UploadPolicyFile(bool checkFile)
		{
			bool UploadStatus = false;			

			// Create Policy object
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();

			//Check value in the upload file input
			if ((UploadFile.PostedFile != null) && (UploadFile.PostedFile.ContentLength > 0))
			{
				//Get filename of file to be uploaded
				string FileName = GetFileName();
				int CheckRowCount = 0;
				
				//code to check the database for a filename that has been previously used
				//If it exists then display message indicating that filenames need to be unique and do not allow upload of file
				int OrganisationID = UserContext.UserData.OrgID;
				
				if(checkFile)
				{
					DataTable dt = objPolicy.CheckFileName(OrganisationID, FileName);
					CheckRowCount = dt.Rows.Count;
				}
				
				if (CheckRowCount != 0 && checkFile)
				{
					// File with this name already exists for this organisation
					lblUploadFile.Text = ResourceManager.GetString("FileExists");
					lblUploadFile.CssClass = "WarningMessage";
					CheckCanUpload = false;
				}
				else
				{
					//Get fileinfo of file to be uploaded - length() returns file size in bytes
					long FileLength = GetFileSize();

					//Obtain the size limit the organisation has
					long lngOrgSizeLimit = objPolicy.GetAllocatedDiskSpace(OrganisationID);
					if (lngOrgSizeLimit == 0)
					{					
						// No value returned - Organisation has not had size allocated in organisation details - message to user
						lblUploadFile.Text = ResourceManager.GetString("OrgNoSpaceAllocated");
						lblUploadFile.CssClass = "WarningMessage";
					}
					else
					{

						//Determine the size of files already on server - note that at this stage this includes the file you are currently uploading
						long lngOrgUsedLimit = objPolicy.GetUsedPolicyDiskSpace(OrganisationID);
				
						//check that size of files already on server + new file size does not exceed the size limit for organisation.
						//If it does then do not upload the file and get them to contact SALT administrator 
						CheckCanUpload = objPolicy.CheckCanUpload(lngOrgSizeLimit, lngOrgUsedLimit);
						if (CheckCanUpload)
						{

							//Location for file to be saved on server
							string SaveDir = Server.MapPath(@"\General") + @"\Policy\" + UserContext.UserData.OrgID.ToString();
							//Check that the directory exists - if it doesn't then create it
							if (!Directory.Exists(SaveDir))
							{
								Directory.CreateDirectory(SaveDir);
							}
							string SaveLocation = SaveDir + @"\" + FileName;
				
							try
							{
								UploadFile.PostedFile.SaveAs(SaveLocation);
								lblUploadFile.Text = ResourceManager.GetString("UploadSuccess");
								lblUploadFile.CssClass = "SuccessMessage";
								UploadStatus = true;								
							}
							catch (Exception ex)
							{
								//log exception to event log
                                ErrorHandler.ErrorLog el = new ErrorHandler.ErrorLog(ex, ErrorLevel.High, "PolicyDetails.aspx.cs", "UploadPolicyFile", ex.Message);
				
								//display friendly message to user
								lblUploadFile.Text = ResourceManager.GetString("UploadFail");
								lblUploadFile.CssClass = "WarningMessage";					
							}
						}
						else
						{
							// Organisation allocated size will be exceeded - message to tell user this
							lblUploadFile.Text = ResourceManager.GetString("ExceedOrgSizeAllocation");
							lblUploadFile.CssClass = "WarningMessage";		
						}
						
					}
				}
			}
			else
			{
				lblUploadFile.Text = ResourceManager.GetString("NoUploadFile");
				lblUploadFile.CssClass = "WarningMessage";
			}
			return UploadStatus;
		}

		private int SavePolicy() //change to int
		{
			int PolicyID;
			int NewPolicyID;
			try
			{
				PolicyID = Int32.Parse(Session["PolicyID"].ToString());
				NewPolicyID = Int32.Parse(Session["PolicyID"].ToString());
			}
			catch
			{
				PolicyID = -1;
				NewPolicyID = -1;
			}
			
			//Get values
			int OrganisationID = UserContext.UserData.OrgID;
			string PolicyName = this.txtName.Text;
			string ConfirmationMessage = this.txtConfirmationMsg.Text;
			bool Active = (this.ddlStatus.SelectedIndex==0);
			bool Deleted = false;
			string FileName = this.UploadFile.PostedFile.FileName;


			// Create Policy object
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();

			if(PolicyID > 0)
			{
				//Existing Policy - updating
				objPolicy.UpdatePolicy(PolicyID, OrganisationID, PolicyName, Active, ConfirmationMessage);

				//Check to see if new file needs to be uploaded
				if(FileName.Length > 0)
				{
					NewPolicyID = Upload(PolicyID, true);									
				}
				if (this.chkAssignAllUsers.Checked)
				{
					objPolicy.InitialisePolicyAccess(OrganisationID, NewPolicyID, this.chkAssignAllUsers.Checked);
				}
				Session["PolicyID"] = NewPolicyID;
				return NewPolicyID;
			}
			else
			{
				if(FileName.Length > 0)
				{
					string PolicyFileName = Path.GetFileName(FileName);
					DataTable dt = objPolicy.CheckFileName(OrganisationID, PolicyFileName);
					int CheckRowCount = dt.Rows.Count;
					if (CheckRowCount == 0)
					{
						//Check if the file is less than 2 mb
						long PolicyFileSize = GetFileSize(); 
						//New Policy - adding
						PolicyID =  objPolicy.AddPolicy(OrganisationID, PolicyName, Active, Deleted, PolicyFileName, PolicyFileSize, ConfirmationMessage);
						NewPolicyID = Upload(PolicyID, false);
						objPolicy.InitialisePolicyAccess(OrganisationID, NewPolicyID, this.chkAssignAllUsers.Checked);
						Session["PolicyID"] = NewPolicyID;
						return NewPolicyID;

					}
					else
					{
						lblUploadFile.Text = ResourceManager.GetString("FileExists");
						lblUploadFile.CssClass = "WarningMessage";
						return -1;
					}


				}
				else
				{
					//File has not been specified for a new policy - prompt user to set file to upload
					lblUploadFile.Text = ResourceManager.GetString("NoUploadFile");
					lblUploadFile.CssClass = "WarningMessage";
					return -1;
				}
			}			
	}

		private void lnkUpload_Click(object sender, System.EventArgs e)
		{
			//Initialise upload message text
			ClearMessages();
			int PolicyID;
			try
			{
				PolicyID = Int32.Parse(Session["PolicyID"].ToString());
			}
			catch
			{
				PolicyID = -1;
			}
			int NewPolicyID = Upload(PolicyID, true);
			Session["PolicyID"] = NewPolicyID;
			//Reload the policy
			LoadPolicy(NewPolicyID);
		}

		private int Upload(int PolicyID, bool checkFile)
		{
			string OrganisationID = UserContext.UserData.OrgID.ToString();
			// Create Policy object
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
			//Get name of existing file
            string CurrentFile = objPolicy.GetPolicyFileName(PolicyID, UserContext.UserData.OrgID);
			//Location of file to be saved on server
			string DelPath = Server.MapPath(@"\General") + @"\Policy\" + OrganisationID;
			
			//Upload the file
			UploadSuccess = UploadPolicyFile(checkFile);
            if (UploadSuccess)
            {
                //Delete the old policy off the server
                if (File.Exists(DelPath + @"\" + CurrentFile) && checkFile)
                {
                    File.Delete(DelPath + @"\" + CurrentFile);
                }
                //Update the database (mark existing as deleted, new policy with existing Name, status etc.)
                //filename of new file to be uploaded
                string FileName = GetFileName();
                long FileLength = GetFileSize();
                PolicyID = objPolicy.NewFileUpload(PolicyID, FileName, FileLength, UserContext.UserData.OrgID);
                Session["PolicyID"] = PolicyID;
            }
            else
            {
                objPolicy.DeletePolicy(PolicyID, OrganisationID);

            }
			return PolicyID;
		}

		private string GetFileName()
		{
			string FileName = Path.GetFileName(UploadFile.PostedFile.FileName);
			return FileName;
		}

		private long GetFileSize()
		{			
			long lngFileLength = UploadFile.PostedFile.ContentLength; 
			return lngFileLength;
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
			grdResults.Columns[0].HeaderText = ResourceManager.GetString("unit_pathway");
			grdResults.Columns[1].HeaderText = ResourceManager.GetString("last_name");
			grdResults.Columns[2].HeaderText = ResourceManager.GetString("first_name");
			grdResults.Columns[3].HeaderText = ResourceManager.GetString("assign");
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.grdResults.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.grdResults_PageIndexChanged);
			this.grdResults.SortCommand += new System.Web.UI.WebControls.DataGridSortCommandEventHandler(this.grdResults_SortCommand);
		}
		#endregion

		private void grdResults_SortCommand(object source, System.Web.UI.WebControls.DataGridSortCommandEventArgs e)
		{
			SetSortOrder(e.SortExpression);			
			ShowData(0);
		}

		private void grdResults_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
		{
			GetCheckBoxValues();
			ShowData(e.NewPageIndex
				);
			Session["PageIndex"] = e.NewPageIndex;
			RePopulateCheckBoxes();
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

		protected void btnReset_Click(object sender, System.EventArgs e)
		{
			this.trvUserUnitsSelector.ClearSelection();
			this.txtFirstName.Text = String.Empty;
			this.txtLastName.Text = String.Empty;
			this.txtUserName.Text = String.Empty;
			this.txtEmail.Text = String.Empty;
			this.txtExternalId.Text = String.Empty;
			this.lblUserAssignMessage.Text= String.Empty;
			this.panUserSearchResults.Visible = false;
			this.panUserSaveAll.Visible = false;
		}

		protected void btnUserSaveAll_Click(object sender, System.EventArgs e)
		{
			int PolicyID;
			try
			{
				PolicyID = int.Parse(Session["PolicyID"].ToString());
			}
			catch
			{
				PolicyID = -1;
			}
			
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
			// Update each user in the datagrid
			GetCheckBoxValues();
			RePopulateCheckBoxes();
			DataView dvwPagination;
			dvwPagination	= GetData();

			ArrayList CheckedItems = new ArrayList();

			foreach(DataRow dr in dvwPagination.Table.Rows)
			{
				int AssignUserAccess = 0;
				int UserID = int.Parse(dr["UserID"].ToString());
				CheckedItems = (ArrayList)Session["CheckedItems"];
				if(CheckedItems.Contains(UserID.ToString()))
				{
					AssignUserAccess = 1;
				}
				int Granted = Convert.ToInt32(Convert.ToBoolean(dr["Granted"].ToString()));
				objPolicy.SetPolicyUserAccessByUser(PolicyID, UserID, AssignUserAccess);				
			}
			
			this.lblUserAssignMessage.Visible = true;
			this.lblUserAssignMessage.Text = ResourceManager.GetString("lblMessage.SaveUsers");
			this.lblUserAssignMessage.CssClass = "SuccessMessage";

			ShowData(int.Parse(Session["PageIndex"].ToString()));
		}

		private void GetCheckBoxValues()
		{
			ArrayList CheckedItems = new ArrayList();
			// Loop through DataGrid Items
			foreach(DataGridItem dgItem in grdResults.Items)
			{
				int ChkBxIndex = int.Parse(dgItem.Cells[4].Text);
				CheckBox chkAssign = (CheckBox)dgItem.FindControl("chkAssign");
				//Add ArrayList to Session if it doesn't exist
				if(Session["CheckedItems"] != null)
				{
					CheckedItems = (ArrayList)Session["CheckedItems"];
				}
				if(chkAssign.Checked)
				{
					if(!CheckedItems.Contains(ChkBxIndex.ToString()))
					{
						CheckedItems.Add(ChkBxIndex.ToString());
					}
				}
				else
				{
					CheckedItems.Remove(ChkBxIndex.ToString());
				}
			}
			Session["CheckedItems"] = CheckedItems;
		}

		private void RePopulateCheckBoxes()
		{
			ArrayList CheckedItems = new ArrayList();
			CheckedItems = (ArrayList)Session["CheckedItems"];
			if(CheckedItems != null)
			{
				foreach(DataGridItem dgItem in grdResults.Items)
				{
					int ChkBxIndex = int.Parse(dgItem.Cells[4].Text);
					if(CheckedItems.Contains(ChkBxIndex.ToString()))
					{
						CheckBox chkAssign = (CheckBox)dgItem.FindControl("chkAssign");
						chkAssign.Checked = true;
					}
				}
			}
		}

		protected void btnSearch_Click(object sender, System.EventArgs e)
		{		
			ShowData(0);
			this.lblUserAssignMessage.Text= String.Empty;			
			this.panUserSaveAll.Visible = true;
		}

		protected void btnAssign_Click(object sender, System.EventArgs e)
		{
			int PolicyID;
			try
			{
				PolicyID = int.Parse(Session["PolicyID"].ToString());
			}
			catch
			{
				PolicyID = -1;
			}
			string[] selectedUnits;
			selectedUnits = this.trvUnitsSelector.GetSelectedValues();
			BusinessServices.Policy objPolicy= new BusinessServices.Policy();
			objPolicy.ResetPolicyUnitAccess(PolicyID);
			if(selectedUnits.Length > 0)
			{
				foreach(string strUnitID in selectedUnits)
				{
					objPolicy.SetPolicyUnitAccess(PolicyID, Int32.Parse(strUnitID));
					objPolicy.SetPolicyUserAccessByUnit(PolicyID, Int32.Parse(strUnitID));
				}
			}

			this.lblUnitAssignMessage.Visible = true;
			this.lblUnitAssignMessage.Text = ResourceManager.GetString("lblMessage.SaveUnits");
			this.lblUnitAssignMessage.CssClass = "SuccessMessage";
		}


		protected void lnkAssignUnits_Click(object sender, System.EventArgs e)
		{
			
			// Get units which have already been assigned and set 
			// as checked on the treeview
			SetAssignedUnits();

			// Manipulation of panels so visible
			this.panAssignUnits.Visible = true;
			this.panUnitSelect.Visible = true;
			this.panAssign.Visible = true;

			this.panAssignUsers.Visible = false;
			this.panUserUnitSelect.Visible = false;
			this.panUserSearchResults.Visible = false;
			this.panUserDetails.Visible = false;
			this.panSearchReset.Visible = false;
			this.panUserSaveAll.Visible = false;
			this.panUserSearchMessage.Visible = false;

			this.panViewUsers.Visible = false;
			this.panUserList.Visible = false;
			this.panUnitSaveAll.Visible = false;
			this.lblUnitAssignMessage.Visible = false;	
		}

		private void SetAssignedUnits()
		{
			int PolicyID;
			try
			{
				PolicyID = int.Parse(Session["PolicyID"].ToString());
			}
			catch
			{
				PolicyID = -1;
			}

			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
			DataTable dtAssignedUnits = objPolicy.GetPolicyUnitAccess(PolicyID);
			
			BusinessServices.Unit objUnit= new  BusinessServices.Unit();
			DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'A',false);

			if(dstUnits.Tables[0].Rows.Count > 0)
			{
				//Loop through and assign values to a string array
				string[] strAssignedUnits = new string[dtAssignedUnits.Rows.Count];
				for(int row = 0; row < dtAssignedUnits.Rows.Count; ++row)
				{
					strAssignedUnits[row] = dtAssignedUnits.Rows[row]["UnitID"].ToString();
				}
				this.trvUnitsSelector.SetSelectedValues(strAssignedUnits);
				this.lblSelectUnits.Visible = true;
				this.lblUnitMessage.Visible = false;
				this.btnAssign.Visible = true;
			}
			else
			{
				//No units exist - display message
				this.lblUnitMessage.Visible = true;
				this.lblSelectUnits.Visible = false;
				this.lblUnitMessage.Text = ResourceManager.GetString("NoUnits");
				this.lblUnitMessage.CssClass = "FeedbackMessage";
				this.btnAssign.Visible = false;
			}
		}


		protected void lnkAssignUsers_Click(object sender, System.EventArgs e)
		{
			//TODO: functionality here
			int PolicyID;
			try
			{
				PolicyID = int.Parse(Session["PolicyID"].ToString());
			}
			catch
			{
				PolicyID = -1;
			}
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
			DisplayType = "search";	

			BusinessServices.Unit objUnit= new  BusinessServices.Unit();
			DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'A',false);

			if (dstUnits.Tables[0].Rows.Count == 0)
			{
				//No Units and therefore no users - display message and hide controls
				this.panUserUnitSelect.Visible = false;
				this.panUserDetails.Visible = false;
				this.panSearchReset.Visible = false;
				this.lblUserMessage.Visible = true;
				this.lblUserMessage.Text = ResourceManager.GetString("NoUnits");
				this.lblUserMessage.CssClass = "FeedbackMessage";
			}
			else
			{
				this.panUserUnitSelect.Visible = true;
				this.panUserDetails.Visible = true;
				this.panSearchReset.Visible = true;
				this.lblUserMessage.Visible = false;
			}
			this.panAssignUsers.Visible = true;
			this.panAssignUnits.Visible = false;
			this.panUnitSelect.Visible = false;
			this.panAssign.Visible = false;
			this.panUserSearchResults.Visible = false;
			this.panUserSaveAll.Visible = false;
			this.panUserSearchMessage.Visible = false;
			this.panViewUsers.Visible = false;
			this.panUserList.Visible = false;
			this.panUnitSaveAll.Visible = false;
			this.lblUserAssignMessage.Text= String.Empty;
			blnViewUsers=false; 
		}

		protected void lnkViewUsers_Click(object sender, System.EventArgs e)
		{
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
			DisplayType = "view";

			this.panAssignUnits.Visible = false;
			this.panUnitSelect.Visible = false;
			this.panAssign.Visible = false;

			this.panAssignUsers.Visible = false;
			this.panUserUnitSelect.Visible = false;
			this.panUserDetails.Visible = false;
			this.panSearchReset.Visible = false;
			this.panUserSearchResults.Visible = false;
			this.panUserSaveAll.Visible = true;
			this.panUserSearchMessage.Visible = false;

			this.panViewUsers.Visible = true;
			this.panUserList.Visible = false;
			this.panUnitSaveAll.Visible = false;
			blnViewUsers = true;

			ShowData(0);
		}

		private void ShowData(int pageIndex)
		{
			DataView dvwPagination;
			this.lblNoUsers.Text = String.Empty;
			
			dvwPagination	= GetData();

			if(InitialiseSession)
			{
				// First time through populate Session with
				// Arraylist of checked items from database
				ArrayList CheckedItems = new ArrayList();
				foreach(DataRow dr in dvwPagination.Table.Rows)
				{
					bool IsGranted = bool.Parse(dr["Granted"].ToString());
					int ChkBxIndex = int.Parse(dr["UserID"].ToString());
					if(IsGranted)
					{						
						if(!CheckedItems.Contains(ChkBxIndex.ToString()))
						{
							CheckedItems.Add(ChkBxIndex.ToString());
						}
					}
					else
					{
						CheckedItems.Remove(ChkBxIndex.ToString());
					}
				}
				Session["CheckedItems"] = CheckedItems;

				InitialiseSession = false;
			}

			int intRowCount = dvwPagination.Table.Rows.Count; 
			if (intRowCount > 0)
			{
				//2. Use pagination if necessary
				if (intRowCount > ApplicationSettings.PageSize)
				{
					grdResults.AllowPaging=true;
					grdResults.CurrentPageIndex = pageIndex;
				}
				else
				{
					grdResults.AllowPaging=false;
				}
				if (intRowCount > 1)
				{
					//3. Sort Data
					grdResults.AllowSorting=true;
					dvwPagination.Sort = (string)ViewState["OrderByField"] + " " + (string)ViewState["OrderByDirection"];
				}
				else
				{
					grdResults.AllowSorting=false;
				}
                
				//4. Bind Data
				grdResults.DataSource = dvwPagination;
				grdResults.DataBind();
				lblUserCount.Text = String.Format(ResourceManager.GetString("lblUserCount"), intRowCount.ToString());
				this.panUserSearchResults.Visible = true;
				this.panUserSearchMessage.Visible = false;
			}
			else
			{
				lblNoUsers.Text = ResourceManager.GetString("NoUsersFound");
				lblNoUsers.CssClass = "FeedbackMessage";
				this.panUserSearchMessage.Visible = true;
				this.panUserSearchResults.Visible = false;
				this.panUserSaveAll.Visible = false;
			}
			
		}

		private DataView GetData()
		{
			string strParentUnits ="";

			if (!blnViewUsers )
			{
				strParentUnits = String.Join(",", this.trvUserUnitsSelector.GetSelectedValues());
			}
			
			int OrganisationID = UserContext.UserData.OrgID;
			int PolicyID;
			
			try
			{
				PolicyID = int.Parse(Session["PolicyID"].ToString());
			}
			catch
			{
				PolicyID = -1;
			}

            
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
			DataTable dtSearchResults = objPolicy.PolicyUserSearch(OrganisationID, PolicyID, strParentUnits,
				this.txtFirstName.Text, this.txtLastName.Text, this.txtUserName.Text, this.txtEmail.Text,
				this.txtExternalId.Text, UserContext.UserID, DisplayType);
			
			return dtSearchResults.DefaultView;
		}

		protected void btnCancel_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(@"\Administration\Policy\policydefault.aspx");
		}

		protected void btnSavePolicy_Click(object sender, System.EventArgs e)
		{
			int OrganisationID = UserContext.UserData.OrgID;
			int PolicyID;
			try
			{
				PolicyID = Int32.Parse(Session["PolicyID"].ToString());
			}
			catch
			{
				PolicyID = -1;
			}
			string PolicyName = this.txtName.Text;
			bool CanUpload = false;
			string OrigPolicyName = "";
			long FileLength = GetFileSize();

			//Initialise upload message text
			ClearMessages();

			// Create Policy object
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
			
			// Check if Organisation has space for saving policies
			long lngOrgSizeLimit = objPolicy.GetAllocatedDiskSpace(OrganisationID);
			if (lngOrgSizeLimit == 0)
			{					
				// No value returned - Organisation has not had size allocated in organisation details - message to user
				lblUploadFile.Text = ResourceManager.GetString("OrgNoSpaceAllocated");
				lblUploadFile.CssClass = "WarningMessage";
			}
			//Check if the file is less than 2 mb
			else if (FileLength > 2097152)
			{
				lblUploadFile.Text = ResourceManager.GetString("FSZTOOBIG");
				lblUploadFile.CssClass = "WarningMessage";
			}
			else
			{

				// Get policies original name
                DataTable dtPolicy = objPolicy.GetPolicy(PolicyID, OrganisationID);
				if (dtPolicy.Rows.Count > 0)
				{
					OrigPolicyName = dtPolicy.Rows[0]["PolicyName"].ToString();
				}
				// Check policy with same name does not already exist
				DataTable CheckPolicyName = new DataTable();
				CheckPolicyName = objPolicy.CheckPolicyName(OrganisationID, PolicyName);
	
				if(CheckPolicyName.Rows.Count == 0)
				{
					CanUpload = true;
				}
				else
				{
					if(PolicyName == OrigPolicyName)
					{
						CanUpload = true;
					}
					else
					{
						// Policy Exists - display message for user to select another name
						lblPolicyName.Text = ResourceManager.GetString("PolicyExists");
						lblPolicyName.CssClass = "WarningMessage";
					}
				}
				if (CanUpload)
				{
					PolicyID = SavePolicy();
					Session["PolicyID"] = PolicyID;
					LoadPolicy(PolicyID);
					if(PolicyID != -1)
					{
						if((UploadSuccess && UploadFile.Value.Length > 0) || (!UploadSuccess && UploadFile.Value.Length == 0))
						{
							Response.Redirect(@"\Administration\Policy\policydetails.aspx?Success=true");
						}
					}
				}
			}
		}

		protected void lnkResetUsers_Click(object sender, System.EventArgs e)
		{
			// business logic to reset users
			int OrganisationID = UserContext.UserData.OrgID;
			int PolicyID =  Int32.Parse(Session["PolicyID"].ToString());
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
			objPolicy.ResetUsers(OrganisationID, PolicyID);
			Response.Redirect(@"\Administration\Policy\policydetails.aspx");
		}
	}
}
