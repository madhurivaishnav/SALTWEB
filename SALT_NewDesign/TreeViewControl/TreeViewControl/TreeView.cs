using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

using System.Web.UI.Design; 
using System.Drawing;


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
	/// Tree Output Style
	/// </summary>
    [Serializable()]
    public enum TreeOutputStyle
	{
		/// <summary>
		/// Standard output
		/// </summary>
		Standard = 1,
		/// <summary>
		/// Single node selection mode (Radio Button)
		/// </summary>
		SingleSelection = 2,
		/// <summary>
		/// Multiple node selection mode (Checkbox)
		/// </summary>
		MultipleSelection = 3
	}

	/// <summary>
	/// TreeView class: Represents a tree.
	/// </summary>
   
	[
	ParseChildren(false),
	ToolboxData("<{0}:TreeView runat=server></{0}:TreeView>"),
	Designer(typeof(TreeDesigner)),
	ToolboxBitmap(typeof(Uws.Framework.WebControl.TreeView),"Uws.Framework.WebControl.TreeView.bmp")
	]
	public class TreeView : Control, INamingContainer, IPostBackEventHandler, IPostBackDataHandler
	{
		private XmlDocument _treeDoc;
		private RenderingAgent _renderingAgent=null;

		#region properties
		internal XmlDocument TreeDoc
		{ 
			get  
			{ 
				return this._treeDoc;
			} 
			set 
			{ 
				this._treeDoc = value;
			} 

		} 

        /// <summary>
        /// Gets and Set the SystemImagesPath
        /// </summary>
		[
		Browsable(true), 
		Description("Path to the folder containing +/- and lines images"), 
		DefaultValue("/Images/TreeView/"), 
		Category("Data") 
		] 
		public string  SystemImagesPath
		{ 
			get  
			{ 
				return (string)ViewState["SystemImagesPath"];
			} 
			set
			{
				ViewState["SystemImagesPath"]=value;
			} 
		} 

		/// <summary>
		/// Gets and Sets the OutputStyle
		/// </summary>
		[
		Browsable(true), 
		Description("The output style of the TreeView"), 
		DefaultValue(TreeOutputStyle.Standard),
		Category("Behavior")
		] 
		public TreeOutputStyle OutputStyle
		{ 
			get  
			{ 
				return (TreeOutputStyle)ViewState["OutputStyle"];
			} 
			set
			{
				ViewState["OutputStyle"]=value;
				this._renderingAgent=null;
			} 
		} 

		internal RenderingAgent RenderingAgent
		{ 
			get  
			{ 
				if (this._renderingAgent==null)
				{
					switch(this.OutputStyle)
					{
						case TreeOutputStyle.Standard:
							this._renderingAgent = new StandardRenderingAgent(this);
							break;
						case TreeOutputStyle.SingleSelection:
							this._renderingAgent = new SingleRenderingAgent(this);
							break;
						case TreeOutputStyle.MultipleSelection:
							this._renderingAgent = new MultipleRenderingAgent(this);
							break;
						default:
							throw new ArgumentException("Invalid TreeOutputStyle");
					}
				}

				return this._renderingAgent;
			} 
		} 

        /// <summary>
        /// The CssClass for the TreeNode
        /// </summary>
		[
		Browsable(true), 
		Description("The CssClass for the TreeNode"), 
		DefaultValue(null), 
		Category("Appearance") 
		] 
		public string  CssClass
		{ 
			get  
			{ 
				return (string)ViewState["CssClass"];
			} 
			set
			{
				ViewState["CssClass"]=value;
			} 
		} 

        /// <summary>
        /// Number of pixels to indent the tree at each level
        /// </summary>
		[
		Browsable(true), 
		Description("Number of pixels to indent the tree at each level"), 
		DefaultValue(20), 
		Category("Appearance") 
		] 
		public int  Indent
		{ 
			get  
			{ 
					return (int)ViewState["Indent"];
			} 
			set
			{

				ViewState["Indent"]=value;
			} 
		} 

        /// <summary>
        /// The node text to show in design mode
        /// </summary>
		[
		Browsable(true), 
		Description("The node text to show in design mode"), 
		DefaultValue("Node"), 
		Category("Appearance") 
		]
		public string  NodeText
		{ 
			get  
			{ 
				return (string)ViewState["NodeText"];
			} 
			set
			{
				ViewState["NodeText"]=value;
			} 
		} 

		#endregion

		#region Contructors
        /// <summary>
        /// Base constructor
        /// </summary>
		public TreeView():base()
		{
			ViewState["SystemImagesPath"]="/Images/TreeView/";
			ViewState["NodeText"]="Node";
			ViewState["Indent"]=20;
			ViewState["CssClass"]="";
			ViewState["OutputStyle"] = TreeOutputStyle.Standard;
		}

		/*
		protected override void OnInit(EventArgs e)
		{
			base.OnInit(e);
		}
		*/

		#endregion

		#region Control evnet handler
		/// <summary>
		///Customize state management to handle saving state of contained objects. 
		/// </summary>
		/// <param name="savedState"></param>
		protected override void LoadViewState(object savedState)
		{
			if (savedState != null) 
			{
				object[] state = (object[])savedState;

				//Other view states by using viewstate bag
				if (state[0] != null)
				{
					base.LoadViewState(state[0]);
				}
				//Load the TreeView from the view state XML
				if (state[1] != null)
				{
					string xml = state[1].ToString();
					this._treeDoc =  new XmlDocument();
					this._treeDoc.LoadXml(xml);
				}
			}
		}

        /// <summary>
        /// Loads the posted data
        /// </summary>
        /// <param name="postDataKey"></param>
        /// <param name="values"></param>
        /// <returns></returns>
		public  bool LoadPostData(string postDataKey, NameValueCollection values) 
		{
			string selectedNodeIDs; 

			selectedNodeIDs =  values[postDataKey];
			if (this._treeDoc!=null)
			{
				this.RenderingAgent.SetSelectedNodes(selectedNodeIDs);
			}

			return true;
		}

        /// <summary>
        /// Overrides the base CreateChildControls
        /// </summary>
		protected override void CreateChildControls() 
		{
			if (this.Visible && this._treeDoc!=null)
			{
				//Call base class
				base.CreateChildControls();
			
				this.Page.GetPostBackEventReference(this,"");

				if (!Page.IsStartupScriptRegistered("TreeViewHelper"))
				{
					this.Page.RegisterClientScriptBlock("TreeViewHelper", Util.GetResource("TreeViewHelper.txt"));
					
					SmartNav smartNav = new SmartNav();
   
					this.Controls.Add(smartNav);
				}
			}

		}

        /// <summary>
        /// Dummy Event
        /// </summary>
		public void RaisePostDataChangedEvent() 
		{
			
		}



		/// <summary>
		/// Handle the event of node  clicking
		/// </summary>
		/// <param name="eventArgument"></param>
		public void RaisePostBackEvent(String eventArgument)
		{
			XmlNode node;
			string[] arg= eventArgument.Split(new char[]{':'});
			string nodeID,action;
			nodeID= arg[0];
			action = arg[1];
			

			//Tree action: expand all or collapse all
			if (nodeID=="")
			{
				switch(action)
				{
					case "Expand":
						this.ExpandTree();
						break;
					case "Collapse":
						this.CollapseTree();
						break;
					case "Select":
						this.RenderingAgent.SelectTree("");
						break;
					case "Clear":
						this.RenderingAgent.ClearTree("");
						break;
				}
			}
			//Node action
			else
			{
				node = this._treeDoc.SelectSingleNode("//TreeNode[@ID='" + nodeID +"']");
				if (node!=null)
				{
					switch(action)
					{
						case "Expand":
							XmlAttribute attrib =_treeDoc.CreateAttribute("Expanded");
							attrib.Value = "true";
							node.Attributes.SetNamedItem(attrib);
							break;
						case "Collapse":
							node.Attributes.RemoveNamedItem("Expanded");
							break;
						//Select sub tree
						case "Select":
							this.RenderingAgent.SelectTree(nodeID);
							break;
						//Clear sub tree
						case "Clear":
							this.RenderingAgent.ClearTree(nodeID);;
							break;
					}
				}
			}		
		}



        /// <summary>
        /// overrides the OnPreRender event
        /// </summary>
        /// <param name="e">Event arguments.</param>
		protected override void OnPreRender(EventArgs e)
		{
			base.OnPreRender(e);
			//this.Page.SmartNavigation = true;
		}


		
		/// <summary>
		/// Customize state management to handle saving state of contained objects. 
		/// </summary>
		/// <returns></returns>
		protected override object SaveViewState()
		{
			object baseState = base.SaveViewState();

			object[] state = new object[2];
			//Other view states by using viewstate bag
			state[0] = baseState;
			//Turn the treeview into XML
			if (this._treeDoc!=null)
			{
				state[1] = this._treeDoc.OuterXml;
			}

			return state;
		}



		/// <summary>
		/// Render this control to the output parameter specified.
		/// </summary>
		/// <param name="output"> The HTML writer to write out to </param>
		protected override void Render(HtmlTextWriter output)
		{
			if (this.Visible)
			{
				string result = this.RenderingAgent.GetHtml();
			
				output.Write(result);
			}
		}
		#endregion

		#region Public Methods

		/// <summary>
		/// Loads the XML tree document from the specified data string.
		/// </summary>
		/// <param name="xml">String containing the XML document to load. </param>
		public void LoadXml(string xml)
		{
			
			if (xml.Length==0)
			{
				return;
			}
			
			this.RenderingAgent.ValidateXml(xml);

			XmlDocument doc = new XmlDocument();
			doc.LoadXml(xml);
			
			Util.SetXmlNodeID(doc.DocumentElement, "ID");

			this.AddCustomParameters(doc);
			
			this.TreeDoc = doc;

		}

        /// <summary>
        /// Convert xml data  with the xslt to standard xml tree document.
        /// </summary>
        /// <param name="xml">String containing the XML document to load. </param>
        /// <param name="xslt">String containing the xslt document for converting. </param>
		public void LoadXml(string xml, string xslt)
		{

			XmlDocument xmlDoc = new XmlDocument();
			xmlDoc.LoadXml(xml);

			XmlDocument xsltDoc = new XmlDocument();
			xsltDoc.LoadXml(xslt);

			XslTransform transform = new XslTransform();
			transform.Load(xsltDoc,null,null);
   
			StringWriter sw = new StringWriter();
			transform.Transform(xmlDoc, null, sw,null);
			
			string result = sw.ToString();
			
			this.LoadXml(result);

		}



		/// <summary>
		/// Clear Selected Nodes
		/// </summary>
		public  void ClearSelection()
		{
			this.RenderingAgent.ClearTree("");
		}

		/// <summary>
		/// Expand whole tree
		/// </summary>
		public  void ExpandTree()
		{
			this.RenderingAgent.ExpandTree(null); 
		}

		/// <summary>
		/// Collapse whole tree
		/// </summary>
		public  void CollapseTree()
		{
			this.RenderingAgent.CollapseTree(null);
		}

		/// <summary>
		/// Expand sub tree nodes
		/// </summary>
		public  void ExpandTree(string parentNodeID)
		{
			this.RenderingAgent.ExpandTree(parentNodeID); 
		}

		/// <summary>
		/// Collapse sub tree nodes
		/// </summary>
		public  void CollapseTree(string parentNodeID)
		{
			this.RenderingAgent.CollapseTree(parentNodeID);
		}


		#region Multiple Selection output style
		/// <summary>
		/// Get array of selected values. This method is only available in Multiple Selection output style.
		/// </summary>
		/// <returns></returns>
		public string[]  GetSelectedValues()
		{ 
				return this.RenderingAgent.GetSelectedValues();
		} 

		/// <summary>
		/// Select the nodes with the specified values. This method is only available in Multiple Selection output style.
		/// </summary>
		/// <returns></returns>
		public void  SetSelectedValues(string[] values)
		{ 
			this.RenderingAgent.SetSelectedValues(values);
		} 

		#endregion

		#region Single Selection output style
		/// <summary>
		/// Get the value of selected node. This method is only available in  Single Selection output style.
		/// </summary>
		/// <returns></returns>
		public string  GetSelectedValue()
		{ 
				return this.RenderingAgent.GetSelectedValue();
		} 

		/// <summary>
		/// Select the node with the specified value. This method is only available in Single Selection output style.
		/// </summary>
		/// <returns></returns>
		public void SetSelectedValue(string  value)
		{ 
			this.RenderingAgent.SetSelectedValue(value);
		} 
		#endregion

		#endregion

		#region private methods
		private void AddCustomParameters(XmlDocument doc)
		{
			// Add Custom Parameters.
			XmlElement parameters = doc.CreateElement("CustomParameters");
			// Image Path
			XmlElement imagePath = Util.CreateXmlParameter(doc,"SystemImagesPath",this.SystemImagesPath);
			parameters.AppendChild(imagePath);
			//Control ID
			XmlElement controlID =  Util.CreateXmlParameter(doc,"TreeViewControlID",this.UniqueID);
			parameters.AppendChild(controlID);
			//Node cssClass			
			string css = this.CssClass;
			if (css==null || css=="")
			{
				css="TreeView_Node";
			}
			XmlElement cssClass =  Util.CreateXmlParameter(doc,"CssClass",css);
			parameters.AppendChild(cssClass);
			//Node Indent
			int indent = this.Indent;
			if (indent<=1)
			{
				indent = 20;
			}

			XmlElement indentParam =  Util.CreateXmlParameter(doc,"Indent",indent.ToString());
			parameters.AppendChild(indentParam);

			doc.DocumentElement.AppendChild(parameters);
		}
		#endregion
	}
}
