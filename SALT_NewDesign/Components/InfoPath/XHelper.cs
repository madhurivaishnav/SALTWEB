using System;
using System.Text;
using System.IO;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using System.Xml.Schema;
using System.Collections;

namespace Bdw.Application.Salt.InfoPath
{
	/// <summary>
	/// Summary description for XHelper.
	/// </summary>
	public class XHelper : IDisposable
	{
        private Hashtable m_Parameters;
        XmlDocument m_XmlDocument;
        XslTransform m_XslDocument;
        
        public XHelper(string xmlDocPath, string xslDocPath)
		{
            m_XmlDocument = new XmlDocument();
            m_XmlDocument.Load(xmlDocPath);

            m_XslDocument = new XslTransform();
            m_XslDocument.Load(xslDocPath);

            m_Parameters = new Hashtable();
		}
        public XHelper(XmlDocument xmlDocument, string xslDocPath)
        {
            m_XmlDocument = xmlDocument;
            m_XslDocument = new XslTransform();
            m_XslDocument.Load(xslDocPath);

            m_Parameters = new Hashtable();
        }
        public XHelper(XmlDocument xmlDocument, XslTransform xslDocument)
        {
            m_XmlDocument = xmlDocument;
            m_XslDocument = xslDocument;

            m_Parameters = new Hashtable();
        }


        public void AddParameter(string key, object value)
        {
            m_Parameters.Add(key,value);
        }

        public string Translate()
        {
            // Translate XML into XHTML via XSLT
            StringWriter swXml = new StringWriter();
            
            // Modify the XML file.
            XmlElement root = m_XmlDocument.DocumentElement;

            // Create an XPathNavigator to use for the transform.
            XPathNavigator nav = root.CreateNavigator();

            // Setup xml arguments
            XsltArgumentList xslArguments = new XsltArgumentList();
            foreach (DictionaryEntry objEntry in m_Parameters)
            {
                xslArguments.AddParam ( objEntry.Key.ToString() , "", objEntry.Value );
            }

            m_XslDocument.Transform(nav, xslArguments, swXml,null);

            string strContent = swXml.ToString();
            
            swXml = null;
            root = null;
            nav = null;
            m_Parameters = null;
            // Write out results
            return (strContent);
            }
        #region IDisposable Members

        public void Dispose()
        {
            if (m_Parameters != null)
            {
                m_Parameters=null;
            }
            if (m_XmlDocument != null)
            {
                m_XmlDocument=null;
            }
            if (m_XslDocument != null)
            {
                m_XslDocument=null;
            }
        }

        #endregion
    }
        

}
