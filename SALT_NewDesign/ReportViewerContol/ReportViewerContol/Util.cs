using System;
using System.ComponentModel;
using System.Collections;
using System.Collections.Specialized;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Drawing;
using System.Drawing.Design;

using System.Diagnostics;
using System.Reflection;

using System.Web.Security;

using System.Web.Services.Protocols;


using Bdw.SqlServer.Reporting.ReportService20051;
using Bdw.SqlServer.Reporting.ReportExecution20051;


namespace Bdw.SqlServer.Reporting
{
	/// <summary>
	/// Summary description for Util.
	/// </summary>
	internal abstract class Util
	{

		//Get Embedded Resource text by file name
		internal static string GetResource(string fileName)
		{
			Assembly assembly = Assembly.GetExecutingAssembly();
			//name = DefaultNamespace.folder.filename.ext
			Stream stream=assembly.GetManifestResourceStream("Bdw.SqlServer.Reporting.Resources." + fileName);
			StreamReader reader = new StreamReader(stream);
			string text = reader.ReadToEnd();

			return text;
		}	


		/// <summary>
		/// Get the page count for pagination
		/// </summary>
		/// <remarks>
		/// This method is expected to be replaced by the web service API in the new version.
		/// Microsoft Reporting service doesn't provide API to get Page count.
		/// This is a way to work around it. 
		/// The page count is embeded in a javascript function of the html content.
		/// Note: When call the render API, put this in the device information: <DeviceInfo><Toolbar>True</Toolbar><HTMLFragment>False</HTMLFragment><Section>1</Section></DeviceInfo>
		/// and the outoutput must be HTML4.0 (HTML3.2 don't output java script)
		/// </remarks>
		/// <param name="html"></param>
		/// <returns></returns>
		public static int GetPageCount(string html)
		{
			/*
			 * Example javascript funciton in html
			function OnLoadReport()
			{
				var pageHits = null;
				var rep = new Report(1, 8, pageHits, false, docMapIds);
				if (parent != self) parent.OnLoadReport(rep);
			}
			*/

			Regex r = new Regex(@"Page d of (?<pagecount>\d+), pageHits",RegexOptions.Compiled);

			string pageCount=  r.Match(html).Result( "${pagecount}");

			return int.Parse(pageCount);

		}

		/// <summary>
		/// Format the html frament to support other browsers such as Firefox, netscape etc
		/// </summary>
		/// <remarks>
		/// The html is not displayed very well in Firefox.
		/// In the bottom of the html, there is a td with "width="100%", it need to be removed.
		/// This method may not work properly if Microsoft change the design of Reporting service in the new version
		/// </remarks>
		/// <param name="html"></param>
		/// <returns></returns>
		public static string FormatHtml(string html)
		{
			/*
					<TD WIDTH="100%" HEIGHT="0"></TD>
				</TR>
				<TR>
					<TD WIDTH="0" HEIGHT="100%"></TD>
				</TR>
			</TABLE>
			*/
			const string Const_TD = "<TD WIDTH=\"100%\" HEIGHT=\"0\"></TD>";

			int position = html.LastIndexOf(Const_TD);
			int tablePosition = html.IndexOf("<TABLE ",position);
			//If the specified td pattern is in the outermost table, remove the widht="100%"
			if (tablePosition==-1)
			{
				html = html.Substring(0,position) + "<TD HEIGHT=\"0\"></TD>" + html.Substring(position+Const_TD.Length);
			}
			
			return html;
		}

