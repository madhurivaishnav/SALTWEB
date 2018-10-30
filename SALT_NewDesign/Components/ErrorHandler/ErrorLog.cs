using System;
using System.Data;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using System.Web; 
using System.Diagnostics;
using System.Reflection;
using System.IO;
using System.Xml;
using System.Configuration;
using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.BusinessServices; 

namespace Bdw.Application.Salt.ErrorHandler
{
	/// <summary>
	/// This class provides methods to maintain the error log.
	/// It can write the log to two locations. These locations are
	/// defined in the Web.Config file. The first is the database
	/// </summary>
	/// <remarks>
	/// Assumptions: The error tables are contained in the same database as SALT
	/// Notes:
	/// Author: Peter Kneale, 05/02/2004
	/// Changes:
	/// </remarks>
	/// <example>
	/// To Raise an Regular Error from an Exception
	/// <code>
	/// ErrorHandler.ErrorLog ErrorLog = new ErrorHandler.ErrorLog (ex);
	/// </code>
	/// To Raise a Less Severe Error
	/// ErrorHandler.ErrorLog ErrorLog = new ErrorHandler.ErrorLog (ex, ErrorLevel.InformationOnly);
	/// 
	/// To Raise a More Severe Error 
	/// ErrorHandler.ErrorLog ErrorLog = new ErrorHandler.ErrorLog (ex, ErrorLevel.High);
	/// 
	/// To Raise a More Customised Error
	/// ErrorHandler.ErrorLog ErrorLog = new ErrorHandler.ErrorLog (ex, ErrorLevel.High,"My Module Name","My Function Name", "My Code");
	/// 
	/// To Return a Datatable of existing errors from the SALT database.
	/// ErrorHandler.ErrorLog oErrorLog = new ErrorHandler.ErrorLog ();
	/// DataTable dtbErrorResults = oErrorLog.GetReport();
	/// </example>
	public class ErrorLog 
	{		
		#region Declarations
		/// <summary>
		/// Private string containing the StackTrace Information from the Exception.
		/// </summary>
		string m_strStackTrace;

		/// <summary>
		/// Private SQL String containing the Error Source Information from the Exception
		/// </summary>
		private SqlString m_sqlSource;


		/// <summary>
		/// Private SQL String containing the Error Message Information from the Exception
		/// </summary>
		private SqlString m_sqlMessage;


		/// <summary>
		/// Private SQL String containing the Stack Trace Information from the Exception
		/// </summary>
		private SqlString m_sqlStackTrace;


		/// <summary>
		/// public enumeration of the Error Status, New Errors are set to unassigned
		/// </summary>
		public ErrorStatus ErrorStatus;


		/// <summary>
		/// Private enumeration of the Error Level, By default they are assigned ErrorLevel.Medium
		/// </summary>
		private ErrorLevel m_ErlErrorLevel;


		/// <summary>
		/// Indicates if the class is to save the error to the database
		/// </summary>
		private string m_strErrorLogDB;


		/// <summary>
		/// Private string that indicates if the class is t save the error to the file
		/// </summary>
		private string m_strErrorLogFile;


		/// <summary>
		/// Private string containing the name of the file to log to.
		/// </summary>
		private string m_strErrorLogFileName;


		/// <summary>
		/// Private string containing the event category to log the events to.
		/// </summary>
		private string m_strErrorLogEventName;


		/// <summary>
		/// Private string containing the event log to log the events to.
		/// </summary>
		private string m_strEventLogName;



		/// <summary>
		/// Private string containing the optional module that the error occurred in.
		/// </summary>
		private string m_strModule;

		/// <summary>
		/// Private string containing the optional function that the error occurred in.
		/// </summary>
		private string m_strFunction;

		/// <summary>
		/// Private string containing the optional code that the error occurred in.
		/// </summary>
		private string m_strCode;
		
		#endregion

		#region Constructors
		/// <summary>
		/// Constructor to use when we wish to just instantiate the object
		/// in order to get logs etc.
		/// <code>
		/// ErrorHandler.ErrorLog oErrorLog = new ErrorHandler.ErrorLog ();
		/// DataTable dtbErrorResults = oErrorLog.GetReport();
		/// </code>
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		public ErrorLog ()
		{
            this.ErrorStatus = ErrorStatus.Unassigned;
		}


