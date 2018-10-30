using System;
using System.Data;

using System.Collections;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using System.Xml.Schema;
using System.IO;
using System.Drawing;
using Localization;
namespace Bdw.Application.Salt.InfoPath
{
	/// <summary>
	/// This class accepts an info path xml file and generates an xml file necessary for use in salt.
	/// It adds guids to all elements
	/// It extracts the images as gif's and replaces their base64 text with a file name.
	/// </summary>
	public class Importer
	{
        #region Private Member Variables
        private XmlDocument m_Document;

		/// <summary>
		/// This needs to be the full path to where the Infopath system files are located
		/// ie.D:\Work\Salt v3.0\Source\WebSite\General\InfoPath\
		/// </summary>
		private string m_strSystemPath;

		/// <summary>
        /// This needs to be the full path to the directory where new file are to be written.
        /// ie. D:\Work\Salt v3.0\Source\WebSite\General\InfoPath\Publishing\af71cbe7-55f5-46e1-b724-a3d3090062e2\
        /// </summary>
        private string m_strOutputPath;
        #endregion
		
        #region Constructor
        /// <summary>
        /// Constructor that accepts the info path file as its only parameter
        /// </summary>
        /// <param name="document">The InfoPath generated XML File</param>
        public Importer(XmlDocument document)
		{
			m_Document = document;
		}
        #endregion

        #region Public Methods

        /// <summary>
        /// Performs all necessary steps to convert an infopath xml data file
        /// into the necessary type requried by salt.
        /// </summary>
        /// <param name="outputPath">Writes out all generated files to the output path. </param>
        /// <param name="translationPath">Finds the necessary XSLTs in the translation path</param>
        public void Convert(string physicalSystemPath, string physicalOutputPath)
        {
			m_strSystemPath = physicalSystemPath;
			m_strOutputPath = physicalOutputPath;

            // Removes inactive pages.
            RemoveInactivePages();

            // Adds an GUID attribute to every element
            AddGUIDs();

            // Strips out the base64 encoded images and saves them to the images directory.
            SaveImages();

            // Renders each of the individual widgets and places html back in to the xml document
            AddXHTML();

            // Copies the defaultLesson.aspx page or the defaultQuiz.aspx page to the output directory.
            CopyTemplate();

            // Translates the input file and generates the bdw upload file.
            GenerateBDWUploadFile();

			/// Saves the newly generated data file
			SaveDataFile();
			
        }

        #endregion

		#region private methods
		#region Remove Inactive Pages
		/// <summary>
		/// Removes all pages that are inactive
		/// </summary>
		private void RemoveInactivePages()
		{
			// For Lesson, Path: /BDWInfoPathLesson/Pages/Page
			// For Quiz, Path: 
			//		/BDWInfoPathQuiz/Introduction/Page
			//		/BDWInfoPathQuiz/Questions/Page
			//		/BDWInfoPathQuiz/Complete/Page

			// Get inactive pages
			XmlNodeList objPages = m_Document.DocumentElement.SelectNodes("*/Page[IsActive='false']");

			foreach (XmlNode objNode in objPages)
			{
				// Remove all trace of this node by removing it as a child from its parent node
				objNode.ParentNode.RemoveChild(objNode);
			}
		}
		#endregion

        #region Add Identifiers
		/// <summary>
		/// Add GUIDS to each element in the xml document
		/// </summary>
		private void AddGUIDs()
		{
			//Start from root element
			this.AddGUIDs(this.m_Document.DocumentElement);
		}	

        /// <summary>
        /// Recursive function to add GUIDS to each element in the xml document
        /// </summary>
        /// <param name="node">Node to start at</param>
        private void AddGUIDs(XmlNode node)
        {
			if (node is XmlElement)
			{
				// Add an Attribute called GUID
				XmlAttribute objAttribute = node.OwnerDocument.CreateAttribute("GUID");

				// Generate a new GUID value for it
				objAttribute.Value = Guid.NewGuid().ToString();

				node.Attributes.Append(objAttribute);

				foreach (XmlNode objNode in node.ChildNodes)
				{
					AddGUIDs(objNode);
				}
            }
        }
        #endregion

		#region Extract Images
		/// <summary>
		/// Extracts all images and saves them as gif files
		/// </summary>
		private void SaveImages()
		{
			// Get all images
			XmlNodeList objImages = m_Document.DocumentElement.SelectNodes("//Image[.!='']");

			foreach (XmlNode objNode in objImages)
			{
				//Convert the embedded image to a gif file 
				string strImage = objNode.InnerText;
				if (strImage.Length>0)
				{
					// Get the image
					byte[] bImage = System.Convert.FromBase64String(strImage);
					MemoryStream objMemoryStream = new MemoryStream();
					objMemoryStream.Write( bImage, 0, bImage.Length );

					// Convert it to an image
					Image objImage = Image.FromStream ( objMemoryStream );
                        
					// Give it a new filename
					string strFileName = "Images/" + Guid.NewGuid().ToString() + ".gif";
					string strFullFileName = Path.Combine(this.m_strOutputPath, strFileName);
                        
					// Save the gif in the images directory
					objImage.Save ( strFullFileName );

					// Replace the nodes text with the filename.
					objNode.InnerText = strFileName;
				}
			}
		}
		#endregion

