using System;
using System.Data;
using System.Xml;
using System.Configuration;

using Bdw.Application.Salt.BusinessServices;
using Bdw.Application.Salt.ErrorHandler;
using Bdw.Application.Salt.Data;

namespace Bdw.Application.Salt.Utilities
{
	/// <summary>
	/// Summary description for ImportUsers.
	/// </summary>
	public class ImportToolbook : XMLLoader
	{
		#region Declarations
		/// <summary>
		/// The ID.
		/// </summary>
		private int m_intID;
		
		/// <summary>
		///  ID of user inporting the User xmlData.
		/// </summary>
		private int m_intUserID;

		/// <summary>
		///  ModuleID of the module to import the content to.
		/// </summary>
		private int m_intModuleID;

		/// <summary>
		///  CourseID of the module to import the content to.
		/// </summary>
		private int m_intCourseID;
		/// <summary>
		/// Relative path to the toolbook file 
		/// </summary>
		/// <example>m_strToolbookLocation = "/General/Toolbook/Content/1/4/Quiz/index.html"</example>
		private string m_strToolbookLocation;


		#endregion
		
		#region Constructors
        /// <summary>
        /// Default constructor for this class
        /// </summary>
		public ImportToolbook()
		{
		}
		
		/// <summary>
		/// Use this constructor if you only wish to upload an XML document without validating it first.
		/// </summary>
		/// <param name="XMLFile"> Path and filename of the XML file to be loaded.</param>
		public ImportToolbook(string XMLFile) : base(XMLFile)
		{
		}
		
		/// <summary>
		/// Mandatory fields constructor.
		/// Use this constructor if you wish to validate the XML document.
		/// </summary>
		/// <param name="XMLFile"> Path and filename of the XML file to be loaded.</param>
		/// <param name="XSDFile"> Path and filename of the XSD file that the XML file will be validated against.</param>
		/// <param name="Namespace"> Namespace of the XML document collection.</param>
		public ImportToolbook(string XMLFile, string XSDFile, string Namespace) : base(XMLFile, XSDFile, Namespace)
		{
		}
		#endregion
		
		#region Public Properties
		/// <summary>
		/// Gets or Sets either the ID.
		/// </summary>
		public int ID
		{
			get
			{
				return this.m_intID;
			}
			set
			{
				this.m_intID = value;
			}
		}
		
		/// <summary>
		/// Gets or Sets the ID of user inporting the Toolbook Content xmlData.
		/// </summary>
		public int UserID
		{
			get
			{
				return this.m_intUserID;
			}
			set
			{
				this.m_intUserID = value;
			}
		}

		/// <summary>
		/// Gets or Sets the Module ID to import the Toolbook Content xmlData into.
		/// </summary>
		public int ModuleID
		{
			get
			{
				return this.m_intModuleID;
			}
			set
			{
				this.m_intModuleID = value;
			}
		}

		/// <summary>
		/// Gets or Sets the Course ID to import the Toolbook Content xmlData into.
		/// </summary>
		public int CourseID
		{
			get
			{
				return this.m_intCourseID;
			}
			set
			{
				this.m_intCourseID = value;
			}
		}

		/// <summary>
		/// Gets or Sets the Course ID to import the Toolbook Content xmlData into.
		/// </summary>
		public string ToolbookLocation
		{
			get
			{
				return this.m_strToolbookLocation;
			}
			set
			{
				this.m_strToolbookLocation = value;
			}
		}

		#endregion
		
		#region Public Methods
		
