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

namespace Bdw.Application.Salt.Web.Administration.Organisation
{
	/// <summary>
	/// Summary description for UnitManagement.
	/// </summary>
	public partial class UnitManagement : System.Web.UI.Page
	{
        /// <summary>
        /// Label for messages to user
        /// </summary>
		protected System.Web.UI.WebControls.Label lblMessage;

        /// <summary>
        /// Treeview to move unit from
        /// </summary>
		protected Uws.Framework.WebControl.TreeView trvFromUnit;

        /// <summary>
        /// Treeview to move unit to 
        /// </summary>
		protected Uws.Framework.WebControl.TreeView trvToUnit;

        /// <summary>
        /// Checkbox to move unit to the top level
        /// </summary>
		protected System.Web.UI.WebControls.CheckBox chkTopLevel;

        /// <summary>
        /// Label for page title
        /// </summary>
        protected System.Web.UI.WebControls.Label lblPageTitle;

		/// <summary>
		/// Label that shows the message 
		/// </summary>
        protected System.Web.UI.WebControls.Label lblNoSubUnits;

		/// <summary>
		/// Place holder that surrounds the main screen
		/// </summary>
        protected System.Web.UI.WebControls.PlaceHolder plhMainscreen;

        /// <summary>
        /// Button to move units
        /// </summary>
		protected System.Web.UI.WebControls.Button btnMove;
	
        /// <summary>
        /// Page load event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
		protected void Page_Load(object sender, System.EventArgs e)
		{
			ResourceManager.RegisterLocaleResource("permissionConfirm");
			ResourceManager.RegisterLocaleResource("unitConfirm");

			pagTitle.InnerText = ResourceManager.GetString("pagTitle");
			if (!Page.IsPostBack)
			{
				this.RenderUnitTreeData(0);

				this.btnMove.Attributes.Add("onclick", "javascript:return MovingConfirm();");

				//Only Salt Administrator (1), Organisation Administrator (2) can move a unit to top level
				if (UserContext.UserData.UserType!=UserType.SaltAdmin && UserContext.UserData.UserType!=UserType.OrgAdmin)
				{
					this.chkTopLevel.Enabled = false;
				}

			}
		}

		private void RenderUnitTreeData(int selectedUnitID)
		{
			BusinessServices.Unit objUnit= new  BusinessServices.Unit();
			DataSet dstUnits;
			string strUnits;

            dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'S',selectedUnitID);
            
            if (dstUnits.Tables[0].Rows.Count>0)
            {
                //From Unit
                strUnits = UnitTreeConvert.ConvertXml(dstUnits);
                this.trvFromUnit.LoadXml(strUnits);

                //To Unit
                dstUnits = objUnit.GetUnitsTreeByUserID(UserContext.UserData.OrgID, UserContext.UserID, 'P',selectedUnitID);
                strUnits = UnitTreeConvert.ConvertXml(dstUnits);
                
                this.trvToUnit.LoadXml(strUnits);
            }
            else
            {
                this.plhMainscreen.Visible=false;
                this.lblNoSubUnits.Visible=true;
                
            }
            

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
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    

        }
		#endregion

		protected void btnMove_Click(object sender, System.EventArgs e)
		{
			string strMessage;

			string strFromUnitID, strToUnitID;
			int intFromUnitID, intToUnitID;

			//1. Get Data
			strFromUnitID = this.trvFromUnit.GetSelectedValue();			
			strToUnitID = this.trvToUnit.GetSelectedValue();

			strMessage = "";
			intFromUnitID = 0;
			intToUnitID = 0;

			//2. Validation
			// Check From Unit
			if (strFromUnitID=="")
			{
				strMessage = ResourceManager.GetString("Message.From");//"You must specify the From Unit to continue.";                
                this.lblMessage.CssClass = "WarningMessage";
			}
			else
			{
				intFromUnitID = int.Parse(strFromUnitID);
			}
			//Check To Unit
			if (strMessage=="")
			{
				if (this.chkTopLevel.Checked)
				{
					intToUnitID = 0;
				}
				else if (strToUnitID=="")
				{
                    strMessage = ResourceManager.GetString("Message.To");//"You must specify the To Unit to continue.";
                    this.lblMessage.CssClass = "WarningMessage";
				}
				else
				{
					intToUnitID = int.Parse(strToUnitID);
				}
			}
			
			//3. Move Unit
			if (strMessage =="")
			{
				try
				{
					BusinessServices.Unit objUnit= new  BusinessServices.Unit();
					if (intToUnitID>0)
					{
						objUnit.Move(intFromUnitID,intToUnitID,UserContext.UserID);
					}
					else
					{
						objUnit.MoveToTopLevel(intFromUnitID,UserContext.UserID);
					}
					strMessage = ResourceManager.GetString("Message.Moved");//"The specified unit has been moved successfully";
                    this.lblMessage.CssClass = "SuccessMessage";
					this.RenderUnitTreeData(intFromUnitID);
				}
				catch(ApplicationException  ex)
				{
					strMessage = ex.Message;
                    this.lblMessage.CssClass = "WarningMessage";
				}
			}
            this.lblMessage.Text = strMessage;			
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
