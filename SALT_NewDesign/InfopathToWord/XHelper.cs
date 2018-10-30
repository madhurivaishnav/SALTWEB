using System;
using System.Text;
using System.IO;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using System.Xml.Schema;
using System.Collections;

namespace InfopathToWord
{
	/// <summary>
	/// Summary description for XHelper.
	/// </summary>
	public class XHelper
	{
        private string m_XmlDocument;
        private string m_XslDocument;
        private string m_strOutputFileName;

        private Hashtable m_Parameters;
        public XHelper(string xmlDocPath, string xslDocPath, string outputFileName)
		{
            m_XmlDocument = xmlDocPath;
            m_XslDocument = xslDocPath;
            m_strOutputFileName  = outputFileName;

            m_Parameters = new Hashtable();
		}

        public void AddParameter(string key, object value)
        {
            m_Parameters.Add(key,value);
        }

        public void Translate()
        {
            // Translate XML into XHTML via XSLT
            StringWriter swXml = new StringWriter();
            
            XmlDocument doc = new XmlDocument();
            
            doc.Load(m_XmlDocument);
            
            // Modify the XML file.
            XmlElement root = doc.DocumentElement;

            // Create an XPathNavigator to use for the transform.
            XPathNavigator nav = root.CreateNavigator();

            // Transform the file.
            XslTransform xslt = new XslTransform();
            xslt.Load(m_XslDocument);
            
            // Setup xml arguments
            XsltArgumentList xslArguments = new XsltArgumentList();
            foreach (DictionaryEntry objEntry in m_Parameters)
            {
                xslArguments.AddParam ( objEntry.Key.ToString() , "", objEntry.Value );
            }

            xslt.Transform(nav, xslArguments, swXml,null);

            // Write out results
            XmlDocument objDoc = new XmlDocument();
            objDoc.InnerXml = swXml.ToString();
            objDoc.Save(m_strOutputFileName);

        }
        private void Validate()
        {
            if (File.Exists(m_XmlDocument))
            {
                throw new FileNotFoundException("Cannot find the specified XML Document",m_XmlDocument);
            }
            if (File.Exists(m_XslDocument))
            {
                throw new FileNotFoundException("Cannot find the specified XSL Document",m_XslDocument);
            }
        }
    }
        

}
