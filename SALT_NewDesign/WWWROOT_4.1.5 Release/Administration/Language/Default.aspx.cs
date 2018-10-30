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
	/// Summary description for _Default.
	/// </summary>
	public partial class _Default : System.Web.UI.Page
	{
		#region "Controls"
		#endregion

		protected void Page_Load(object sender, System.EventArgs e)
		{

		}

		private void butAddLanguage_Click(object sender, EventArgs e)
		{
			int langID = Int32.Parse(ddlLanguageList.SelectedValue);

			LangAPI.SaveShowAdmin(langID, true, UserContext.UserID);

			Bind_LanguageDropDown();
			Bind_LanguageGrid();
		}

		
		private void Bind_LanguageDropDown()
		{
			ddlLanguageList.DataSource = LangAPI.LanguageList();
			ddlLanguageList.DataBind();
			
			if (ddlLanguageList.Items.Count == 0)
				butAddLanguage.Enabled = false;
			else
				butAddLanguage.Enabled = true;
		}

		private void Bind_LanguageGrid()
		{
			grdLanguageList.DataSource = LangAPI.LanguageAdminList();
			grdLanguageList.DataBind();

			if (grdLanguageList.Items.Count == 0)
				grdLanguageList.Visible = false;
			else
				grdLanguageList.Visible = true;
		}

		private void grdLanguageList_ItemCreated(object sender, RepeaterItemEventArgs e)
		{
			if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
			{
				Lang lang = (Lang)e.Item.DataItem;
				
				if (lang.CommittedCount > 0)
				{
					LinkButton lnkCommit = (LinkButton)e.Item.FindControl("lnkCommit");
					lnkCommit.Attributes.Add("onclick", "return confirm('Commit all changes for all resources under this Language?');");
					lnkCommit.Visible = true;
					lnkCommit.CommandArgument = lang.RecordID.ToString();
					lnkCommit.CommandName = "COMMIT";
				}

				HyperLink hypLang = (HyperLink)e.Item.FindControl("hypLang");
				hypLang.NavigateUrl = "Interface.aspx?langID=" + lang.RecordID;
			}
		}

		protected void lnkCommit_Command(object source, CommandEventArgs e)
		{
			int langID = Int32.Parse(e.CommandArgument.ToString());
			LangValueAPI.Commit(UserContext.UserID, langID);
			Bind_LanguageGrid();
			
			foreach(DictionaryEntry item in Cache)
			{
				Cache.Remove(item.Key.ToString());
			}
		}


		private void butSave_Click(object sender, EventArgs e)
		{
			foreach (RepeaterItem rp in grdLanguageList.Items)
			{
				
				Lang lang = (Lang)rp.DataItem;
				CheckBox chkUser = (CheckBox)rp.FindControl("chkUser");
				CheckBox chkAdmin = (CheckBox)rp.FindControl("chkAdmin");

				
				int langID = Int32.Parse(chkUser.ToolTip);
				LangAPI.SaveShowUser(langID, chkUser.Checked, UserContext.UserID);

				if (chkAdmin.Checked == false)
				{
					langID = Int32.Parse(chkAdmin.ToolTip);
					LangAPI.SaveShowAdmin(langID, chkAdmin.Checked, UserContext.UserID);
				}
			}

			Bind_LanguageGrid();
			Bind_LanguageDropDown();
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			InitializeComponent();
			base.OnInit(e);
			Bind_LanguageDropDown();
			Bind_LanguageGrid();

		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			butAddLanguage.Click+=new EventHandler(butAddLanguage_Click);
			grdLanguageList.ItemCreated+=new RepeaterItemEventHandler(grdLanguageList_ItemCreated);
			butSave.Click+=new EventHandler(butSave_Click);
		}
		#endregion

	}
}
