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

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;
using Localization;


namespace Bdw.Application.Salt.Web.Administration.Unit
{
	/// <summary>
	/// Summary description for AddUnit.
	/// </summary>
	public partial class AddUnit : System.Web.UI.Page
    {
        /// <summary>
        /// Radio button list for selecting unit level
        /// </summary>
		protected System.Web.UI.WebControls.RadioButtonList optUnitLevel;

        /// <summary>
        /// Treeview control to select parent unit
        /// </summary>
		protected Uws.Framework.WebControl.TreeView trvParentUnit;

        /// <summary>
        /// Textbox for unit name
        /// </summary>
		protected System.Web.UI.WebControls.TextBox txtName;

        /// <summary>
        /// Validator for unit name
        /// </summary>
		protected System.Web.UI.WebControls.RequiredFieldValidator rvldName;

        /// <summary>
        /// Combo box of status's
        /// </summary>
		protected System.Web.UI.WebControls.DropDownList cboStatus;

        /// <summary>
        /// Label for messages to user
        /// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

        /// <summary>
        /// Custom validator for the parent unit
        /// </summary>
        protected System.Web.UI.WebControls.CustomValidator cvldParentUnit;

        /// <summary>
        /// Save button
        /// </summary>
		protected System.Web.UI.WebControls.Button btnSave;
	
		/// <summary>
		/// Event handler for the page load event
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			if (!Page.IsPostBack)
			{
				//1. Get Parent Units
				BusinessServices.Unit objUnit= new  BusinessServices.Unit();
				DataSet dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID,UserContext.UserID,'P');

				string strUnits = UnitTreeConvert.ConvertXml(dstUnits);
				
				//2. Show Parent Unit tree
				//If there are units in the organisation, show the parent unit tree
				if (strUnits.Length>0)
				{
					this.trvParentUnit.LoadXml(strUnits);
				}
				//Otherwise hide the parent unit tree
				else
				{
					this.trvParentUnit.Visible = false;
					this.optUnitLevel.Enabled = false;
				}

				//3. Unit administrator can't create top level unit
				if (UserContext.UserData.UserType == UserType.UnitAdmin)
				{
					this.optUnitLevel.Enabled = false;
                    this.optUnitLevel.Items[1].Selected=true;
				}
			}
		}

        /// <summary>
        /// Validation for ensuring a parent unit is selected
        /// </summary>
        /// <param name="source"></param>
        /// <param name="args"></param>
        protected void cvldParentUnit_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            // If a child unit and no parent unit selected then set state invalid
            string strParentUnitID = this.trvParentUnit.GetSelectedValue();
            if ( (this.optUnitLevel.SelectedValue=="2") && (strParentUnitID.Length == 0) )
            {
                args.IsValid = false;
            }
            else
            {
                args.IsValid = true;
            }
        }

        /// <summary>
        /// Event handler for the save button
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void btnSave_Click(object sender, System.EventArgs e)
        {
            BusinessServices.Unit objUnit;

            int intOrganisationID;		// Users Organisation ID
            int intParentUnitID;		// Units Parent ID
            string strParentUnitID;		// String equivalent of intParentUnitID
            bool blnActive;				// boolean flag indicating if a unit is active
            int intUnitID;				// The unit ID
			
            if (Page.IsValid)
            {
                //1. Get new Unit details and do validation
                intOrganisationID = UserContext.UserData.OrgID;

                //Get parent Unit 
                intParentUnitID = 0;

                //If the new unit is in top level, no parent
                if (this.optUnitLevel.Enabled == true)
                {
                    if (this.optUnitLevel.SelectedValue=="1")
                    {
                        intParentUnitID = 0;
                    }
                    else
                    {   //Otherwise choose a parent
                        strParentUnitID = this.trvParentUnit.GetSelectedValue();
                        intParentUnitID = int.Parse(strParentUnitID);
                    }
                }
                // If the control isnt enabled then it must be a unit administrator - choose a parent
                else
                {
                    strParentUnitID = this.trvParentUnit.GetSelectedValue();
                    if (strParentUnitID.Length==0)
                    {
                        this.lblMessage.Text = ResourceManager.GetString("lblMessage.NoParent");//"Please select a parent unit";
                        this.lblMessage.CssClass = "WarningMessage";
                        return;
                    }
                    intParentUnitID = int.Parse(strParentUnitID);
                }
                

                if (this.cboStatus.SelectedValue=="1")
                {
                    blnActive = true;
                }
                else
                {
                    blnActive = false;
                }

                //2. Create new unit
                try
                {
                    objUnit= new BusinessServices.Unit();
                    intUnitID = objUnit.Create(intOrganisationID,intParentUnitID,this.txtName.Text,blnActive,UserContext.UserID);
					BusinessServices.Unit.DenyAllForUnit(intOrganisationID, intUnitID);

                    Response.Redirect("UnitDetails.aspx?UnitID=" + intUnitID.ToString());
                }
                catch (BusinessServiceException ex)
                {
                    this.lblMessage.Text =  ex.Message;
                    this.lblMessage.CssClass = "WarningMessage";
                }
            }
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
			optUnitLevel.Items[0].Text = ResourceManager.GetString("optUnitLevel_CreateTop");
			optUnitLevel.Items[1].Text = ResourceManager.GetString("optUnitLevel_CreateSub");
			
			cboStatus.Items[0].Text = ResourceManager.GetString("cmnActive" );
			cboStatus.Items[1].Text = ResourceManager.GetString("cmnInactive");
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    

        }
		#endregion

	}
}
