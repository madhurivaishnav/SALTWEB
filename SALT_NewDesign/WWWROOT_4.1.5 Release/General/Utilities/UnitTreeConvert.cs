using System;
using System.Web;
using System.Data;

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

namespace Bdw.Application.Salt.Web.Utilities
{
	/// <summary>
	/// Convert dataset to TreeView style xml format.
	/// </summary>
	/// <remarks>
	/// Assumptions: None
	/// Notes: 
	/// Author: Jack Liu, 26/02/2004
	/// Changes:
	/// </remarks>
	public abstract class UnitTreeConvert
	{
		/// <summary>
		/// xslt for converting raw xml to TreeView style xml
		/// </summary>
		private static string m_strXslt="";

		/// <summary>
		/// Get converting xslt
		/// </summary>
		/// <returns>xslt string</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		private static string GetXslt()
		{
			if (m_strXslt.Length==0)
			{
				XmlDocument xsltDoc = new  XmlDocument();
				xsltDoc.Load(HttpContext.Current.Server.MapPath("/General/Xslt/UnitTreeConvert.xslt"));

				m_strXslt = xsltDoc.OuterXml; 

			}

			return m_strXslt;
		}
		/// <summary>
		/// Convert dataset to TreeView style xml
		/// </summary>
		/// <param name="dataSet"></param>
		/// <returns>TreeView style xml string</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static string ConvertXml(DataSet dataSet)
		{
			//1. Get Xml
			foreach ( DataTable dt in dataSet.Tables )
			{
				foreach ( DataColumn col in dt.Columns )
				{
					col.ColumnMapping = MappingType.Attribute;
				}
			}
            XmlTextReader oXmlTextReader = new XmlTextReader(dataSet.GetXml(),XmlNodeType.Document, null);
			//XmlDataDocument xmlDoc = new XmlDataDocument(dataSet); //Too slow
            XPathDocument xmlDoc= new XPathDocument(oXmlTextReader);
			
            //2. Get xslt
			string strXslt = UnitTreeConvert.GetXslt();

			XmlDocument xsltDoc = new XmlDocument();
			xsltDoc.LoadXml(strXslt);
			//3. Convert raw xml to TreeView style xml
			XslTransform objTransform = new XslTransform();
			objTransform.Load(xsltDoc,null,null);
   
			StringWriter sw = new StringWriter();
			objTransform.Transform(xmlDoc, null, sw,null);
			
			string strResult = sw.ToString();
			
			return strResult;

		}
	}
}