        #region Add XHTML
		/// <summary>
		/// Renders each of the individual widgets and places html back in to the xml document
		/// </summary>
        private void AddXHTML()
        {
            XmlNodeList objNodeList = m_Document.SelectNodes("//PageElement/*");
            foreach (XmlNode objPageElement in objNodeList)
            {
                    //System.Diagnostics.Debug.WriteLine("objNode:" + objNode.Name);
                    GenerateXHTML(objPageElement);
            }
        }

        /// <summary>
        /// This method takes an xml node, uses an xslt translation to translate it to xhtml
        /// and then replaces the nodes text with the result
        /// Node: The xslt used is of the same name as the Page Element's name.
        /// </summary>
        /// <param name="node"></param>
        private void GenerateXHTML(XmlNode node)
        {
            XHelper objHelper;
            XmlDocument objXmlPageElementDoc;
            XslTransform objXslTransform;
           
            objXmlPageElementDoc = new XmlDocument();
            objXslTransform = new XslTransform();
            
            // Get xml to be translated and path to translation file
            string strXml;
			XmlNode dataNode;
			switch (node.Name)
			{
				case "TOC":
					dataNode = m_Document.DocumentElement;
					break;
				case "ShowAllPlayers":
					dataNode = m_Document.DocumentElement.SelectSingleNode("Players");
					break;
				case "MeetThePlayer":
					dataNode = m_Document.DocumentElement.SelectSingleNode("Players/Player[@ID='" + node.Attributes["ID"].Value +"']");
					break;
				default:
					dataNode = node;	
					break;
			}

	        strXml = dataNode.OuterXml;

			string strTranslationFile = m_strSystemPath + "PageElements\\" + node.Name + ".xslt";

            // load the xml and xsl
            objXmlPageElementDoc.LoadXml(strXml);
            objXslTransform.Load (strTranslationFile);
            
            // Use the xhelper object to perform the translation
            objHelper = new XHelper( objXmlPageElementDoc, objXslTransform );

            // Needs to be embedded in a CDATA section to enable javascript to work
            node.InnerXml = " <![CDATA[" + objHelper.Translate() + "]]>";
        }

        #endregion

        #region Copy Template to Content
        /// <summary>
        /// Copies TemplateLesson.aspx if the content is a lesson
        /// Copies TemplateQuiz.aspx if the content is a lesson
        /// This is the file that the user actually hits when sitting a lesson or quiz
        /// </summary>
        private void CopyTemplate()
        {
            string strSourceFile; 
            string strDestinationFile;

            // The destination file is called "default.aspx" regardless
            strDestinationFile = m_strOutputPath + "default.aspx";
            if (IsLesson())
            {
                strSourceFile = m_strSystemPath + "Rendering\\TemplateLesson.aspx";
            }
            else
            {
                strSourceFile = m_strSystemPath + "Rendering\\TemplateQuiz.aspx";
            }
			//Before copy, remove readonly from the source file
			

            File.Copy(strSourceFile, strDestinationFile);
			File.SetAttributes(strDestinationFile, System.IO.FileAttributes.Normal);
        }
        #endregion

        #region Generate BDW Upload XML File
        private void GenerateBDWUploadFile()
        {
            XHelper objHelper;
           
            XmlDocument objXml = new XmlDocument();
            XslTransform objXsl = new XslTransform();
            
            // Get xml to be translated and path to tralsation file
            string strXml = m_strOutputPath + "InfoPathContent.xml";
            string strXsl;
            if (IsLesson())
            {
                // XSL for translation an infopath lesson to a BDW_UploadSaltContent.xml file
                strXsl = m_strSystemPath + "Conversion\\Convert_Lesson.xslt";
            }
            else
            {
                // XSL for translation an infopath quiz to a BDW_UploadSaltContent.xml file
                strXsl = m_strSystemPath + "Conversion\\Convert_Quiz.xslt";
            }

            // load the xml and xsl
            objXml.Load (strXml);
            objXsl.Load (strXsl);
            
            // Use the xhelper object to perform the translation
            objHelper = new XHelper( objXml, objXsl );
            
            XmlDocument objNewDocument = new XmlDocument();
            objNewDocument.InnerXml = objHelper.Translate();

            // Write the output file
            string strOutputFile = m_strOutputPath + "\\BDW_UploadSaltContent.XML";
            FileStream fsBDWUploadFile = new FileStream(strOutputFile,FileMode.Create);

            // Save it
            objNewDocument.Save(fsBDWUploadFile);

            //Flush it and close it
            fsBDWUploadFile.Flush();
            fsBDWUploadFile.Close();

        }
        #endregion

		/// <summary>
		/// Saves the newly generated data file
		/// </summary>
		private void SaveDataFile()
		{
			m_Document.Save(m_strOutputPath + "data.xml");
            
		}


		/// <summary>
		/// Checks if a piece of content being uploaded is a lesson or a quiz
		/// </summary>
		/// <returns>True for lesson, false for quiz</returns>
		private bool IsLesson()
		{
			// Check for the presence of the lesson tag 
			if (m_Document.SelectSingleNode("/BDWInfoPathLesson") != null)
			{
				return true;
			}
			// Check for the presence of the quiz tag 
			if (m_Document.SelectSingleNode("/BDWInfoPathQuiz") != null)
			{
				return false;
			}
            
			// neither was found
			throw new Exception(ResourceManager.GetString("Importer.cs.IsLesson"));
		}
		private bool IsQuiz()
		{
			return !IsLesson();
		}


		#endregion
        
        
	}
}
