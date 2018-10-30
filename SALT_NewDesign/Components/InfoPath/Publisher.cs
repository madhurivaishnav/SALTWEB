using System;
using System.Data;

using System.Collections;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using System.Xml.Schema;
using System.IO;
using System.Drawing;

namespace Bdw.Application.Salt.InfoPath
{
	/// <summary>
	/// This class provides additional methods to assist with the publishing process
	/// </summary>
	public class Publisher
	{
        public static string TranslationPath;
        
        #region Static Methods

        /// <summary>
        /// Returns an array list of all directories within the Styles directory 
        /// to allow a use to choose a style with which to publish their content
        /// </summary>
        /// <param name="path">Path to search</param>
        /// <returns></returns>
        public static ArrayList GetStyles(string path)
        {
            ArrayList aStyles = new ArrayList();
            DirectoryInfo objDirInfo = new DirectoryInfo(path);
            foreach (DirectoryInfo objDirectory in objDirInfo.GetDirectories())
            {
                aStyles.Add(objDirectory.Name);
            }
            return aStyles;
        }

        /// <summary>
        /// Returns an array list of all xslt files within the Layouts directory 
        /// to allow a use to choose a layout with which to publish their content
        /// Files that begin with an underscore are ignored.
        /// </summary>
        /// <param name="path">Path to search</param>
        /// <returns></returns>
        public static ArrayList GetLayouts(string path)
        {
            ArrayList aLayouts = new ArrayList();
            DirectoryInfo objDirInfo = new DirectoryInfo(path);
            foreach (FileInfo objFile in objDirInfo.GetFiles("*.xslt"))
            {
                if (!objFile.Name.StartsWith("_"))
                {
                    aLayouts.Add(Path.GetFileNameWithoutExtension(objFile.Name));
                }
            }
            return aLayouts;
        }


		/// <summary>
		/// Get Pages for layout design
		/// </summary>
		/// <param name="xmlFile">The InfoPath xml file</param>
		/// <returns></returns>
		public static DataTable GetPages(string xmlFile)
		{
			string strID;
			string strTitle;
			string strPageType;

			//1. Get the xml document
			XmlDocument objDocument = new XmlDocument();
			objDocument.Load(xmlFile);
			//objDocument.Load( path + "InfoPathContent.xml" );

			// Setup the datatable with an ID and Title column for returning
			DataTable dtbPages = new DataTable();
			dtbPages.Columns.Add("ID",typeof(string));
			dtbPages.Columns.Add("Title",typeof(string));
			dtbPages.Columns.Add("PageType",typeof(string));
                
			XmlNodeList objNodeList = objDocument.DocumentElement.SelectNodes("*/Page[@IsActive='true']");

			foreach (XmlNode objPage in objNodeList)
			{
				strPageType = objPage.ParentNode.Name;

				// if the page is a question
				if (strPageType == "Questions")
				{
					// get the title from the question text

					strTitle = objPage["PageElements"]["PageElement"]["Question"]["Description"].FirstChild.InnerText;
                    if (strTitle.Length>60)
                    {
                        strTitle = strTitle.Substring(0,60) + "...";
                    }
				}
				else
				{
					// else use the title element itself
					strTitle = objPage["Title"].InnerText;
				}
				strID = objPage.Attributes["ID"].Value;
                        
				dtbPages.Rows.Add(new object[]{strID, strTitle, strPageType});
			}
			return dtbPages;
		}


        #endregion
        
	}
}
