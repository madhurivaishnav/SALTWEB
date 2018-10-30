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
	/// Summary description for SingleRenderingAgent.
	/// </summary>
	internal class SingleRenderingAgent: RenderingAgent
	{
		public SingleRenderingAgent(TreeView treeView): base(treeView)
		{
			this.Xslt = "TreeStyleSingle.xslt";
		}

		public override void ValidateXml(string xml)
		{
			base.ValidateXml(xml);

			XmlDocument doc = new XmlDocument();
			doc.LoadXml(xml);

			XmlNodeList selectedNodes = doc.SelectNodes("//TreeNode[@Selected=\"true\"]");

			if (selectedNodes.Count>1)
				throw new  ApplicationException("A Tree with Single Selection Style cannot have multiple nodes selected.");

		}

		/// <summary>
		/// Get Selected Node IDs
		/// </summary>
		/// <returns></returns>
		public override string GetSelectedNodes()
		{
			XmlDocument doc = this.TreeView.TreeDoc;

			//validation	
			if (this.TreeView.TreeDoc==null)
			{
				return "";
			}
			XmlNodeList selectedNodes = doc.SelectNodes("//TreeNode[@Selected=\"true\"]");
			if (selectedNodes.Count>1)
				throw new  ApplicationException("A Tree with Single Selection Style cannot have multiple nodes selected.");
				
			return base.GetSelectedNodes();
		
		}
		
		/// <summary>
		/// Set Selected Nodes
		/// </summary>
		/// <param name="selectedNodeIDs"></param>
		public override void SetSelectedNodes(string selectedNodeIDs)
		{
			if (selectedNodeIDs.IndexOf(",")>0)
			{
				throw new  ApplicationException("A Tree with Single Selection Style cannot have multiple nodes selected.");
			}

			base.SetSelectedNodes(selectedNodeIDs);
		}


		public override string GetSelectedValue()
		{
			XmlDocument doc = this.TreeView.TreeDoc;
			string selectedValue="";
	
			if (this.TreeView.TreeDoc!=null)
			{
				XmlNodeList nodes = doc.SelectNodes("//TreeNode[@Selected=\"true\"]");

			
				if (nodes.Count>0)
				{
					//Get the last selected node
					//Normally there is only one selected node, If there are multiple selected nodes, there is possible something wrong
					selectedValue = nodes[nodes.Count-1].Attributes["Value"].Value;
				}
				else
				{
					selectedValue = "";
				}
			}

			return selectedValue;
		}

		/// <summary>
		/// Select the node with the specified value. This method is only available in Simple Selection output style.
		/// </summary>
		/// <returns></returns>
		public override void SetSelectedValue(string  value)
		{
			XmlDocument doc = this.TreeView.TreeDoc;
			string selectedNodeID="";
	
			if (this.TreeView.TreeDoc!=null)
			{
				XmlNodeList nodes = doc.SelectNodes("//TreeNode[@Value='" + value +"']");

				if (nodes.Count>0)
				{
					//Set the last node
					//Normally there is only one selected node, If there are multiple selected nodes, there is possible something wrong
					selectedNodeID = nodes[nodes.Count-1].Attributes["ID"].Value;
				}
				else
				{
					selectedNodeID = "";
				}

				this.SetSelectedNodes(selectedNodeID);
			}
		}
	}
}