		/// <summary>
		/// Constructor to use when we wish to log a basic exception
		/// <code>
		/// ErrorHandler.ErrorLog oErrorLog = new ErrorHandler.ErrorLog (ex);
		/// </code>
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		public ErrorLog (Exception ex) 
		{		
			// The innermost exception has the most accurate information.
			if (ex.InnerException != null)
			{
				ex = ex.InnerException;
			}
			// Get Application Settings
			GetSetting();			
			this.m_sqlSource = ex.Source;
			this.m_sqlMessage = ex.Message;
			this.m_sqlStackTrace = ex.StackTrace;
			this.m_ErlErrorLevel = ErrorLevel.Medium;
			this.ErrorStatus = ErrorStatus.Unassigned;
			this.Save();
		}

		/// <summary>
		/// Constructor to use when we wish to log a basic exception with a specific error level.
		/// <code>
		/// ErrorHandler.ErrorLog oErrorLog = new ErrorHandler.ErrorLog (ex);
		/// </code>
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		public ErrorLog (Exception ex, ErrorLevel intErrorLevel) 
		{	
			// The innermost exception has the most accurate information.
			if (ex.InnerException != null)
			{
				ex = ex.InnerException;
			}
			GetSetting();			
			this.m_sqlSource = ex.Source;
			this.m_sqlMessage = ex.Message;
			this.m_sqlStackTrace = ex.StackTrace;
			this.m_ErlErrorLevel = intErrorLevel;
			this.ErrorStatus = ErrorStatus.Unassigned;
			this.Save();
		}



		/// <summary>
		/// Constructor to use when we wish to log a basic exception with a specific error level
		/// and also the name of the Module, Function and Code that failed
		/// <code>
		/// ErrorHandler.ErrorLog oErrorLog = new ErrorHandler.ErrorLog (ex,"My Dumb Module","My Useless Function","My bad code");
		/// </code>
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		public ErrorLog (Exception ex, ErrorLevel intErrorLevel,string strModule, string strFunction, string strCode) 
		{
			// The innermost exception has the most accurate information.
			if (ex.InnerException != null)
			{
				ex = ex.InnerException;
			}
			GetSetting();			
			this.m_sqlSource = ex.Source;
			this.m_sqlMessage = ex.Message;
			this.m_sqlStackTrace = ex.StackTrace;
			this.m_ErlErrorLevel = intErrorLevel;
			this.ErrorStatus = ErrorStatus.Unassigned;
			this.m_strModule = strModule;
			this.m_strFunction = strFunction;
			this.m_strCode = strCode; 
			this.Save();
		}

		/// <summary>
		/// Constructor to use when we wish to log an exception whilst running a stored procedured with a specific error level
		/// and also the name of the Module, Function and Code that failed
		/// <code>
		/// ErrorHandler.ErrorLog oErrorLog = new ErrorHandler.ErrorLog (ex,"My Dumb Module","My Useless Function","My bad code", "stored procedure details");
		/// </code>
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		public ErrorLog (Exception ex, ErrorLevel intErrorLevel,string strModule, string strFunction, string strCode, string strProcedure) 
		{
			// The innermost exception has the most accurate information.
			if (ex.InnerException != null)
			{
				ex = ex.InnerException;
			}
			GetSetting();			
			this.m_sqlSource = ex.Source;
			this.m_sqlMessage = ex.Message + " " + strProcedure;
			this.m_sqlStackTrace = ex.StackTrace;
			this.m_ErlErrorLevel = intErrorLevel;
			this.ErrorStatus = ErrorStatus.Unassigned;
			this.m_strModule = strModule;
			this.m_strFunction = strFunction;
			this.m_strCode = strCode; 
			this.Save();
		}

		#endregion

