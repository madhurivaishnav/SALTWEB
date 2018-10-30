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
using System.Xml;

using Bdw.Application.Salt.Data;

using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Localization;

namespace Bdw.Application.Salt.Web.Reporting.Advanced
{
	/// <summary>
	/// Summary description for EmailSentReport.
	/// </summary>
	public partial class EmailSentReport : System.Web.UI.Page
	{
		
		//protected Localization.LocalizedLabel lblDateFrom;
		
		protected System.Web.UI.WebControls.Label lblFromDay;
		protected System.Web.UI.WebControls.Label lblFromMonth;
		protected System.Web.UI.WebControls.Label lblFromYear;
		
		//protected Localization.LocalizedLabel lblSubject;
		
		
		//protected Localization.LocalizedLabel lblBody;
		
		
		//protected Localization.LocalizedButton btnFind;
		
		
		//protected Localization.LocalizedLiteral lnkReturn;
		
		
		//protected Localization.LocalizedLiteral litPage;
		

		//protected Localization.LocalizedLiteral Localizedliteral1;
		
		
		//protected Localization.LocalizedLiteral litDisplayed;
		//protected Localization.LocalizedLiteral litOf;
		
		
		//protected Localization.LocalizedLinkButton btnPrev;
		//protected Localization.LocalizedLinkButton btnNext;

		
		protected System.Web.UI.WebControls.Label lblSearchEmail;
		//protected Localization.LocalizedLabel lblSearchEmail;
		
		//protected Localization.LocalizedLabel lblDateTo;
		//protected Localization.LocalizedLabel lblRecip;
		



		protected void Page_Load(object sender, System.EventArgs e)
		{
			if(!Page.IsPostBack)
			{
				SetupDateControl(cboFromDay,cboFromMonth,cboFromYear);
				SetupDateControl(cboToDay,cboToMonth,cboToYear);
			
				this.tblPagination.Visible = false;
			}
            ResourceManager.RegisterLocaleResource("ConfirmMessage.Resend");
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
		}

		#region Private Events
		private void SetupDateControl(DropDownList objDayListbox,DropDownList objMonthListbox,DropDownList objYearListbox)
		{
			int intThisYear;

			intThisYear = System.DateTime.Today.Year;

			for (int intDay=1;intDay<=31;intDay++)
			{
				objDayListbox.Items.Add (intDay.ToString());
			}

			for (int intMonth=1;intMonth<=12;intMonth++)
			{
				objMonthListbox.Items.Add (intMonth.ToString());
			}

			for (int intYear=intThisYear-10;intYear<=intThisYear;intYear++)
			{
				ListItem itmEntry = new ListItem();
				itmEntry.Text = intYear.ToString();
				itmEntry.Value= intYear.ToString();

				objYearListbox.Items.Add (itmEntry);
			}
			objYearListbox.Items.FindByValue(intThisYear.ToString()).Selected = true;
			objDayListbox.SelectedIndex=System.DateTime.Today.Day-1;
			objMonthListbox.SelectedIndex=System.DateTime.Today.Month-1;
		}

		#endregion
		
		#region Private Events
		/*private void btnRunModuleStatusUpdate_Click(object sender, System.EventArgs e)
		{
			// Run the module status update job
			BusinessServices.Application objApp = new BusinessServices.Application();
			objApp.RunModuleStatusUpdate(UserContext.UserData.OrgID);

			SetLastRunDate();
		}*/

		protected void btnFind_Click(object sender, System.EventArgs e)
		{
			StartPagination();
		}
		#endregion

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
			grdPagination.Columns[0].HeaderText = ResourceManager.GetString("Grid_DateSent");
			grdPagination.Columns[1].HeaderText = ResourceManager.GetString("Grid_To");
			grdPagination.Columns[2].HeaderText = ResourceManager.GetString("Grid_Subject");
			grdPagination.Columns[3].HeaderText = ResourceManager.GetString("Grid_Body");
            grdPagination.Columns[4].HeaderText = ResourceManager.GetString("Grid_Action");
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.grdPagination.SortCommand += new System.Web.UI.WebControls.DataGridSortCommandEventHandler(this.grdPagination_SortCommand);
            this.grdPagination.ItemDataBound += new System.Web.UI.WebControls.DataGridItemEventHandler(this.grdPagination_ItemDataBound);
            this.grdPagination.ItemCommand += new System.Web.UI.WebControls.DataGridCommandEventHandler(this.grdPagination_ItemCommand);

		}
		#endregion

		#region Pagination customization(Change this section according to business logic)
		/// <summary>
		/// Start Pagination
		/// </summary>
		private void StartPagination()
		{
			//Initialize Pagination settings
			ViewState["OrderByField"]="";
			ViewState["OrderByDirection"]="";
			this.SetPaginationOrder("DateCreated"); //customization
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
			DateTime dteDateFrom, dteDateTo;
			string strToEmail,strSubject,strBody;
			int intFromYear, intFromMonth, intFromDay;
			int intToYear, intToMonth, intToDay;

			intFromYear = int.Parse(this.cboFromYear.SelectedValue);
			intFromMonth = int.Parse(this.cboFromMonth.SelectedValue);
			intFromDay = int.Parse(this.cboFromDay.SelectedValue);
			
			intToYear = int.Parse(this.cboToYear.SelectedValue);
			intToMonth = int.Parse(this.cboToMonth.SelectedValue);
			intToDay = int.Parse(this.cboToDay.SelectedValue);
			try
			{
				dteDateFrom = new DateTime(intFromYear, intFromMonth, intFromDay);
				dteDateTo = new DateTime(intToYear, intToMonth, intToDay);
			} 
			catch(ArgumentOutOfRangeException)
			{
				throw new BusinessServiceException(ResourceManager.GetString("InvalidDateRange"));
			}

			strToEmail = this.txtToEmail.Text; 
			strSubject = this.txtSubject.Text;
			strBody = this.txtBody.Text;
                       
			BusinessServices.Email objEmail= new  BusinessServices.Email();
			DataTable dtbEmails = objEmail.Search(dteDateFrom, dteDateTo,strToEmail,strSubject,strBody,UserContext.UserData.OrgID);
			
			if (dtbEmails.Rows.Count==0)
			{
				this.lblSearchMessage.Text=ResourceManager.GetString("lblSearchMessage.Non");//"No Matching Emails Found";
				this.lblSearchMessage.CssClass = "WarningMessage";
				this.lblSearchMessage.Visible=true;
				this.tblPagination.Visible=false;
			}
			else
			{
				this.lblSearchMessage.Visible=false;
				this.tblPagination.Visible=true;
			}
			return dtbEmails.DefaultView;
		}
		#endregion

