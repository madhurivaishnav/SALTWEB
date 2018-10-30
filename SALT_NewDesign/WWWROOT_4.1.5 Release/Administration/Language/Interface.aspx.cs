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

using Bdw.Application.Salt.App_Code.API;
using Bdw.Application.Salt.App_Code.Entity;
using Bdw.Application.Salt.Web.Utilities;

namespace Bdw.Application.Salt.Web.Administration.Language
{
	/// <summary>
	/// Summary description for Interface.
	/// </summary>
	public partial class Interface : System.Web.UI.Page
	{
		#region "Controls"
		#endregion

		#region "Page Properties"

			private int langID = 0;
			public int LangID
			{
				get
				{
					if (langID == 0 && ViewState["LangID"] != null)
						langID = Int32.Parse(ViewState["LangID"].ToString());

					return langID;
				}
				set 
				{
					ViewState.Add("LangID", value);
					langID = value;
				}
			}


		#endregion

		protected void Page_Load(object sender, System.EventArgs e)
		{
			if (!IsPostBack)
			{
				// Set selected language property
				if(Request.QueryString["LangID"] != string.Empty)
					this.LangID = Int32.Parse(Request.QueryString["LangID"]);
				


				Lang lang = LangAPI.GetEntity(this.LangID);
				lblSelectedLanguage.Text = lang.RecordName;
			}
		}

		private void Bind_InterfaceGrid(int langID)
		{
			grdInterfaceList.DataSource = LangInterfaceAPI.InterfaceList(langID);
			grdInterfaceList.DataBind();
		}


		private void grdInterfaceList_ItemCreated(object source, DataGridItemEventArgs e)
		{
			if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
			{
				LangInterface langInterface = (LangInterface)e.Item.DataItem;

				if (langInterface.CommittedCount > 0)
				{
					LinkButton lnkCommit = (LinkButton)e.Item.FindControl("lnkCommit");
					lnkCommit.Attributes.Add("onclick", "return confirm('Commit all changes for all resources under this Interface?');");
					lnkCommit.Visible = true;
					lnkCommit.CommandName = "COMMIT";
				}
			}
		}

		private void grdInterfaceList_ItemCommand(object source, DataGridCommandEventArgs e)
		{
			int langInterfaceID = Int32.Parse(grdInterfaceList.DataKeys[e.Item.ItemIndex].ToString());

			switch (e.CommandName)
			{
				case "COMMIT":
					LangValueAPI.Commit(UserContext.UserID, this.LangID, langInterfaceID);
					foreach(DictionaryEntry item in Cache)
					{
						Cache.Remove(item.Key.ToString());
					}
					
					break;

				case "RESOURCE":
					Response.Redirect("Resource.aspx?langID=" + this.LangID.ToString() + "&langInterfaceID=" + langInterfaceID.ToString());
					break;
			}

			grdInterfaceList.EditItemIndex = -1;

			Bind_InterfaceGrid(this.LangID);
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			InitializeComponent();
			base.OnInit(e);

			if (!IsPostBack)
			{
				// Set selected language property
				if(Request.QueryString["LangID"] != string.Empty)
					this.LangID = Int32.Parse(Request.QueryString["LangID"]);

			}
			Bind_InterfaceGrid(this.LangID);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			grdInterfaceList.ItemCreated+=new DataGridItemEventHandler(grdInterfaceList_ItemCreated);
			grdInterfaceList.ItemCommand+=new DataGridCommandEventHandler(grdInterfaceList_ItemCommand);
		}
		#endregion
	}
}
