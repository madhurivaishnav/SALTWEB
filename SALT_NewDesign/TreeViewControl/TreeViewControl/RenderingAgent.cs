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
	internal abstract class RenderingAgent
	{
		private TreeView _treeView;
		private string _xslt;

		protected RenderingAgent(TreeView treeView) {
			this._treeView = treeView; 
			this._xslt = "TreeStyleStandard.xslt";
		}

		protected TreeView TreeView
		{
			get { 
				return _treeView; 
			}
		}

		
		protected string Xslt
		{
			get 
			{ 
				return this._xslt; 
			}
			set
			{ 
				this._xslt= value; 
			}

		}

		public virtual void ValidateXml(string xml)
		{
			//Schema Validation
			XmlDocument doc = new XmlDocument();
			doc.LoadXml(xml);

			XmlNodeList totalNodes = doc.SelectNodes("//TreeNode");
			XmlNodeList textNodes = doc.SelectNodes("//TreeNode[@Text]");
			XmlNodeList valueNodes = doc.SelectNodes("//TreeNode[@Value]");

			if (textNodes.Count<totalNodes.Count)
				throw new  ApplicationException("All tree nodes must contain Text attribute");

			if (valueNodes.Count<totalNodes.Count)
				throw new  ApplicationException("All tree nodes must contain Value attribute");
		}


		public  virtual string GetHtml()
		{
			if (this.TreeView.TreeDoc==null)
			{
				return "";
			}

			XmlDocument xslt = new XmlDocument();
			xslt.LoadXml(Util.GetResource(this._xslt));

			XslTransform transform = new XslTransform();
			transform.Load(xslt,null,null);
   
			StringWriter sw = new StringWriter();
			transform.Transform(this.TreeView.TreeDoc, null, sw,null);
			
			string result = sw.ToString();
			
			string template = Util.GetResource("Template.txt");

			template = template.Replace("[__ClientID]", this.TreeView.ClientID).Replace("[__UniqueID]", this.TreeView.UniqueID);

			string selectedNodeIDs  =  this.GetSelectedNodes();

			template  =  template.Replace("[__SelectedNodeID]",selectedNodeIDs);

			result= template + result;

			return result;
		}


		/// <summary>
		/// Clear All Selected Nodes
		/// </summary>
		public virtual void ClearTree(string nodeID)
		{
			RemoveSubTreeAttribute(nodeID,"Selected",false);
		}


		/// <summary>
		/// Select All Nodes
		/// </summary>
		public virtual void SelectTree(string nodeID)
		{
			SetSubTreeAttribute(nodeID,"Selected",true);
		}



		/// <summary>
		/// Collapse sub tree nodes
		/// if the nodeID is not empty, collapse all nodes under this node
		/// otherwise collapse the whole tree
		/// </summary>
		/// <param name="nodeID">Starting node</param>
		public virtual void CollapseTree(string nodeID)
		{
			RemoveSubTreeAttribute(nodeID,"Expanded",false);
		}


		/// <summary>
		/// Expand sub tree nodes
		/// if the nodeID is not empty, Expand all nodes under this node
		/// otherwise Expand the whole tree
		/// </summary>
		/// <param name="nodeID">Starting node</param>
		public virtual void ExpandTree(string nodeID)
		{
			SetSubTreeAttribute(nodeID,"Expanded",false);
		}

		/// <summary>
		/// Get Selected Node IDs
		/// </summary>
		/// <returns></returns>
		public virtual string GetSelectedNodes()
		{
			XmlDocument doc = this.TreeView.TreeDoc;
			string selectedNodeIDs="";
	
			XmlNodeList nodes = doc.SelectNodes("//TreeNode[@Selected=\"true\"]");

			foreach(XmlNode node in nodes)
			{
				if (selectedNodeIDs=="")
					selectedNodeIDs =node.Attributes["ID"].Value;
				else
					selectedNodeIDs += "," + node.Attributes["ID"].Value;

			}
			
			return selectedNodeIDs;
		}
		
		/// <summary>
		/// Set Selected Nodes
		/// </summary>
		/// <param name="selectedNodeIDs"></param>
		public virtual void SetSelectedNodes(string selectedNodeIDs)
		{
			XmlDocument doc = this.TreeView.TreeDoc;
			string[] arrSelectedNodeID;

			//1. Clear old selected nodes
			XmlNodeList nodes = doc.SelectNodes("//TreeNode[@Selected]");

			foreach(XmlNode node in nodes)
			{
				node.Attributes.RemoveNamedItem("Selected");
			}

			//2. Set new selected nodes
			arrSelectedNodeID = selectedNodeIDs.Split(new char[]{','});
			foreach(string nodeID in arrSelectedNodeID)
			{
				XmlNode node = doc.SelectSingleNode("//TreeNode[@ID='" + nodeID +"']");
				if (node!=null)
				{
					XmlAttribute attrib =doc.CreateAttribute("Selected");
					attrib.Value = "true";
					node.Attributes.SetNamedItem(attrib);
				}
			}
		}

		/// <summary>
		/// Get array of selected values. This method is only available in Multiple Selection output style.
		/// </summary>
		/// <returns></returns>
		public virtual string[] GetSelectedValues()
		{
			throw new ApplicationException("This method is only available in Multiple Selection style");
		}

		/// <summary>
		/// Get the value of selected node. This method is only available in Simple Selection output style.
		/// </summary>
		/// <returns></returns>
		public virtual string GetSelectedValue()
		{
			throw new ApplicationException("This method is only available in Single Selection style");
		}


		/// <summary>
		/// Select the nodes with the specified values. This method is only available in Multiple Selection output style.
		/// </summary>
		/// <returns></returns>
		public virtual void  SetSelectedValues(string[] values)
		{
			throw new ApplicationException("This method is only available in Multiple Selection style");
		}

		/// <summary>
		/// Select the node with the specified value. This method is only available in Simple Selection output style.
		/// </summary>
		/// <returns></returns>
		public virtual void SetSelectedValue(string  value)
		{
			throw new ApplicationException("This method is only available in Single Selection style");
		}


		#region private methods
		/// <summary>
		/// Remove SubTree Attribute
		/// </summary>
		/// <param name="nodeID"></param>
		/// <param name="attributeName"></param>
		/// <param name="excludeDisabledNode"></param>
		private  void RemoveSubTreeAttribute(string nodeID, string attributeName, bool excludeDisabledNode)
		{
			XmlDocument doc = this.TreeView.TreeDoc;

			if (this.TreeView.TreeDoc!=null)
			{
				//1. Get tree nodes
				XmlNodeList nodes;
				if (nodeID!=null && nodeID.Length>0)
				{
					nodes = doc.SelectNodes("//TreeNode[@ID='" + nodeID +"']/descendant-or-self::TreeNode");
				}
				else
				{
					nodes = doc.SelectNodes("//TreeNode");
				}

				//2. remove attribute
				foreach(XmlNode node in nodes)
				{
					//Ignore disabled node
					if (excludeDisabledNode && node.Attributes["Disabled"]!=null && node.Attributes["Disabled"].Value =="true")
					{
						continue;
					}
					else
					{
						node.Attributes.RemoveNamedItem(attributeName);	
					}
				}
			}
		}

		/// <summary>
		///Set SubTree nodes Attribute to true
		/// </summary>
		/// <param name="nodeID"></param>
		/// <param name="attributeName"></param>
		/// <param name="excludeDisabledNode"></param>
		public virtual void SetSubTreeAttribute(string nodeID, string attributeName, bool excludeDisabledNode)
		{
			XmlDocument doc = this.TreeView.TreeDoc;

			if (this.TreeView.TreeDoc!=null)
			{
				//1. Get tree nodes
				XmlNodeList nodes;
				if (nodeID!=null && nodeID.Length>0)
				{
					nodes = doc.SelectNodes("//TreeNode[@ID='" + nodeID +"']/descendant-or-self::TreeNode");
				}
				else
				{
					nodes = doc.SelectNodes("//TreeNode");
				}

				//2. set attribute
				foreach(XmlNode node in nodes)
				{
					//Ignore disabled node
					if (excludeDisabledNode && node.Attributes["Disabled"]!=null && node.Attributes["Disabled"].Value =="true")
					{
						continue;
					}
					else
					{
						XmlAttribute attrib =doc.CreateAttribute(attributeName);
						attrib.Value = "true";
						node.Attributes.SetNamedItem(attrib);
					}
				}
			}
		}
		#endregion 
		

	}
}