		/// <summary>
		/// This method validates an XML document against a speciied XSD.  It then loads data from the XML document
		/// into the users table via the LoadUserXML method in the User class.
		/// </summary>
		/// <returns>DataSet with any errors that may have been generated at the database level.</returns>
		/// <remarks>This method overrides the base method <see cref="XMLLoader.Load()"/>.</remarks>
		public override DataSet Load()
		{
			try
			{
				//1. Validate the XML document
				this.Validate();
				
				//2. If the document is valid upload it to the database otherwise do nothing.
				if(this.p_objValidationResult.IsValid)
				{
					DataSet dsLoadResult;
					Toolbook objToolbook = new Toolbook ();
					
					//3. Loads the UserXMLData.
					return dsLoadResult = objToolbook.UploadContentObjectXML (this.GetXMLData(this.XMLFile), this.UserID,this.ModuleID,this.CourseID,this.ToolbookLocation);
				}
				else //4. Schema Validation failed.
				{
					//5. Create a new DataSet
					DataSet dsLoadResult = new DataSet("LoadResult");
					
					//6. Create a datatable with the error result from the validation struct.
					DataTable dtbLoadResult = new DataTable("Result");					
					DataColumn dtcName = new DataColumn("Error", System.Type.GetType("System.String"));
					dtbLoadResult.Columns.Add(dtcName);
					DataRow drError;
					drError = dtbLoadResult.NewRow();
                    drError["Error"] = "Invalid XML file";
                    dtbLoadResult.Rows.Add(drError);
					
                    //7. Log the error to the error log
                    //new ErrorLog(new Exception(this.ValidationResult.Error), ErrorLevel.High, "ImportToolbook", "Load", "Validate XML");
                    new ErrorLog(new ApplicationException(ValidationResult.Error.ToString()));
                    //8. Add the DataTable to the DataSet.
					dsLoadResult.Tables.Add(dtbLoadResult);
					
					//9. Return the DataSet.
					return dsLoadResult;
				}
			}			
			catch(Exception ex)
			{
				throw ex;
			}
		}
		
        /// <summary>
        /// Preview the xml content and validate it
        /// </summary>
        /// <returns>Dataset containing the results of the preview stored procedure.</returns>
		public DataSet Preview()
		{
			try
			{
				//1. Validate the XML document
				this.Validate();
				
				//2. If the document is valid upload it to the database otherwise do nothing.
				if(this.p_objValidationResult.IsValid)
				{
					DataSet dsLoadResult;
					Toolbook objToolbook = new Toolbook ();
					
					//3. Loads the UserXMLData.
					return dsLoadResult = objToolbook.UploadContentObjectXMLPreview (this.GetXMLData(this.XMLFile), this.ModuleID,this.UserID);
				}
				else //4. Schema Validation failed.
				{
					//5. Create a new DataSet
					DataSet dsLoadResult = new DataSet("LoadResult");
					
					//6. Create a datatable with the error result from the validation struct.
					DataTable dtbLoadResult = new DataTable("Result");					
					DataColumn dtcName = new DataColumn("Error", System.Type.GetType("System.String"));
					dtbLoadResult.Columns.Add(dtcName);
					DataRow drError;
					drError = dtbLoadResult.NewRow();
					drError["Error"] = "Invalid XML file";
					dtbLoadResult.Rows.Add(drError);
					
                    //7. Log the error to the error log
                    //new ErrorLog(new Exception(this.ValidationResult.Error), ErrorLevel.High, "ImportToolbook", "Preview", "Validate XML");
                    new ErrorLog (new ApplicationException(ValidationResult.Error.ToString()));
                        
					//8. Add the DataTable to the DataSet.
					dsLoadResult.Tables.Add(dtbLoadResult);
					
					//9. Return the DataSet.
					return dsLoadResult;
				}
			}			
			catch(Exception ex)
			{
				throw ex;
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="xmlFile"></param>
		/// <returns></returns>
		/// <remarks></remarks>
		public string GetXMLData(string xmlFile)
		{
			string strXMLData = "";
			
			XmlDocument objXMLDoc = new XmlDocument();
			objXMLDoc.Load(xmlFile);
			return strXMLData = this.SetRootElement(objXMLDoc.DocumentElement.InnerXml);
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="xmlData"></param>
		/// <returns></returns>
		private string SetRootElement(string xmlData)
		{
			string strRootElementName  = ConfigurationSettings.AppSettings["ImportToolBookRootElement"];
			xmlData = "<" + strRootElementName + ">" + xmlData.Replace(ConfigurationSettings.AppSettings["XMLNamespace"], "") + "</" + strRootElementName + ">";
			return xmlData;
		}
		#endregion
	}
}
