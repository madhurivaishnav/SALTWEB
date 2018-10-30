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
	/// Summary description for Util.
	/// </summary>
	internal abstract class Util
	{
		//Get Embedded Resource text by file name
		internal static string GetResource(string fileName)
		{
			Assembly assembly = Assembly.GetExecutingAssembly();
			Stream stream=assembly.GetManifestResourceStream("Uws.Framework.WebControl.Resources." + fileName);
			StreamReader reader = new StreamReader(stream);
			string text = reader.ReadToEnd();

			return text;
		}	

		internal static void SetXmlNodeID(XmlElement element, string nodeID)
		{
			XmlAttribute idAttrib =element.OwnerDocument.CreateAttribute("ID");
			idAttrib.Value = nodeID;
			element.Attributes.SetNamedItem(idAttrib);
			int position = 0;

			foreach(XmlElement child in element.ChildNodes)
			{
				position ++;
				Util.SetXmlNodeID(child, nodeID + "_" + position.ToString());
			}

		}

		internal static XmlElement CreateXmlParameter(XmlDocument doc, string name, string value)
		{
			XmlElement element = doc.CreateElement("Param");
			//Parameter Name
			XmlAttribute nameAttrib =doc.CreateAttribute("Name");
			nameAttrib.Value = name;
			element.Attributes.SetNamedItem(nameAttrib);
			//Parameter Value
			XmlAttribute valueAttrib =doc.CreateAttribute("Value");
			valueAttrib.Value = value;
			element.Attributes.SetNamedItem(valueAttrib);
			
			return element;
		}


	}
}