		#region Private Methods
		/// <summary>
		/// This method will attempt to save the error to the locations specified in the Web.Config file.
		/// It is called when an error log class is initialised with any constructor except the one with no parameters
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		private void Save()
		{
			// m_strErrorLogDB contains the setting indicating if we wish to log it to the database.
			if (m_strErrorLogDB.ToString()== "Y")
			{
				this.SaveToDB(); 
			}
			// m_strErrorLogDB contains the setting indicating if we wish to log it to the file.
			if (m_strErrorLogFile.ToString()== "Y")
			{
				this.SaveToFile();
			}
			// If both are disabled then write it to the event log
			if (m_strErrorLogDB=="N" && m_strErrorLogFile=="N")
			{
				this.SaveToEvent();
			}
	
		}
		/// <summary>
		/// This method will save the current error to the database via a stored procedure.
		/// If it fails then the error will be written to the event log.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		private void SaveToDB() 
		{			
	
			try
			{
				Error ErrorLog = new Error();
				ErrorLog.SaveToDbService(this.m_sqlSource.ToString() ,this.m_strModule,this.m_strFunction,this.m_strCode,this.m_sqlMessage.ToString(),this.m_sqlStackTrace.ToString(),this.m_ErlErrorLevel);        
			}
			
			
			catch(Exception ex)
			{
				if (ex.InnerException != null)
				{
					this.m_strStackTrace += "\n\nAnother Error Occurred While Writing Previous Error To Database.: " + ex.Message.ToString() + ex.InnerException.StackTrace.ToString();;
				}
				else
				{
					this.m_strStackTrace += "\n\nAnother Error Occurred While Writing Previous Error To Database.: " + ex.Message.ToString() + ex.StackTrace.ToString();;
				}
				SaveToEvent();
			}


		}

		/// <summary>
		/// This method will save the current error to the file..
		/// If it fails then the error will be written to the event log.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		private void SaveToFile() 
		{
			try
			{
				XmlDocument doc = new XmlDocument();

				if (File.Exists(this.m_strErrorLogFileName ) )
				{
					// Remove readOnly from attributes
					FileAttributes attributes = FileAttributes.Normal;
					// Set the attributes of the file to exclude readOnly
					File.SetAttributes( m_strErrorLogFileName, attributes );
					doc.Load( m_strErrorLogFileName );
				}

				if (doc.InnerXml == "")
				{
					doc.LoadXml("<?xml version=\"1.0\" encoding=\"utf-8\"?><Root></Root>");
				}

				XmlNode root = doc.DocumentElement;
				XmlNode errorsNode; 
				XmlNode errorNode;
				bool newError;

				XmlAttribute attribute;
				XmlNode element;
				//Put all errors occur in the same day in one node
				errorsNode = root.SelectSingleNode("./Errors[@Date=\"" + DateTime.Now.ToShortDateString() + "\"]"); 

				if(errorsNode == null)
				{
					errorsNode= doc.CreateNode(XmlNodeType.Element, "Errors", "");

					attribute = doc.CreateAttribute("Date");
					attribute.Value =DateTime.Now.ToShortDateString();
					errorsNode.Attributes.Append( attribute);
					root.AppendChild(errorsNode);
				}

				//Error Node				
				errorNode = doc.CreateNode(XmlNodeType.Element, "Error", "");

				element = doc.CreateNode(XmlNodeType.Element, "Source", "");
				element.InnerText = this.m_sqlSource.ToString();
				errorNode.AppendChild( element );

				element = doc.CreateNode(XmlNodeType.Element, "Message", "");
				element.InnerText = this.m_sqlMessage.ToString();
				errorNode.AppendChild( element );

				element = doc.CreateNode(XmlNodeType.Element, "StackTrace", "");
				element.InnerText = this.m_sqlStackTrace.ToString();
				errorNode.AppendChild( element );

				newError = true;
				//Find the same error node
				foreach(XmlNode node in errorsNode.ChildNodes)
				{
					if (node.InnerText == errorNode.InnerText)
					{
						errorNode = node;
						newError = false;
						break;
					}
				}

				if (newError)
				{
					attribute = doc.CreateAttribute("Time");
					attribute.Value = DateTime.Now.ToShortTimeString();
					errorNode.Attributes.Append( attribute );
				
					attribute = doc.CreateAttribute("Level");
					attribute.Value = this.m_ErlErrorLevel.ToString();
					errorNode.Attributes.Append( attribute );
				
					attribute = doc.CreateAttribute("Count");
					attribute.Value = "1";
					errorNode.Attributes.Append( attribute );

					errorsNode.AppendChild(errorNode);
				}
				else
				{
					errorNode.Attributes["Time"].Value =  DateTime.Now.ToShortTimeString();
					errorNode.Attributes["Level"].Value =  this.m_ErlErrorLevel.ToString();
					errorNode.Attributes["Count"].Value =  (int.Parse(errorNode.Attributes["Count"].Value)+1).ToString();
				}

				doc.Save(m_strErrorLogFileName);

			}
			catch(Exception ex)
			{
				this.m_strStackTrace += "\n\nAnother Error Occurred While Writing Previous Error To File.: " + ex.StackTrace;
				SaveToEvent();
			}
		}