		#region Pagination event handler(Don't make any changes to this section)
		/// <summary>
		/// Go to previous page
		/// </summary>
		protected void btnPrev_Click(object sender, System.EventArgs e)
		{
			
			this.ShowPagination(this.grdPagination.CurrentPageIndex-1);
		}
		/// <summary>
		/// Go to next page	
		/// </summary>
		protected void btnNext_Click(object sender, System.EventArgs e)
		{
			this.ShowPagination(this.grdPagination.CurrentPageIndex+1);
		}

		/// <summary>
		/// Go to a specific page
		/// </summary>
		protected void cboPage_SelectedIndexChanged(object sender, System.EventArgs e)
		{
			int intPageIndex;
			intPageIndex = int.Parse(this.cboPage.SelectedValue);
			this.ShowPagination(intPageIndex-1);
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
        /// Data Bound
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void grdPagination_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lnkResendButton = (LinkButton)e.Item.Cells[4].Controls[0];

                if (lnkResendButton != null)
                {
                    lnkResendButton.Text = ResourceManager.GetString("grid_lnkResend");

                    // set on client click since the aspx doesn't allow this
                    lnkResendButton.OnClientClick = "javascript:return ResendConfirm();";

                    // get the email id and pass it to the command argument
                    DataRowView drvEmail = e.Item.DataItem as DataRowView;
                    if(drvEmail != null) {
                        lnkResendButton.CommandArgument = drvEmail.Row["emailID"].ToString();
                    }
                }
            }
        }

        /// <summary>
        /// Item Command
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        private void grdPagination_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            // If user is resending the email
            if (e.CommandName.ToLower() == "resend")
            {
                BusinessServices.User objUser;
                int emailID = 0;

                // get the user FROM info (which is the currently logged in user)
                objUser = new BusinessServices.User();
                DataTable dtbCurrentUser = objUser.GetUser(UserContext.UserID);

                // get the email ID and retrieve this email from the database
                Int32.TryParse(e.CommandArgument.ToString(), out emailID);
                BusinessServices.Email objEmail = new BusinessServices.Email();
                DataTable dtbEmails = objEmail.Search(emailID, UserContext.UserData.OrgID);

                // only get the first (since there SHOULD only be one emailid)
                if (dtbEmails.Rows.Count != 0)
                {
                    // get the user id for this email
                    int userID = 0;
                    Int32.TryParse(dtbEmails.Rows[0]["userid"].ToString(), out userID);

                    string strEmailTo = dtbEmails.Rows[0]["toemail"].ToString();
                    string strNameTo = null;

                    if (userID == 0)
                    {
                        // get the To name
                        strNameTo = dtbEmails.Rows[0]["toname"] == null ? null : dtbEmails.Rows[0]["toname"].ToString();
                    }
                    else
                    {
                        DataTable dtbUser = objUser.GetUser(userID);
                        strNameTo = dtbUser.Rows[0]["FirstName"].ToString() + " " + dtbUser.Rows[0]["LastName"].ToString();
                    }

                    string strEmailFrom = dtbCurrentUser.Rows[0]["email"].ToString();
                    string strNameFrom = dtbCurrentUser.Rows[0]["FirstName"].ToString() + " " + dtbCurrentUser.Rows[0]["LastName"].ToString();

                    string strBody = dtbEmails.Rows[0]["body"].ToString();
                    string strSubject = dtbEmails.Rows[0]["subject"].ToString();

                    // no need to do the subs here as its just trying to resend the email.
                    objEmail.setUserCopyEmailBody(strBody);
                    objEmail.SendEmail(strEmailTo, strNameTo, strEmailFrom, strNameFrom, null, null, strSubject, ApplicationSettings.MailServer, UserContext.UserData.OrgID, userID);

                    this.lblMessage.Text = ResourceManager.GetString("lblMessage.EmailSent");
                    this.lblMessage.Visible = true;
                    this.lblMessage.CssClass = "SuccessMessage";
                }
            }
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
			try
			{
				//1. Get data
				DataView  dvwPagination = this.GetPaginationData();
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
			catch(BusinessServiceException ex)
			{
				this.tblPagination.Visible=false;
				this.lblMessage.Text = ex.Message;
				this.lblMessage.CssClass = "WarningMessage";
			}
		}


		/// <summary>
		///Set pagination panel 
		/// </summary>
		/// <param name="pageSize"></param>
		/// <param name="totalRecordCount"></param>
		/// <param name="currentPageIndex"></param>
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
	}
}
