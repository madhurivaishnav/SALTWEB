using System;
using System.Xml;
using System.Xml.Schema;

namespace Bdw.Application.Salt.Utilities
{
	/// <summary>
	/// The XMLValidator class validates an XML file against a specified XSD file.
	/// The validation returns the ValidXML struct with the indicating success or failure.
	/// </summary>
	/// <remarks>
	/// Assumptions: XSD file is a valid XSD file.
	/// Notes:
	/// Author: Peter Vranich, 28/01/0/2004
	/// Changes:
	/// </remarks>
	public class XMLValidator
	{	
		#region Declarations
		
		/// <summary>
		/// Stores the path and filename of the XML file to be validated.
		/// </summary>
		private string m_strXMLFile;
		
		/// <summary>
		/// Stores the path and filename of the XSD file that the XML file will be validated against.
		/// </summary>
		private string m_strXSDFile;
		
		/// <summary>
		/// Stores the namespace used in the XML file.
		/// </summary>
		private string m_strNameSpace;
		
		/// <summary>
		/// This stores the XML validation result.
		/// </summary>
		private ValidXML m_objValidationResult;
		
		#endregion
		
		#region Constructors
		/// <summary>
		/// Mandatory fields constructor.
		/// </summary>
		/// <param name="XMLFile"> Path and filename of the XML file to be validated.</param>
		/// <param name="XSDFile"> Path and filename of the XSD file that the XML file will be validated against.</param>
		/// <param name="NameSpace"> Namespace of the XML document collection.</param>
		public XMLValidator(string XMLFile, string XSDFile, string NameSpace)
		{
			this.m_strXMLFile = XMLFile;
			this.m_strXSDFile = XSDFile;
			this.m_strNameSpace = NameSpace;
			this.m_objValidationResult = new ValidXML();
		}
		#endregion
	
		#region Public Methods
		
		/// <summary>
		/// Validates the XML file against a specified Schema file.
		/// </summary>
		/// <returns>A ValidXML struct.<see cref="ValidXML"/></returns>
		public ValidXML Validate()
		{
			XmlTextReader xml=null;
			XmlValidatingReader xsd=null;
			try 
			{
				//1. Set the 
				this.m_objValidationResult.IsValid = true;
				
				// Create the XML text reader object.
				xml = new XmlTextReader(this.m_strXMLFile);
				
				// Create a validating reader object.
				xsd = new XmlValidatingReader(xml);
				
				// Load the Schema collection.
				XmlSchemaCollection xsc = new XmlSchemaCollection();
				xsc.Add(this.m_strNameSpace, this.m_strXSDFile);
				
				// Validate using the schemas stored in the schema collection.
				xsd.Schemas.Add(xsc);
				
				// Set the validation type.
				xsd.ValidationType = ValidationType.Schema;
				
				// Set the validation event handler.
				xsd.ValidationEventHandler += new ValidationEventHandler(ValidationEventHandler);
				
				// Read and validate the XML data.
				while(xsd.Read())
				{
				}
			}
			catch(XmlException ex)
			{
				// Set the IsValid property to false.
				this.m_objValidationResult.IsValid = false;
			
				// Set the Error details.
				this.m_objValidationResult.Error += "Message:  " + ex.Message;
			}
			catch(Exception ex)
			{				
				throw new ApplicationException(ex.Message);
			}
			//Close xml reader even if there is exception
			//This fixes the following bug:
			//If a xml file is not valid, and exception is throwed. this file is locked, no more file can be uploaded
			//Jack Liu 15/09/2005,
			finally
			{
				if (xsd!=null)
				{
					xsd.Close();
				}
				if (xml!=null)
				{
					xml.Close();
				}
			}
			return this.m_objValidationResult;
		}
		#endregion
		
		#region Public Static Methods
		
		/// <summary>
		/// EventHandler for the XML validation  process.
		/// </summary>
		/// <param name="sender">Object</param>
		/// <param name="args">Validation Event Arguments.</param>
		private void ValidationEventHandler(object sender, ValidationEventArgs args) 
		{
			// Set the IsValid property to false.
			this.m_objValidationResult.IsValid = false;
			
			// Set the Error details.			
			this.m_objValidationResult.Error += "Message:  " + args.Message + "<br><hr>";
		}
		#endregion
	}
	
	/// <summary>
	/// Public struct holding the values indicating whether a XML Validation succeeded or not.  If the validation failed the Errors will
	/// be found in this struct for that validation attempt.
	/// </summary>
	/// <remarks>
	/// Assumptions:
	/// Notes: This is a value type not a reference type.
	/// Author: Peter Vranich, 28/01/0/2004
	/// Changes:
	/// </remarks>
	public struct ValidXML
	{
		#region Declarations
		/// <summary>
		/// Boolean value indicating if the XML file is valid or not.
		/// </summary>
		private bool m_blnIsValid;
		
		/// <summary>
		/// String of any errors that are generated when validating the XML document.
		/// </summary>
		private string m_strError;
		#endregion
		
		#region Public Properties		
		/// <summary>
		/// Gets or Sets the m_blnIsValid member.
		/// </summary>
		public bool IsValid
		{
			get
			{
				return m_blnIsValid;
			}
			set
			{
				m_blnIsValid = value;
			}
		}
		
		/// <summary>
		/// Gets or Sets the m_strError member.
		/// </summary>
		public string Error
		{
			get
			{
				return m_strError;
			}
			set
			{
				m_strError = value;
			}
		}
		#endregion
	}
}