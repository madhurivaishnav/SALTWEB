using System;
using System.Configuration;
using System.Data;
using System.IO;
using System.Text;
using System.Xml;
using Localization;
namespace Bdw.Application.Salt.Utilities
{
    /// <summary>
    /// This class provides methods to generate an xml document from a CSV file
    /// </summary>
    /// <remarks>
    /// Assumptions: CSV file is valid.
    /// Notes:
    /// Author: Stephen Clark 6/4/04
    /// Changes:
    /// </remarks>
    /// <example></example>
    public abstract class CSVtoXMLConverter : IDisposable
    {
         
        #region Public Declarations
        /// <summary>
        /// This is the character used to split the string
        /// </summary>
        public char[] charSplit={','};
        #endregion

        #region Protected Declarations
        /// <summary>
        /// This XML Text Writer is used to generate the xml file
        /// </summary>
        protected XmlTextWriter xmlTextWriter;
        /// <summary>
        /// Boolean flag indicating the presence of a header row in the dataset
        /// </summary>
        protected bool HasHeader;
        #endregion

        #region Private Declarations
        /// <summary>
        /// Filestream to read the csv file
        /// </summary>
        private FileStream m_fsInput;

        /// <summary>
        /// Filestream to write the xml file
        /// </summary>
        private FileStream m_fsOutput;
        #endregion

        #region Constructors

        /// <summary>
        /// Constructor that accepts filestreams
        /// </summary>
        /// <param name="fsInput">Filestream connected to the input csv file</param>
        /// <param name="fsOutput">Filestream connected to the output xml file</param>
        public CSVtoXMLConverter (FileStream fsInput,FileStream fsOutput)
        {
            this.m_fsInput=fsInput;
            this.m_fsOutput=fsOutput;
        }

