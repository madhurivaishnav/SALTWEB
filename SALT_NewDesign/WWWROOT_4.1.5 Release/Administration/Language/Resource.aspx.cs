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

using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Web.Utilities;


namespace Bdw.Application.Salt.Web.Administration.Language
{
	/// <summary>
	/// Summary description for Resource.
	/// </summary>
	public partial class Resource : System.Web.UI.Page
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

			private int interfaceID = 0;
			public int LangInterfaceID
		{
			get
			{
				if (interfaceID == 0 && ViewState["LangInterfaceID"] != null)
					interfaceID = Int32.Parse(ViewState["LangInterfaceID"].ToString());

				return interfaceID;
			}
			set 
			{
				ViewState.Add("LangInterfaceID", value);
				interfaceID = value;
			}
		}


			internal ArrayList LangValueUnCommitted
			{
				get
				{
					if (ViewState["langValueUnCommitted"] != null)
						return (ArrayList)ViewState["langValueUnCommitted"];
					else
						return new ArrayList();

				}
				set
				{
					ViewState.Add("langValueUnCommitted", value);
				}
			}


			internal ArrayList LangValueActive
			{
				get
				{
					if (ViewState["langValueActive"] != null)
						return (ArrayList)ViewState["langValueActive"];
					else
						return new ArrayList();

				}
				set
				{
					ViewState.Add("langValueActive", value);
				}
			}


		#endregion

		protected void Page_Load(object sender, System.EventArgs e)
		{
			if (!IsPostBack)
			{
				if(Request.QueryString["LangID"] != string.Empty)
					this.LangID = Int32.Parse(Request.QueryString["LangID"]);

				if(Request.QueryString["LangInterfaceID"] != string.Empty)
					this.LangInterfaceID = Int32.Parse(Request.QueryString["LangInterfaceID"]);

				LangInterface langInterface = LangInterfaceAPI.GetEntity(this.LangInterfaceID);
				lblSelectedInterface.Text = langInterface.RecordName;

				Bind_ResourceList();
				Bind_LanguageDropDown();
			}
		}

		private void Bind_ResourceList()
		{

			//-- Get the values for the selected language
			this.LangValueUnCommitted = LangValueAPI.LoadUnCommitList(this.LangID, this.LangInterfaceID);
			this.LangValueActive = LangValueAPI.LoadActiveList(this.LangID, this.LangInterfaceID);

			grdResourceList.DataSource = LangValueAPI.Resourcelist(this.LangID, this.LangInterfaceID);
			grdResourceList.DataBind();
		}

		private void Bind_LanguageDropDown()
		{
			ddlLanguageList.DataSource = LangAPI.LanguageAdminList();
			ddlLanguageList.DataBind();

			ddlLanguageList.SelectedValue = this.LangID.ToString();
			lnkInterface.Text = ddlLanguageList.SelectedItem.Text + " Interfaces";
		}

		private void ddlLanguageList_SelectedIndexChanged(object sender, EventArgs e)
		{
			this.LangID = Int32.Parse(ddlLanguageList.SelectedValue);
			lnkInterface.Text = ddlLanguageList.SelectedItem.Text + " Interfaces";

			Bind_ResourceList();			
		}

		private void lnkInterface_Command(object sender, CommandEventArgs e)
		{
			Response.Redirect("Interface.aspx?langID=" + this.LangID);
		}


		private void grdResourceList_ItemCreated(object sender, DataGridItemEventArgs e)
		{

			//-- Get values to be used for both item and edti templates
			LangValue otherLangValue = new LangValue();
			int resourceID = 0;

			if (e.Item.ItemType == ListItemType.EditItem || e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				resourceID = Int32.Parse(grdResourceList.DataKeys[e.Item.ItemIndex].ToString());
				otherLangValue = ItemCreated(resourceID);
			}

			//-- Edit template: Apply to controls
			if (e.Item.ItemType == ListItemType.EditItem)
			{
				Label lblOtherLangValueID = (Label)e.Item.FindControl("lblOtherLangValueID");
				lblOtherLangValueID.Text = otherLangValue.RecordID.ToString();
				TextBox txtOtherValue = (TextBox)e.Item.FindControl("txtOtherValue");

				//-- Encode so characters like <BR /> appear.
				txtOtherValue.Text = otherLangValue.LangEntryValue;

				Label lblRecordLock = (Label)e.Item.FindControl("lblRecordLock");
				lblRecordLock.Text = otherLangValue.RecordLock.ToString();

				Label lblCommit = (Label)e.Item.FindControl("lblCommit");
				lblCommit.Visible = (otherLangValue.Active == false);
			}

			//-- Item template: Apply to controls
			if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
			{
				Label lbl = (Label)e.Item.FindControl("lblOtherValue");
				lbl.Text = System.Web.HttpUtility.HtmlEncode(otherLangValue.LangEntryValue);
						
				LinkButton lnkCommit = (LinkButton)e.Item.FindControl("lnkCommit");
				lnkCommit.Visible = (otherLangValue.Active == false && otherLangValue.LangID != 0);
				lnkCommit.CommandName = "COMMIT";
				lnkCommit.Attributes.Add("onclick", "return confirm('Commit change for this resource?');");
			}
		}

