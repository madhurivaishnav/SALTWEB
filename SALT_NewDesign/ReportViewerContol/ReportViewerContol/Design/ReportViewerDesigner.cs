using System;
using System.Drawing.Design;
using System.IO;
using System.Web.UI.Design;
using System.Web.UI;

namespace Bdw.SqlServer.Reporting.WebControls
{
	/// <summary>
	/// Summary description for TreeDesigner.
	/// </summary>
	public class ReportViewerDesigner: ControlDesigner
	{
        /// <summary>
        /// This returns the Design time html for the control
        /// </summary>
        /// <returns>string containing html</returns>
		public override string GetDesignTimeHtml() 
		{
//			TreeView tvw = (TreeView) this.Component;
//
//			//this.PageRegisterClientScriptBlock("TreeViewHelper", Util.GetResource("TreeViewHelper.txt"));
//
//			//Get tree Xml data for designer
//			string xml = Util.GetResource("TreeDesigner.xml");
//			//Note text for design layout
//			if (tvw.NodeText !="Node")
//				xml = xml.Replace("Text=\"Node", "Text=\"" + tvw.NodeText);
//
//			tvw.LoadXml(xml);
//
//			string html = tvw.RenderingAgent.GetHtml();

			return "Report Viewer";
		}
	}
}