		/// <summary>
		/// This method will save the current error to the event log..
		/// If it fails then the error will be written to the event log.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		private void SaveToEvent() 
		{			
			try
			{		
				// Build string to write to the event log.
				string err = "Error in: " + this.m_sqlSource.ToString() +
					"\nError Level:" + this.m_ErlErrorLevel.ToString()+ 
					"\nError Message:" + this.m_sqlMessage.ToString()+ 
					"\nStack Trace:" + this.m_sqlStackTrace.ToString();
				
				// Write to event log
				EventLog e = new EventLog();
				e.Source = m_strErrorLogEventName;
				e.Log = m_strEventLogName;

				e.WriteEntry(err, EventLogEntryType.Error);
			}
			catch(Exception ex)
			{
				string message = ex.Message.ToString();
				throw new ApplicationException(message);
			}
		}
		/// <summary>
		/// Finds the Assembly folder of the current assembly.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		/// <returns>String containing the assembly folder.</returns>
		private string GetCallingAssemblyFolder()
		{
			Assembly assembly = System.Reflection.Assembly.GetCallingAssembly();
			string appPath;
			//
			// If we're shadow copying,. fiddle with
			// the codebase instead
			//
			if(AppDomain.CurrentDomain.ShadowCopyFiles) 
			{
				Uri uri = new Uri(assembly.CodeBase);
				appPath = Path.GetDirectoryName(uri.LocalPath);
			}
			else
			{
				appPath =  Path.GetDirectoryName(assembly.Location);
			}
			return appPath;
		}

		/// <summary>
		/// Gets settings related to where exactly the error log should be updated.
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Peter Kneale 3/02/2004
		/// Changes:
		/// </remarks>
		private void GetSetting()
		{
			// Contains Y or N indicating whether we wish to log it to the database
			m_strErrorLogDB = ConfigurationSettings.AppSettings["ErrorLogMethodDB"];
			// Contains Y or N indicating whether we wish to log it to the file
			m_strErrorLogFile = ConfigurationSettings.AppSettings["ErrorLogMethodFile"]; 
			// Contains the error log filename
			m_strErrorLogFileName = ConfigurationSettings.AppSettings["ErrorLogFileName"];
			// Contains the error log event name
			m_strErrorLogEventName = ConfigurationSettings.AppSettings["ErrorLogEventName"];
			// Contains the error log name
			m_strEventLogName = ConfigurationSettings.AppSettings["EventLogName"];

	
			//Check error log file  name
			//If not setting, the default folder of  errlog file is  the same folder as calling application
			//It is in the bin folder of the ASP.NET application
			if (m_strErrorLogFileName == null || m_strErrorLogFileName.Length == 0)
			{
				m_strErrorLogFileName =  Path.Combine(GetCallingAssemblyFolder(), "ErrorLog.xml");	
			}
				//Only file name, put in the same folder as calling application
			else if (m_strErrorLogFileName.IndexOf("/") == -1)
			{
				m_strErrorLogFileName =  Path.Combine(GetCallingAssemblyFolder(), m_strErrorLogFileName);	
			}
				//virtual path (website)
			else if (m_strErrorLogFileName.StartsWith("/"))  
			{
				m_strErrorLogFileName = HttpContext.Current.Server.MapPath(m_strErrorLogFileName);
			}
				//only folder
			else if (m_strErrorLogFileName.EndsWith("/"))  
			{
				m_strErrorLogFileName = Path.Combine(m_strErrorLogFileName, "ErrorLog.xml");	
			}

			if (m_strErrorLogEventName == null || m_strErrorLogEventName.Length == 0)
			{
				m_strErrorLogEventName = "Web Error Log";
			}
		}
		#endregion

		

	}
}
