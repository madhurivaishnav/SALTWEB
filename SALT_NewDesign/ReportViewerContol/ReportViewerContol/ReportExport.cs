/*=====================================================================
  File:     ReportExport.cs
  
This class is used to export a report to different formats such as PDF, Excel.
  
=====================================================================*/
using System;
using System.ComponentModel;
using System.Collections;
using System.Collections.Specialized;
using System.Text;
using System.IO;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Diagnostics;

using System.Web.Services.Protocols;


using Bdw.SqlServer.Reporting.ReportService20051;
using Bdw.SqlServer.Reporting.ReportExecution20051;


namespace Bdw.SqlServer.Reporting
{
	/// <summary>
	/// Summary description for ExportReport.
	/// </summary>
	public class ReportExport: ReportBasePage
	{
		private void Page_Load(object sender, System.EventArgs e)
		{
			byte[] reportContent;
			string mimeType;
			string fileName;
			//1.Get report content
			reportContent = this.GetReportContent(out mimeType);
			fileName = Util.GetFileName(this.ReportPath, mimeType);

			//2. Output and force download
			Response.ClearContent();
			Response.ClearHeaders();

			Response.ContentType = mimeType;
			Response.AppendHeader("Content-Length", reportContent.Length.ToString());
			Response.AddHeader ("content-disposition", "attachment; filename=\"" + fileName + "\"");
			Response.BinaryWrite(reportContent);

			Response.Flush();
			Response.Close();

		}

		/// <summary>
		/// Renders the report via SOAP
		/// </summary>
		/// <returns></returns>
		private byte[] GetReportContent(out string mimeType)
		{
			//ReportingService2005 rs;
            ReportExecutionService rsExec;

			byte[] content;
			//In argements
			string deviceInfo;
            ReportExecution20051.ParameterValue[] parameterValues;

			//Out arguments
			string encoding;
            ReportExecution20051.Warning[] warnings = null;
            //ReportExecutionService2005.ParameterValue[] parametersUsed = null;
			string[] streamIDs = null;
            string extension = null;

            //In argements

            //ReportExecutionService2005.ReportParameter[] _parameters = null;
            //string _report = null;
            string _historyID = null;
            //bool _forRendering = false;
            //ReportExecutionService2005.ParameterValue[] _values = null;
            //ReportExecutionService2005.DataSourceCredentials[] _credentials = null;




			//1. Get input arguments
			// Set html device information
            //deviceInfo = "";
            deviceInfo = "<DeviceInfo><Encoding>UTF-8</Encoding></DeviceInfo>";
            //Get report parameters
			parameterValues = this.ReportParameters;
			

			//2. Get reporting web service
			//rs = Util.GetReportingService(this.SessionID);
            rsExec = Util.GetReportExecutionService(this.SessionID);

            //3. Call render web service	
//			content = rs.Render(this.Settings.ReportFolder + this.ReportPath, this.Format, null, deviceInfo, parameterValues, null, null, 
//				out encoding, out mimeType, out parametersUsed, out warnings,out streamIDs);









            // Get if any parameters needed.
            //_parameters = rs.GetReportParameters(this.Settings.ReportFolder + this.ReportPath, _historyID, _forRendering, _values, _credentials);

            // Load the selected report.
            ReportExecution20051.ExecutionInfo ei = rsExec.LoadReport(this.Settings.ReportFolder +this.ReportPath, _historyID);
            rsExec.ExecutionHeaderValue.ExecutionID = this.SessionID;

            // Prepare report parameter.
            // Set the parameters for the report needed.
            ReportExecution20051.ParameterValue[] parameters =
                   new ReportExecution20051.ParameterValue[1];


            rsExec.SetExecutionParameters(this.ReportParameters, "en-us");
            rsExec.Timeout = System.Threading.Timeout.Infinite;
            content = rsExec.Render(this.Format, deviceInfo, out extension, out mimeType, out encoding, out warnings, out streamIDs);

            // Create a file stream and write the report to it
            //            using (FileStream stream = File.OpenWrite(fileName))
            //{
                //                stream.Write(results, 0, results.Length);
            //}











			//4. Session Validation
			if (this.Settings.SessionValidation)
			{
                if (rsExec.ExecutionHeaderValue.ExecutionID != this.SessionID)
				{
					throw new ApplicationException("Session timeout");
				}
			}




			return content;
		}
		
	}

}
