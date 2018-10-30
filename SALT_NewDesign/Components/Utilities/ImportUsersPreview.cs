using System;
using System.Data;
using System.Xml;
using System.Configuration;
using Bdw.Application.Salt.BusinessServices;

namespace Bdw.Application.Salt.Utilities
{
	/// <summary>
	/// Summary description for ImportUsers.
	/// </summary>
	public class ImportUsersPreview : XMLLoader
	{
		#region Declarations
		/// <summary>
		/// The ID of either the Organisation or the Unit.
		/// </summary>
		private int m_intID;
		
		/// <summary>
		/// The Hierachy where the Imports users call was made from.
		/// </summary>
		/// <remarks> Can either be Organisation or Unit.</remarks>
		private string m_strHierachy;
		
		/// <summary>
		///  ID of user inporting the User xmlData.
		/// </summary>
		private int m_intUserID;

		//private int m_intIsPreview;

		private int m_intUniqueField;
		#endregion
		
		#region Constructors
        /// <summary>
        /// Default constructor.
        /// </summary>
		public ImportUsersPreview()
		{
		}
		
		/// <summary>
		/// Use this constructor if you only wish to upload an XML document without validating it first.
		/// </summary>
		/// <param name="XMLFile"> Path and filename of the XML file to be loaded.</param>
		public ImportUsersPreview(string XMLFile) : base(XMLFile)
		{
		}
		
		/// <summary>
		/// Mandatory fields constructor.
		/// Use this constructor if you wish to validate the XML document.
		/// </summary>
		/// <param name="XMLFile"> Path and filename of the XML file to be loaded.</param>
		/// <param name="XSDFile"> Path and filename of the XSD file that the XML file will be validated against.</param>
		/// <param name="Namespace"> Namespace of the XML document collection.</param>
		public ImportUsersPreview(string XMLFile, string XSDFile, string Namespace, int uniqueField) : base(XMLFile, XSDFile, Namespace)
		{
		}
		#endregion
		
		#region Public Properties
		/// <summary>
		/// Gets or Sets either the OrganisationID or the UnitID.
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
		/// Gets or Sets the Hierachy of where the call was made to Import users.
		/// </summary>
		/// <remarks> This can only be Organisation or Unit.</remarks>
		public string Hierachy
		{
			get
			{
				return this.m_strHierachy;
			}
			set
			{
				this.m_strHierachy = value;
			}
		}
		
		/// <summary>
		/// Gets or Sets the ID of user importing the User xmlData.
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
		/// Gets or Sets the IsPreview of user data importing the User xmlData.
		/// </summary>
//		public int IsPreview
//		{
//			get
//			{
//				return this.m_intIsPreview;
//			}
//			set
//			{
//				this.m_intIsPreview = value;
//			}
//		}

		/// <summary>
		/// Gets or Sets the ID of user inporting the User xmlData.
		/// </summary>
		public int UniqueField
		{
			get
			{
				return this.m_intUniqueField;
			}
			set
			{
				this.m_intUniqueField = value;
			}
		}
		#endregion
		
		#region Public Methods
		
		/// <summary>
		/// This method validates an XML document against a specified XSD.  It then loads data from the XML document
		/// into the users table via the LoadUserXML method in the User class.
		/// </summary>
		/// <returns> DataSet with any errors that may have been generated at the database level.</returns>
		/// <remarks> This method overrides the base method <see cref="XMLLoader.Load()"/>.</remarks>
		public override DataSet Load()
		{
			//1. Validate the XML document
			this.Validate();
				
			//2. If the document is valid upload it to the database otherwise do nothing.
			if(this.p_objValidationResult.IsValid)
			{
				DataSet dsLoadResult;
				User objUser = new User();
					
				//Loads the UserXMLData.
				return dsLoadResult = objUser.LoadUserXML(this.ID, this.GetXMLData(this.XMLFile), this.Hierachy, this.UserID, this.UniqueField);
			}
				//3. Schema Validation failed.
			else 
			{
				throw new ApplicationException(this.ValidationResult.Error);
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
		
		private string SetRootElement(string xmlData)
		{
			string strRootElementName  = ConfigurationSettings.AppSettings["ImportUsersRootElement"];
			xmlData = "<" + strRootElementName + ">" + xmlData.Replace(ConfigurationSettings.AppSettings["XMLNamespace"], "") + "</" + strRootElementName + ">";
			return xmlData;
		}
		#endregion
	}
}
