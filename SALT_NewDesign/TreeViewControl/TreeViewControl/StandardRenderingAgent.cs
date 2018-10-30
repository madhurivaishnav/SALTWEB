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
	/// Summary description for StandardRenderingAgent.
	/// </summary>
	internal class StandardRenderingAgent: RenderingAgent
	{
		public StandardRenderingAgent(TreeView treeView): base(treeView)
		{
			this.Xslt = "TreeStyleStandard.xslt";
		}
	}
}