		/// <summary>
		/// Output error message to screen
		/// </summary>
		/// <param name="message"></param>
		/// <returns></returns>
		public static string MessageToHTML(string message)
		{
			return "<P style=\"font-family: Verdana; font-size: 11px\">" + message + "</P>" ;
		}
		/// <summary>
		/// Get the default file name for download
		/// </summary>
		/// <param name="reportPath"></param>
		/// <param name="mimeType"></param>
		/// <returns></returns>
		public static string GetFileName (string reportPath, string mimeType)
		{
			string fileName = Path.GetFileName(reportPath);
			string fileExt = null;

			switch (mimeType.ToLower())
			{
				case "application/pdf"				: fileExt = "pdf"; break;
				case "application/vnd.ms-excel"		: fileExt = "xls"; break;
				case "text/xml"						: fileExt = "xml"; break;
				case "image/tiff"					: fileExt = "tif"; break;
				case "text/html"					: fileExt = "htm"; break;
				case "text/plain"					: fileExt = "txt"; break;
				case "multipart/related"			: fileExt = "mhtml"; break;
				case "text/csv"					    : fileExt = "csv"; break;                    
				default								: fileExt = ""; break;
			}

			fileName = fileName + "." + fileExt;

			return fileName;
		}

        /// <summary>
        /// Get Reporting Service and setup the service
        /// </summary>
        /// <returns></returns>
        public static ReportExecution20051.ReportExecutionService GetReportExecutionService(string sessionID)
        {
            ReportExecution20051.ReportExecutionService rsExec = new ReportExecution20051.ReportExecutionService();
            ReportSettings settings = Util.GetSettings();
            //1. Setup reporting service
            //rs.Url = this.ServerUrl + "/ReportService2005.asmx";
            rsExec.Url = settings.ReportServer + "/ReportExecution2005.asmx";
            //Set authentication
            if (settings.CredentialUserName == "")
            {
                rsExec.Credentials = System.Net.CredentialCache.DefaultCredentials;
            }
            else
            {
               // rsExec.Credentials = System.Net.CredentialCache.DefaultCredentials;
                rsExec.Credentials = new System.Net.NetworkCredential(settings.CredentialUserName, settings.CredentialPassword, settings.CredentialDomain);
            }



            return rsExec;
        }

		/// <summary>
		/// Get Reporting Service and setup the service
		/// </summary>
		/// <returns></returns>
        public static ReportingService2005 GetReportingService(string sessionID)
		{
            ReportingService2005 rs = new ReportingService2005();
			ReportSettings  settings = Util.GetSettings();
			//1. Setup reporting service
			//rs.Url = this.ServerUrl + "/ReportService2005.asmx";
			rs.Url =  settings.ReportServer + "/ReportService2005.asmx";
			//Set authentication
			if (settings.CredentialUserName=="")
			{
				rs.Credentials = System.Net.CredentialCache.DefaultCredentials;
			}
			else
			{
				rs.Credentials = new System.Net.NetworkCredential(settings.CredentialUserName,settings.CredentialPassword, settings.CredentialDomain);
			}
			
			
			//Set session header
//TODO			rs.SessionHeaderValue = new SessionHeader();
			
			{
//TODO				rs.SessionHeaderValue.SessionId = sessionID;
			}

			return rs;
		}

		/*
		/// <summary>
		/// Get report parameter's values
		/// </summary>
		/// <remarks>
		/// This method is called in the export and stream rendering.
		/// It gets sessionGuid id from querystring and gets parameter value array from session
		/// </remarks>
		/// <param name="parameters">It is from query string</param>
		/// <returns></returns>
		public static ParameterValue[] GetReportParameters(NameValueCollection parameters)
		{
			Hashtable paras;

			ParameterValue[] reportParameters = null;

			paras =(Hashtable)HttpContext.Current.Session[Util.GetSessionID()];
			
			reportParameters = Util.GetReportParameters(paras);
			
			return reportParameters;
		}
		*/

		/// <summary>
		/// Get report parameter's values from session
		/// </summary>
		/// <remarks>
		/// </remarks>
		/// <returns></returns>
		public static ReportExecution20051.ParameterValue[] GetReportParameters(string sessionID)
		{

            ReportExecution20051.ParameterValue[] reportParameters = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[0];
            
            reportParameters = (ReportExecution20051.ParameterValue[])HttpContext.Current.Session[sessionID];

            if (reportParameters == null) throw new Exception("SESSION TIMEOUT: The required Browser session ID of " + sessionID + " could not be found (the current browser session = " + HttpContext.Current.Session.SessionID.ToString() + "), session timeout = " + HttpContext.Current.Session.Timeout.ToString()+" minutes. Has " + HttpContext.Current.Session.Timeout.ToString()+" minutes expired since you first displayed the Report?");

			return reportParameters;
		}

