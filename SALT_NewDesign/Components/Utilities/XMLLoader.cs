using System;
using System.Data;

namespace Bdw.Application.Salt.Utilities
{
	/// <summary>
	/// The XMLLoader class is an abstract class that creates the basic class structure for uploading XML documents.
	/// This class also provides the facility to validate the XML document against a specified XSD file.
	/// </summary>
	/// <remarks>
	/// Assumptions: XSD file is a valid XSD file.
	/// Notes:
	/// Author: Peter Vranich, 28/01/0/2004
	/// Changes:
	/// </remarks>
	public abstract class XMLLoader
	{
		#region Declarations
		
		/// <summary>
		/// Stores the path and filename of the XML file to be loaded.
		/// </summary>
		protected string p_strXMLFile;
		
		/// <summary>
		/// Stores the path and filename of the XSD file that the XML file will be validated against.
		/// </summary>
		/// <remarks> This is optional if you do not wish to validate the XML document.</remarks>
		protected string p_strXSDFile;
		
		/// <summary>
		/// Stores the namespace used in the XML file.
		/// </summary>
		/// <remarks> This is optional if you do not wish to validate the XML document.</remarks>
		protected string p_strNameSpace;
		
		/// <summary>
		/// Stores the validation result structure.
		/// </summary>
		/// <remarks> This is optional if you do not wish to validate the XML document.</remarks>
		protected ValidXML p_objValidationResult;
//		protected int p_intIsPreview;
//		protected int p_intUniqueField;
		#endregion
		
		#region Constructors
		
        /// <summary>
        /// Default constructor for this class.
        /// </summary>
		public XMLLoader()
		{
		}
		
		/// <summary>
		/// Use this constructor if you only wish to upload an XML document without validating it first.
		/// </summary>
		/// <param name="XMLFile"> Path and filename of the XML file to be loaded.</param>
		public XMLLoader(string XMLFile)
		{
			this.XMLFile = XMLFile;
		}
		
		/// <summary>
		/// Mandatory fields constructor.
		/// Use this constructor if you wish to validate the XML document.
		/// </summary>
		/// <param name="XMLFile"> Path and filename of the XML file to be loaded.</param>
		/// <param name="XSDFile"> Path and filename of the XSD file that the XML file will be validated against.</param>
		/// <param name="Namespace"> Namespace of the XML document collection.</param>
		public XMLLoader(string XMLFile, string XSDFile, string Namespace)
		{
			this.XMLFile = XMLFile;
			this.XSDFile = XSDFile;
			this.NameSpace = Namespace;
			this.p_objValidationResult = new ValidXML();
		}
		#endregion
		
		#region Public Properties
		
		/// <summary>
		/// Gets or Sets the file and path of the XML document to be loaded.
		/// </summary>
		public string XMLFile
		{
			get
			{
				return this.p_strXMLFile;
			}
			set
			{
				this.p_strXMLFile = value;
			}
		}
		/// <summary>
		/// Gets or Sets the filename and path of the XSD file to be used for validation if required.
		/// </summary>
		public string XSDFile
		{
			get
			{
				return this.p_strXSDFile;
			}
			set
			{
				this.p_strXSDFile = value;
			}
		}
		
		/// <summary>
		/// Gets or sets the Namespace of the XML document collection.
		/// </summary>
		public string NameSpace
		{
			get
			{
				return this.p_strNameSpace;
			}
			set
			{
				this.p_strNameSpace = value;
			}
		}
		
		/// <summary>
		/// Gets or Sets the result of the XML validation process.
		/// </summary>
		public ValidXML ValidationResult
		{
			get
			{
				return this.p_objValidationResult;
			}
			set
			{
				this.p_objValidationResult = value;
			}
		}

//		
		#endregion
		
		#region Public Methods
		
		/// <summary>
		/// This is an abstract method that must be overriden in the inhereting class.
		/// </summary>
		/// <returns>A DataSet with any errors that may have occured at the database level.</returns>
		public abstract DataSet Load();
		
		/// <summary>
		/// This metod Validates an XML document via the XMLValidator class.
		/// </summary>
		protected void Validate()
		{
            XMLValidator validator;

            try
            {
                validator = new XMLValidator(this.p_strXMLFile, this.p_strXSDFile, this.p_strNameSpace);
                this.p_objValidationResult = validator.Validate();
            }
            catch(Exception ex)
            {
                throw ex;
            }
            finally
            {
                validator = null;
            }
		}		
		#endregion
	}
}
