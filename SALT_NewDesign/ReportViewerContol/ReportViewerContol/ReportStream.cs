/*=====================================================================
  File:     ReportStream.cs
  
This class is used to display images in the report, such as chart.
  
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
	///This class is used to display images in the report, such as chart.
	/// </summary>
	public class ReportStream: ReportBasePage
	{
		private void Page_Load(object sender, System.EventArgs e)
		{
			byte[] content;
			string mimeType;
			
			//1.Get image content
			content = this.GetContent(out mimeType);
			
			//2. output image
			//Don't call this. the image will be cached in 10 minutes, this will improve performance
			//Response.ClearContent();
			//Response.ClearHeaders();

			//Response.Write(DateTime.Now.ToLongTimeString());

			Response.ContentType = mimeType;
			Response.AppendHeader("Content-Length", content.Length.ToString());
			Response.BinaryWrite(content);

		}

		/// <summary>
		/// Renders content via SOAP
		/// </summary>
		/// <returns></returns>
		private byte[] GetContent(out string mimeType)
		{
			//ReportingService2005 rs;
            ReportExecutionService rsExec;
			byte[] content;
			//In argements
			string deviceInfo;
            ReportExecution20051.ParameterValue[] parameterValues;
            //ReportExecutionService2005.ReportParameter[] _parameters = null;
            //string  _report = null;
            string _historyID = null;
            //bool _forRendering = false;
            //ReportExecutionService2005.ParameterValue[] _values = null;
            //ReportExecutionService2005.DataSourceCredentials[] _credentials = null;
			//Out arguments
			string encoding;

			//1. Get input arguments
			// Set html device information
			deviceInfo = "";
			//Get report parameters
			parameterValues = this.ReportParameters;

			//2. Get reporting web service
            //rs = Util.GetReportingService(this.SessionID);
            rsExec = Util.GetReportExecutionService(this.SessionID);

			//3. Call render web service	
			//content = rsExec.RenderStream(this.Settings.ReportFolder + this.ReportPath, this.Format,this.StreamID, null, deviceInfo, parameterValues, out encoding, out mimeType);


            // Get if any parameters needed.
            //_parameters =  rs.GetReportParameters(this.Settings.ReportFolder + this.ReportPath, _historyID, _forRendering, _values, _credentials);

            // Load the selected report.



            ExecutionHeader EH = new ExecutionHeader();
            EH.ExecutionID = this.SessionID;

            rsExec.ExecutionHeaderValue = EH;
            
           
            // rsExec.LoadReport(this.Settings.ReportFolder + this.ReportPath, _historyID);
            // Prepare report parameter.
            // Set the parameters for the report needed.
            //ReportExecutionService2005.ParameterValue[] parameters =
                  // new ReportExecutionService2005.ParameterValue[1];


            //rsExec.SetExecutionParameters(this.ReportParameters, "en-us");

            //content = rsExec.Render(this.Format, deviceInfo, out extension, out mimeType, out encoding, out warnings, out streamIDs);

            content = rsExec.RenderStream(this.Format, this.StreamID, deviceInfo, out encoding, out mimeType);

            // Create a file stream and write the report to it
            //using (FileStream stream = File.OpenWrite("c:\\BinStream"))
            //{
            //    stream.Write(content, 0, content.Length);
            //    stream.Close();
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
