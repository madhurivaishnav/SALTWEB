/*	Keeping Scroll Position over post Backs
	http://aspalliance.com/356
	http://aspnet.4guysfromrolla.com/articles/111704-1.aspx
	
	Due to a lots of issue reported for the ASP.NET SmartNavigation, here is another alternative, and works for other browsers such as Firefox, netscape
 */

using System;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;


namespace Uws.Framework.WebControl
{
	/// <summary>
	/// 
	/// </summary>
	[ToolboxData("<{0}:SmartNav runat=server />")]
	public class SmartNav : Control 
	{
		private const string SaveScriptName = "StaticPostBackScrollPositionSave";
		private const string LoadScriptName = "StaticPostBackScrollPositionLoad";
		private const string VerticalPositionFieldName = "StaticPostBackScrollVerticalPosition";
		private const string HorizontalPositionFieldName = "StaticPostBackScrollHorizontalPosition";
		private const string ScriptHiddenField = "document.forms[0].{0}.value";
		private const string ScriptGetPositionLine = ScriptHiddenField + " = (navigator.appName == 'Netscape') ? window.page{1}Offset : document.body.scroll{2};";

		private string GetSavePositionScript() 
		{
			StringBuilder sb = new StringBuilder();

			sb.Append("<script language=\"JavaScript\"> \n");
			sb.Append("function SaveScrollPositions() { \n");
			sb.AppendFormat(ScriptGetPositionLine, VerticalPositionFieldName, "Y", "Top");
			sb.AppendFormat(ScriptGetPositionLine, HorizontalPositionFieldName, "X", "Left");
			sb.Append("setTimeout('SaveScrollPositions()', 10);");
			sb.Append("} \n");
			sb.Append("SaveScrollPositions(); \n");
			sb.Append("</script> \n");

			return sb.ToString();
		}

		private string GetLoadPositionScript() 
		{
			StringBuilder sb = new StringBuilder();
			string script = String.Format("scrollTo({0},{1}); \n", String.Format(ScriptHiddenField,
				HorizontalPositionFieldName), String.Format(ScriptHiddenField, VerticalPositionFieldName));

			sb.Append("<script language=\"JavaScript\"> \n");
			sb.Append("function RestoreScrollPosition() { \n");
			sb.AppendFormat("scrollTo({0},{1}); \n", Page.Request[HorizontalPositionFieldName],
				Page.Request[VerticalPositionFieldName]);
			sb.Append("} \n window.onload = RestoreScrollPosition; \n");
			sb.Append("</script>");

			return sb.ToString();
		}
/// <summary>
/// 
/// </summary>
/// <param name="e"></param>
		protected override void OnPreRender(EventArgs e) 
		{
			if ((Page.IsPostBack) && (!Page.IsStartupScriptRegistered(LoadScriptName)))
				Page.RegisterClientScriptBlock(LoadScriptName, GetLoadPositionScript());

			if (!Page.IsStartupScriptRegistered(SaveScriptName)) 
			{
				Page.RegisterClientScriptBlock(SaveScriptName, GetSavePositionScript());
				Page.RegisterHiddenField(VerticalPositionFieldName, "0");
				Page.RegisterHiddenField(HorizontalPositionFieldName, "0");
			}
		}
	}
}