		private LangValue ItemCreated(int resourceID)
		{
			foreach (LangValue unCommitted in this.LangValueUnCommitted)
			{
				if (unCommitted.LangResourceID == resourceID)
					return unCommitted;
			}


			foreach (LangValue activeValue in this.LangValueActive)
			{
				if (activeValue.LangResourceID == resourceID)
					return activeValue;
			}

			return new LangValue();
		}

		private void grdResourceList_EditCommand(object source, DataGridCommandEventArgs e)
		{
			grdResourceList.EditItemIndex = (int)e.Item.ItemIndex;
			Bind_ResourceList();
		}

		private void grdResourceList_CancelCommand(object source, DataGridCommandEventArgs e)
		{
			grdResourceList.EditItemIndex = -1;
			Bind_ResourceList();
		}

		private void grdResourceList_UpdateCommand(object source, DataGridCommandEventArgs e)
		{
			int resourceID = Int32.Parse(grdResourceList.DataKeys[e.Item.ItemIndex].ToString());

			int otherLangValueID = Int32.Parse(((Label)e.Item.FindControl("lblOtherLangValueID")).Text);
			Label lblRecordLock = (Label)e.Item.FindControl("lblRecordLock");
			TextBox txtOtherValue = (TextBox)e.Item.FindControl("txtOtherValue");
			
			//-- Get existing langvalue or create a new one (one doesn't exist for the language being entered)
			LangValue langValue = new LangValue();
			if (otherLangValueID > 0)
			{
				langValue = LangValueAPI.GetEntity(otherLangValueID);
				langValue.RecordLock = new Guid(lblRecordLock.Text);
			}
			else
			{
				langValue.LangID = this.LangID;
				langValue.LangInterfaceID = this.LangInterfaceID;
				langValue.LangResourceID = resourceID;
				langValue.UserID = UserContext.UserID;
			}

			langValue.LangEntryValue = txtOtherValue.Text;

			try
			{
				LangValueAPI.Save(langValue);
				foreach(DictionaryEntry item in Cache)
				{
					Cache.Remove(item.Key.ToString());
				}
			}
			catch (ApplicationException ex)
			{
				lblMessage.Text = ex.Message;
				lblMessage.CssClass = "WarningMessage";
			}
			catch
			{
				throw;
			}
			grdResourceList.EditItemIndex = -1;
			Response.Redirect("Resource.aspx?langID=" + this.LangID.ToString() + "&langInterfaceID=" + this.LangInterfaceID.ToString());
		}

		private void grdResourceList_ItemCommand(object source, DataGridCommandEventArgs e)
		{
			if (e.CommandName == "COMMIT") 
			{
				int langResourceID = Int32.Parse(grdResourceList.DataKeys[e.Item.ItemIndex].ToString());
				LangValueAPI.Commit(UserContext.UserID, this.LangID, this.LangInterfaceID, langResourceID);
				Bind_ResourceList();
				foreach(DictionaryEntry item in Cache)
				{
					Cache.Remove(item.Key.ToString());
				}
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
			lnkInterface.Command +=new CommandEventHandler(lnkInterface_Command);
			ddlLanguageList.SelectedIndexChanged+=new EventHandler(ddlLanguageList_SelectedIndexChanged);

			grdResourceList.EditCommand+=new DataGridCommandEventHandler(grdResourceList_EditCommand);
			grdResourceList.CancelCommand+=new DataGridCommandEventHandler(grdResourceList_CancelCommand);
			grdResourceList.UpdateCommand+=new DataGridCommandEventHandler(grdResourceList_UpdateCommand);
			grdResourceList.ItemCreated+=new DataGridItemEventHandler(grdResourceList_ItemCreated);
			grdResourceList.ItemCommand+=new DataGridCommandEventHandler(grdResourceList_ItemCommand);
		}
		#endregion

	}
}