        /// <summary>
        /// Constructor that accepts filenames
        /// </summary>
        /// <param name="fileNameIn">Filename of the input csv file</param>
        /// <param name="fileNameOut">Filename of the output xml file</param>
        public CSVtoXMLConverter (string fileNameIn, string fileNameOut)
        {
            FileStream fsInput = new FileStream (fileNameIn,FileMode.Open);
            FileStream fsOutput = new FileStream (fileNameOut,FileMode.Create);
            this.m_fsInput=fsInput;
            this.m_fsOutput=fsOutput;
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// This method generates the xml file from the csv file by using the overridden 
        /// Write method. This enables this class to be derived from and provide csv to xml conversion
        /// for any csv file
        /// </summary>
        public void Generate ()
        {
            string strCSVLine;
                

            if (!(m_fsInput.CanRead))
            {
                throw new Exception(ResourceManager.GetString("CSVtoXMLConverter.cs.Generate.1"));
            }
            if (!(m_fsOutput.CanWrite))
            {
                throw new Exception(ResourceManager.GetString("CSVtoXMLConverter.cs.Generate.2"));
            }

         
            StreamReader streamReader = new StreamReader (m_fsInput);
            xmlTextWriter = new XmlTextWriter (m_fsOutput,Encoding.Default);
            
            // Setup the root element
            string strRootElementName  = ConfigurationSettings.AppSettings["ImportUsersRootElement"];

            // Get the namespace
            string strXMLNamespace = ConfigurationSettings.AppSettings["XMLNamespace"];
            
            xmlTextWriter.WriteStartDocument(); 
            xmlTextWriter.WriteStartElement(strRootElementName);                                        
            xmlTextWriter.WriteAttributeString("xmlns",strXMLNamespace);

            int intLineCounter=1;
            // while there is more information in the input file
            while (streamReader.Peek() > -1) 
            {
                strCSVLine = streamReader.ReadLine();

                // call the overridden method with a line of text
                try
                {
                    Write(strCSVLine);
                }
                catch(Exception ex)
                {
                    throw new Exception("Error at line:" + intLineCounter.ToString() + ". " + ex.Message);
                }

                intLineCounter++;
            }
            xmlTextWriter.WriteEndElement();
            
            
            // Close files
            xmlTextWriter.Flush();
            xmlTextWriter.Close();
            streamReader.Close();
            m_fsInput.Close();
            m_fsOutput.Close();
        }
        #endregion
        
        #region Public Abstract Methods

        /// <summary>
        /// This method must be overriden by any classes that derive from this class.
        /// </summary>
        /// <param name="CSVLine">A single line of csv style text to be parsed.</param>
        protected abstract void Write(string CSVLine);
        #endregion
     

        #region IDisposable Members

        /// <summary>
        /// This class is disposable to assist in removing file handles and other
        /// expensive resources when it terminates. It should be instantiated using the 
        /// c# 'Using' constructor
        /// </summary>
        public void Dispose()
        {
            this.m_fsInput.Close();
            this.m_fsOutput.Close();
            this.m_fsInput = null;
            this.m_fsOutput = null;
        }

        #endregion

        #region CSVtoXMLConverter_Unit
        /// <summary>
        /// This is a basic example of how a derived class should be written
        /// in order to import users 
        /// </summary>
        public class Unit : CSVtoXMLConverter     
        {
            /// <summary>
            /// Constructor that overrides the base constructor
            /// </summary>
            /// <param name="fsInput">Input filestream</param>
            /// <param name="fsOutput">Output filestream</param>
            public Unit(FileStream fsInput,FileStream fsOutput) : base (fsInput,fsOutput) 
            {
            }

            /// <summary>
            /// Constructor that overrides the base constructor
            /// </summary>
            /// <param name="fileNameIn">Input filestream</param>
            /// <param name="fileNameOut">Output filestream</param>
            public Unit(string fileNameIn, string fileNameOut) : base (fileNameIn,fileNameOut)
            {
            }

            /// <summary>
            /// Sample implementation of how a CSV file may be translated into 
            /// an xml file.
            /// </summary>
            /// <param name="CSVLine">A string containing csv values from a single line of a csv file</param>
            protected override void Write(string CSVLine)
            {
                string[] strCSVLineItems;
                
                strCSVLineItems = CSVLine.Split(charSplit);
                
                //<Unit>
                xmlTextWriter.WriteRaw (Environment.NewLine);                       
                xmlTextWriter.WriteStartElement("Unit");                                        
                
                // UnitID = "1"
                xmlTextWriter.WriteAttributeString("UnitID",strCSVLineItems[0]);
                
                // UnitName = "Main Division"
                xmlTextWriter.WriteAttributeString("UnitName",strCSVLineItems[1]);
                xmlTextWriter.WriteRaw (Environment.NewLine);                       
                xmlTextWriter.WriteEndElement();       
                //</Unit>
                
            }
        }
        #endregion

        #region CSVtoXMLConverter_User
        /// <summary>
        /// User class derived form the csv to xml converter
        /// </summary>
        public class User : CSVtoXMLConverter     
        {
            /// <summary>
            /// Constructor that overrides the base constructor
            /// </summary>
            /// <param name="fsInput">Input filestream</param>
            /// <param name="fsOutput">Output filestream</param>
            public User(FileStream fsInput,FileStream fsOutput) : base (fsInput,fsOutput) {}

            /// <summary>
            /// Constructor that overrides the base constructor
            /// </summary>
            /// <param name="fileNameIn">Input filestream</param>
            /// <param name="fileNameOut">Output filestream</param>
            public User(string fileNameIn, string fileNameOut) : base (fileNameIn,fileNameOut){}

            /// <summary>
            /// This method must be overriden by any classes that derive from this class.
            /// </summary>
            /// <param name="CSVLine">A single line of csv style text to be parsed.</param>
            protected override void Write(string CSVLine)
            {
                string[] strCSVLineItems;
                
                try
                {
                    strCSVLineItems = CSVLine.Split(charSplit);                    
                }
                catch 
                {
                    throw new DataException(String.Format(ResourceManager.GetString("CSVtoXMLConverter.cs.Write.1"), Environment.NewLine + CSVLine.Substring(0,20)));
                }
                if (strCSVLineItems.Length != 14 && strCSVLineItems.Length != 10)
                {
                    throw new DataException(ResourceManager.GetString("CSVtoXMLConverter.cs.Write.2"));
                }
                
                // <User>
                xmlTextWriter.WriteRaw (Environment.NewLine);     
                xmlTextWriter.WriteStartElement("User");      
                
                string strUserName;
                string strPassword;
                string strFirstname;
                string strLastname;
                string strEmail;
                string strExternalID;
                string strUnitID;
				string strArchive;
                string strClassificationName;
                string strClassificationOption;
                string strNotifyUnitAdmin;
                string strNotifyOrgAdmin;
                string strManagerNotification;
                string strManagerToNotify;


                try
                {
                    // Get the details of the new user
                    strUserName             = strCSVLineItems[0];
                    strPassword             = strCSVLineItems[1];
                    strFirstname            = strCSVLineItems[2];
                    strLastname             = strCSVLineItems[3];
                    strEmail                = strCSVLineItems[4];
                    strExternalID           = strCSVLineItems[5];
                    strUnitID               = strCSVLineItems[6];
					strArchive		        = strCSVLineItems[7];
                    strClassificationName   = strCSVLineItems[8];
                    strClassificationOption = strCSVLineItems[9];
                    if (strCSVLineItems.Length == 14)
                    {
                        strNotifyUnitAdmin = strCSVLineItems[10];
                        strNotifyOrgAdmin = strCSVLineItems[11];
                        strManagerNotification = strCSVLineItems[12];
                        strManagerToNotify = strCSVLineItems[13];
                    }
                    else 
                    {
                        strNotifyUnitAdmin = "";
                        strNotifyOrgAdmin = "";
                        strManagerNotification = "";
                        strManagerToNotify = ""; 
                    }

  
                }
                catch 
                {
                    throw new DataException(String.Format(ResourceManager.GetString("CSVtoXMLConverter.cs.Write.3"), Environment.NewLine + CSVLine.Substring(0,20)));
                }
                
                // Clean the data of quotes and whitespace
                strUserName     = strUserName.Trim().Replace("\"","");
                strPassword     = strPassword.Trim().Replace("\"","");
                strFirstname    = strFirstname.Trim().Replace("\"","");
                strLastname     = strLastname.Trim().Replace("\"","");
                strEmail        = strEmail.Trim().Replace("\"","");
                strExternalID   = strExternalID.Trim().Replace("\"","");
                strUnitID       = strUnitID.Trim().Replace("\"","");
				strArchive		= strArchive.Trim().Replace("\"","");
                strNotifyUnitAdmin  = strNotifyUnitAdmin.Trim().Replace("\"", "");
                strNotifyOrgAdmin = strNotifyOrgAdmin.Trim().Replace("\"", "");
                strManagerNotification = strManagerNotification.Trim().Replace("\"", "");
                strManagerToNotify = strManagerToNotify.Trim().Replace("\"", "");



                // Write the details to the xml file
                xmlTextWriter.WriteAttributeString("Username",strUserName);
                xmlTextWriter.WriteAttributeString("Password",strPassword);
                xmlTextWriter.WriteAttributeString("Firstname",strFirstname);
                xmlTextWriter.WriteAttributeString("Lastname",strLastname);
                xmlTextWriter.WriteAttributeString("Email",strEmail);
                xmlTextWriter.WriteAttributeString("ExternalID",strExternalID);
                xmlTextWriter.WriteAttributeString("UnitID",strUnitID);
				xmlTextWriter.WriteAttributeString("Archive",strArchive);
                xmlTextWriter.WriteAttributeString("NotifyUnitAdmin", strNotifyUnitAdmin);
                xmlTextWriter.WriteAttributeString("NotifyOrgAdmin", strNotifyOrgAdmin);
                xmlTextWriter.WriteAttributeString("ManagerNotification", strManagerNotification);
                xmlTextWriter.WriteAttributeString("ManagerToNotify", strManagerToNotify);

                xmlTextWriter.WriteStartElement("CustomClassifications");
                    xmlTextWriter.WriteStartElement("CustomClassification");
                    xmlTextWriter.WriteAttributeString("Name", strClassificationName);
                    xmlTextWriter.WriteAttributeString("Option", strClassificationOption);
                    xmlTextWriter.WriteEndElement();//CustomClassification
                xmlTextWriter.WriteEndElement();//CustomClassifications

                xmlTextWriter.WriteRaw (Environment.NewLine);     
                xmlTextWriter.WriteEndElement();       
                // </User>  
              
            }
        }
        #endregion
    }
    
}
