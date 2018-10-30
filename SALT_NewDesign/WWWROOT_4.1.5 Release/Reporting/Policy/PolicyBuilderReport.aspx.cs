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
using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.ErrorHandler;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Uws.Framework.WebControl;
using Localization;


namespace Bdw.Application.Salt.Web.Reporting.Policy
{
	/// <summary>
	/// Summary description for PolicyBuilderReport.
	/// </summary>
	public partial class PolicyBuilderReportForm : System.Web.UI.Page
	{



		protected Bdw.Application.Salt.Web.General.UserControls.Navigation.HelpLink ucHelp;







		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			ucHelp.Attributes["Desc"] = ResourceManager.GetString("ucHelp");
			lblPageTitle.Text =  ResourceManager.GetString("lblPageTitle");
			this.lblError.Text="";
			if (!Page.IsPostBack)
			{
				this.plhSearchCriteria.Visible = true;
				// when the page loads for the first time hide the report results place holder.
				this.plhReportResults.Visible = false;
				this.PaintCriteraPageState();
			}
		}

		/// <summary>
		/// Paint Critera section of the page.
		/// </summary>
		private void PaintCriteraPageState()
		{

			// Get Units accessable to this user.
			BusinessServices.Unit objUnit = new BusinessServices.Unit();
			DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID ,UserContext.UserID,'A');
			
			// Convert this to an xml string for rendering by the UnitTreeConverter.
			string strUnits = UnitTreeConvert.ConvertXml(dstUnits);
			if (strUnits=="")
			{
				// No units found.
				this.lblError.Visible = true;
				this.lblError.Text += "<BR>" + ResourceManager.GetString("lblError.NoUnit");//No units exist within this organisation.";
				this.lblError.CssClass = "FeedbackMessage";
				this.plhSearchCriteria.Visible=false;
			}
			else
			{
				// Change to the appropriate view and load the Units in
				this.trvUnitsSelector.LoadXml(strUnits);
			}


			// Get Policies accessable to this organisation
			BusinessServices.Policy objPolicy = new BusinessServices.Policy();
			Organisation objOrg = new Organisation();

			//DataTable dtbPolicies = objPolicy. //  objCourse.GetCourseListAccessableToOrg(UserContext.UserData.OrgID);
			DataTable dtbPolicies = objOrg.GetOrganisationPolicies(UserContext.UserData.OrgID);
			if (dtbPolicies.Rows.Count>0)
			{
				lstPolicy.DataSource = dtbPolicies;
				lstPolicy.DataTextField = "PolicyName";
				lstPolicy.DataValueField = "PolicyID";
				lstPolicy.DataBind();
			}
			else
			{
				this.lblError.Visible = true;
				this.lblError.Text += "<BR>" + ResourceManager.GetString("lblError.NoPolicy");//"No courses exist within this organisation.";
				this.lblError.CssClass = "WarningMessage";
				this.plhSearchCriteria.Visible=false;
			}
			// If there is at least one course then select it.
			if (lstPolicy.Items.Count>0)
			{lstPolicy.SelectedIndex=0;} 

			// Initialise the date list boxes.
			WebTool.SetupHistoricDateControl(this.lstEffectiveDay, this.lstEffectiveMonth, this.lstEffectiveYear);
			WebTool.SetupHistoricDateControl(this.lstEffectiveToDay, this.lstEffectiveToMonth, this.lstEffectiveToYear);

