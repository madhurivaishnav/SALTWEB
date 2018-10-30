using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

using System.Web.UI.Design; 

using System.Collections;
using System.Collections.Specialized;

using System.Threading; 
using System.Globalization; 
using System.ComponentModel;

using System.Reflection;
using System.IO;
using System.Net;

using System.Configuration;

using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using System.Xml.Schema;


namespace Uws.Framework.WebControl
{
	/// <summary>
	/// Summary description for MultipleRenderingAgent.
	/// </summary>
	internal class MultipleRenderingAgent: RenderingAgent
	{
		public MultipleRenderingAgent(TreeView treeView): base(treeView)
		{
			this.Xslt = "TreeStyleMultiple.xslt";
		}

		public override void ValidateXml(string xml)
		{
			base.ValidateXml(xml);
		}

		/// <summary>
		/// Get Selected Node IDs
		/// </summary>
		/// <returns></returns>
		public override string GetSelectedNodes()
		{
			return base.GetSelectedNodes(); 
		}
		
		/// <summary>
		/// Set Selected Nodes
		/// </summary>
		/// <param name="selectedNodeIDs"></param>
		public override void SetSelectedNodes(string selectedNodeIDs)
		{
			base.SetSelectedNodes(selectedNodeIDs);
		}


		public override string[] GetSelectedValues()
		{

			XmlDocument doc = this.TreeView.TreeDoc;
			string[] selectedValues=new string[0];
			int index=0;

			if (this.TreeView.TreeDoc!=null)
			{
				XmlNodeList nodes = doc.SelectNodes("//TreeNode[@Selected=\"true\"]");

				selectedValues = new string[nodes.Count];

				foreach(XmlNode node in nodes)
				{
					selectedValues[index] = node.Attributes["Value"].Value;
					index++;
				}
			}
			
			return selectedValues;
		}

		/// <summary>
		/// Select the nodes with the specified values. This method is only available in Multiple Selection output style.
		/// </summary>
		/// <returns></returns>
		public override void  SetSelectedValues(string[] values)
		{ 
			XmlDocument doc = this.TreeView.TreeDoc;
			string selectedNodeIDs="";

			if (this.TreeView.TreeDoc!=null)
			{
				foreach(string value in values)
				{
					XmlNodeList nodes = doc.SelectNodes("//TreeNode[@Value='" + value +"']");

					foreach(XmlNode node in nodes)
					{
						if 	(selectedNodeIDs=="")
						{
							selectedNodeIDs = node.Attributes["ID"].Value;
						}
						else
						{
							selectedNodeIDs += "," + node.Attributes["ID"].Value;
						}
					}
				}
				this.SetSelectedNodes(selectedNodeIDs);
			}
		} 


	}

}