		/// <summary>
		/// Save Report Parameters  to session
		/// </summary>
		/// <param name="sessionID"></param>
		/// <param name="reportParameters"></param>
        public static void SaveReportParameters(string sessionID, ReportExecution20051.ParameterValue[] reportParameters)
		{
			HttpContext.Current.Session[sessionID] = reportParameters;
		}


		/// <summary>
		/// Get report parameter's values
		/// </summary>
		/// <remarks>
		/// This method is called in the ReportViewer control
		/// </remarks>
		/// <param name="parameters"></param>
		/// <returns></returns>
        public static ReportExecution20051.ParameterValue[] ConvertReportParameters(Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[] parameters)
        {
            ReportExecution20051.ParameterValue[] reportParameters = null;

            reportParameters = new ReportExecution20051.ParameterValue[40];
            reportParameters = parameters;

            return reportParameters;
        }
        public static ReportExecution20051.ParameterValue[] ConvertPeriodicReportParameters(Hashtable parameters)
		{
            ReportExecution20051.ParameterValue[] reportParameters = null;
			
            reportParameters = new ReportExecution20051.ParameterValue[parameters.Count];
			// set the report parameters
			if (parameters.Count>0)
			{
				
				int i = 0;
				foreach (DictionaryEntry parameter in parameters )
				{
                    try
                    {
                        reportParameters[i] = new ReportExecution20051.ParameterValue();
                        reportParameters[i].Name = parameter.Key.ToString();
                        if (parameter.Value is DateTime)
                        {
                            //yyyy'-'MM'-'dd'T'HH':'mm':'ss (SortableDateTimePattern)
                            reportParameters[i].Value = ((DateTime)parameter.Value).ToString("s");
                        }
                        else
                        {
                            reportParameters[i].Value = parameter.Value.ToString();

                        }
                    }
                    catch (Exception Ex)
                    {
                    }
                i++;
            
				}
			}

			return reportParameters;
		}
		/*
		/// <summary>
		/// Obsolete:use session to store parameters.
		/// Get report parameters querystring.
		/// </summary>
		/// <remarks>
		/// It is used for exporting to different format and image stream
		/// </remarks>
		/// <param name="parameters"></param>
		/// <returns></returns>
		public static string GetReportParameters(ParameterValue[] parameters)
		{
			string reportParameters = "";

			// set the report parameters
			if (parameters!=null && parameters.Length>0)
			{
				foreach (ParameterValue parameter in parameters )
				{
					reportParameters += ("&" + parameter.Name +"=" + HttpContext.Current.Server.UrlEncode(parameter.Value));
				}
			}

			return reportParameters;
		}
		/// <summary>
		/// Obsolete:use session to store parameters.
		/// The report image stream, export expose parameters to end user.
		/// User may call the url directly without login, or change the parameter value
		/// </summary>
		/// <param name="parameters"></param>
		/// <returns></returns>
		public static string GetParasHashValue(ParameterValue[] parameters)
		{
			string parasValue="";
			
			// set the report parameters
			if (parameters!=null && parameters.Length>0)
			{
				foreach (ParameterValue parameter in parameters )
				{
					parasValue +=","+parameter.Value;
				}
			}
			
			string parasHashValue = FormsAuthentication.HashPasswordForStoringInConfigFile(parasValue, "MD5");

			return parasHashValue;
		}
		*/
		/// <summary>
		/// Get report service setting
		/// </summary>
		/// <returns></returns>
		public static ReportSettings GetSettings()
		{
			ReportSettings settings = (ReportSettings)System.Configuration.ConfigurationSettings.GetConfig("ReportSettings");
			
			return settings;
		}
		
//		public static string GetSessionID()
//		{
//		   return HttpContext.Current.Request.QueryString["rs:SessionID"];
//		}
//		
//		public static void ClearSession()
//		{
//			HttpContext.Current.Session.Clear();
//		}

	}
}