			radAcceptance.Items[0].Text = ResourceManager.GetString("radAcceptance.1");
			radAcceptance.Items[1].Text = ResourceManager.GetString("radAcceptance.2");
			radAcceptance.Items[2].Text = ResourceManager.GetString("radAcceptance.3");
			

		}

  
		private void ShowReport()
		{
			//1.Gather criteria
			
			// Get the selected units
			// string  strParentUnits  = String.Join(",",this.trvUnitsSelector.GetSelectedValues());
			string[] selectUnits;			
			selectUnits = trvUnitsSelector.GetSelectedValues();
			string strUnits ="0";
			if(selectUnits.Length > 0)
			{
				strUnits = String.Join(",",selectUnits);
			}
			else if (selectUnits.Length == 0)
			{
				// Get all the parent units.  Only Needed for this Report, if the selected units is empty - then select all parents.
				BusinessServices.Unit objUnit = new  BusinessServices.Unit();			
				string[] selectParentUnits = objUnit.ReturnAdministrableUnitsByUserID( UserContext.UserID, UserContext.UserData.OrgID, selectUnits);
				//string  strParentUnits  = String.Join(",",selectParentUnits);
				strUnits = String.Join(",",selectParentUnits);
			}

			
			// Get the selected Policy Acceptance Status
			//			int intCourseID = Convert.ToInt32(cboCourse.SelectedValue);
			string strAcceptance = radAcceptance.SelectedValue.ToString();

			// Get the selected Policies
			string strPolicies = string.Empty; //"0";
			for (int intIndex=0;intIndex != this.lstPolicy.Items.Count;intIndex++)
			{
				if (this.lstPolicy.Items[intIndex].Selected)
				{
					if(intIndex == 0)
					{
						strPolicies += this.lstPolicy.Items[intIndex].Value;					
					}
					else
					{
						strPolicies += "," + this.lstPolicy.Items[intIndex].Value ;
					}
				}
			}                 
        
			DateTime dtEffective;
			DateTime dtEffectiveTo;
			
			// Gather date parts for date range
			if ( (this.lstEffectiveDay.SelectedValue.Length > 0) && (this.lstEffectiveMonth.SelectedValue.Length > 0) && (this.lstEffectiveYear.SelectedValue.Length > 0) )
			{
				dtEffective = new DateTime(int.Parse(this.lstEffectiveYear.SelectedValue), int.Parse(this.lstEffectiveMonth.SelectedValue), int.Parse(this.lstEffectiveDay.SelectedValue));
			}
			else
			{// The user select 'To Date' only 
				// Set the from date to a past date to cover all the record has been created
				dtEffective = new DateTime(1997,1,1);
			}


			if ((this.lstEffectiveToDay.SelectedValue.Length > 0) && (this.lstEffectiveToMonth.SelectedValue.Length > 0) && (this.lstEffectiveToYear.SelectedValue.Length > 0))
			{
				dtEffectiveTo = new DateTime(int.Parse(this.lstEffectiveToYear.SelectedValue), int.Parse(this.lstEffectiveToMonth.SelectedValue), int.Parse(this.lstEffectiveToDay.SelectedValue));
				dtEffectiveTo = dtEffectiveTo.AddDays(1);
			}
			else
			{
				dtEffectiveTo = DateTime.Today.AddDays(1);
			}

			string lstrInclInactiveUser = "";
			if (this.chbInclInactiveUser.Checked)
			{
				lstrInclInactiveUser = "true";
			}
			else
			{
				lstrInclInactiveUser = "false";
			}


			//2. Add criteria to the report viewer
			Hashtable parameters = this.rvReport.Parameters;

			parameters["organisationID"] =  UserContext.UserData.OrgID;
			parameters["adminUserID"] =  UserContext.UserID;
			parameters["unitIDs"] =  strUnits; //strParentUnits;
			parameters["policyIDs"] =  strPolicies;
			parameters["dateFrom"] =  dtEffective.ToString("s");			
			parameters["dateTo"] = dtEffectiveTo.ToString("s");
			parameters["acceptanceStatus"] =  strAcceptance;
            parameters["IncludeInactive"] = lstrInclInactiveUser;

			parameters["langCode"] = Request.Cookies["currentCulture"].Value;
			parameters["langInterfaceName"] = "Report.Policies";

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
			this.ID = "PolicyBuilderReportForm";
		}
		#endregion

		protected void chbInclInactiveUser_CheckedChanged(object sender, System.EventArgs e)
		{
		
		}

		protected void btnGenerate_Click(object sender, System.EventArgs e)
		{
			// Check if the selected dates are valid
			if(WebTool.ValidateHistoricDateControl(this.lstEffectiveDay, this.lstEffectiveMonth, this.lstEffectiveYear) &&
				WebTool.ValidateHistoricDateControl(this.lstEffectiveToDay, this.lstEffectiveToMonth, this.lstEffectiveToYear))
			{
				if ((this.lstEffectiveYear.SelectedValue.Length > 0)&& (this.lstEffectiveToYear.SelectedValue.Length > 0))
				{//Both From and To Dates are selected
					DateTime dtFromDate = new DateTime(int.Parse(this.lstEffectiveYear.SelectedValue), int.Parse(this.lstEffectiveMonth.SelectedValue), int.Parse(this.lstEffectiveDay.SelectedValue));
					DateTime dtToDate = new DateTime(int.Parse(this.lstEffectiveToYear.SelectedValue), int.Parse(this.lstEffectiveToMonth.SelectedValue), int.Parse(this.lstEffectiveToDay.SelectedValue));
		
					if(dtFromDate <= dtToDate)
					{
						this.plhSearchCriteria.Visible = false;
						this.plhReportResults.Visible = true;
						this.plhTitle.Visible =false;
						this.lblError.Visible=false;
						this.ShowReport();
					}
					else
					{
						this.plhSearchCriteria.Visible = true;
						this.plhReportResults.Visible = false;
						this.plhTitle.Visible =true;
						this.lblError.Text=ResourceManager.GetString("lblError.Date");//"The effective from date must be less than to date";
						this.lblError.Visible=true; 
					}
				}
				else
				{
					this.plhSearchCriteria.Visible = false;
					this.plhReportResults.Visible = true;
					this.plhTitle.Visible =false;
					this.lblError.Visible=false;
					this.ShowReport();
				}
			}
			else
			{
				this.plhSearchCriteria.Visible = true;
				this.plhReportResults.Visible = false;
				this.plhTitle.Visible =true;
				this.lblError.Text=ResourceManager.GetString("lblError.Date2");//"The effective date must be valid and cannot be greater than today";
				this.lblError.Visible=true; 
			}
		}

		protected void btnReset_Click(object sender, System.EventArgs e)
		{
			Response.Redirect(Request.RawUrl);
		}

		protected void rvReport_PageIndexChanged(object sender, System.EventArgs e)
		{
			this.ShowReport();
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

	}



}
