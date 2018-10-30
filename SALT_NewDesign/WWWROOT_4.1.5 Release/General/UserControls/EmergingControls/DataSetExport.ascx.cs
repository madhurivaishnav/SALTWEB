using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Bdw.Application.Salt.Data;
using System.IO;
using System.Text;
using System.ComponentModel;
using System.Collections.Specialized;
using System.Diagnostics;
using System.Web.Services.Protocols;
using Bdw.SqlServer.Reporting.ReportService20051;
using Bdw.SqlServer.Reporting.ReportExecution20051;
using Bdw.SqlServer.Reporting.WebControls;
using Bdw.SqlServer.Reporting;
using System.Text.RegularExpressions;


namespace Bdw.Application.Salt.Web.General.UserControls.EmergingControls
{
    public partial class DataSetExport : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public enum ExportType
        {
            PDF = 1,
            Excel = 2,
            CSV = 3,
            Word = 4
        }


        public void ExportDataSetNew(string SP_Name, string Param1, string Param2, string Param3, string CurrentCultureName, ExportType FileType, String FileName, String ReportTitle, String LangInterfaceName, String LangResourceName, String Expanded)
        {
            Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[] reportParameters = null;
            reportParameters = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[9];
            reportParameters[0] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
            reportParameters[0].Name = "SP_Name";
            reportParameters[0].Value = SP_Name;
            reportParameters[1] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
            reportParameters[1].Name = "Param1";
            reportParameters[1].Value = Param1;
            reportParameters[2] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
            reportParameters[2].Name = "Param2";
            reportParameters[2].Value = Param2;
            reportParameters[3] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
            reportParameters[3].Name = "Param3";
            reportParameters[3].Value = Param3;
            reportParameters[4] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
            reportParameters[4].Name = "CurrentCultureName";
            reportParameters[4].Value = CurrentCultureName;
            reportParameters[5] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
            reportParameters[5].Name = "LangInterfaceName";
            reportParameters[5].Value = LangInterfaceName;
            reportParameters[6] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
            reportParameters[6].Name = "Expanded";
            reportParameters[6].Value = Expanded;
            reportParameters[7] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
            reportParameters[7].Name = "ReportTitle";
            reportParameters[7].Value = ReportTitle;
            reportParameters[8] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
            reportParameters[8].Name = "LangResourceName";
            reportParameters[8].Value = LangResourceName;



            String format = "DOC";
            if (FileType == ExportType.CSV) { format = "CSV"; };
            if (FileType == ExportType.PDF) { format = "PDF"; };
            if (FileType == ExportType.Excel) { format = "XLS"; };


            string thecontent;
            string[] streamIDs = null;

            Bdw.SqlServer.Reporting.ReportService20051.ReportingService2005 rs;
            Bdw.SqlServer.Reporting.ReportExecution20051.ReportExecutionService rsExec;


            rs = GetReportingService();
            rsExec = GetReportExecutionService();
            ReportSettings settings = GetSettings();
            string encoding;
            string mimeType;
            string _historyID = null;

            Bdw.SqlServer.Reporting.ReportExecution20051.Warning[] warnings = null;

            string extension = null;
            Bdw.SqlServer.Reporting.ReportExecution20051.ExecutionInfo ei = rsExec.LoadReport(settings.ReportFolder+ "/GridExport", _historyID);
            //rsExec.ExecutionHeaderValue.ExecutionID = SessionID;

            rsExec.SetExecutionParameters(reportParameters, "en-us");

            string Format = "HTML4.0";
            if (FileType == ExportType.PDF) Format = "PDF";
            if (FileType == ExportType.Word) Format = "WORD";
            if (FileType == ExportType.CSV) Format = "CSV";
            if (FileType == ExportType.Excel) Format = "EXCEL";
            //string deviceInfo = "<DeviceInfo><HTMLFragment>True</HTMLFragment><Toolbar>False</Toolbar><Section>0</Section><StreamRoot>{Emerging.Systems.MultipartMime}</StreamRoot></DeviceInfo>";
            string deviceInfo = "<DeviceInfo><Encoding>ASCII</Encoding></DeviceInfo>";
            Bdw.SqlServer.Reporting.ReportExecution20051.PageCountMode Exact = new Bdw.SqlServer.Reporting.ReportExecution20051.PageCountMode();

            Exact = Bdw.SqlServer.Reporting.ReportExecution20051.PageCountMode.Actual;

            //byte[] content = rsExec.Render2(Format, deviceInfo, Exact, out extension, out mimeType, out encoding, out warnings, out streamIDs);
            byte[]  content = rsExec.Render(Format, deviceInfo, out extension, out mimeType, out encoding, out warnings, out streamIDs);

            Response.ClearContent();
            Response.ClearHeaders();
            Response.ContentType = mimeType;
            Response.AppendHeader("Content-Length", content.Length.ToString());
            Response.AddHeader("content-disposition", "attachment; filename=\"" + FileName + "." + extension + "\"");
            Response.BinaryWrite(content);

            Response.Flush();
            Response.Close();
                
            
        }

        public void ExportDataSet(string SP_Name, string Param1, string Param2, string Param3, string CurrentCultureName, ExportType FileType, String FileName)
        {


            using (StoredProcedure sp = new StoredProcedure(SP_Name,
          StoredProcedure.CreateInputParam("@Param1", SqlDbType.NVarChar, 4000, Param1),
          StoredProcedure.CreateInputParam("@Param2", SqlDbType.NVarChar, 4000, Param2),
          StoredProcedure.CreateInputParam("@Param3", SqlDbType.NVarChar, 4000, Param3),
          StoredProcedure.CreateInputParam("@CurrentCultureName", SqlDbType.NVarChar, 4000, CurrentCultureName)


          ))
            {
                DataTable dt = sp.ExecuteTable();
                System.Text.StringBuilder builder = new System.Text.StringBuilder();

                if (FileType == ExportType.CSV)
                {
                    using (StoredProcedure sph = new StoredProcedure("prcGridExport_Headers",
                  StoredProcedure.CreateInputParam("@LangInterfaceName", SqlDbType.NVarChar, 4000, "/Reporting/PeriodicReport.aspx"),
                  StoredProcedure.CreateInputParam("@CurrentCultureName", SqlDbType.NVarChar, 40, CurrentCultureName)


                  ))
                    {
                        DataTable dth = sph.ExecuteTable();
                        string headerToExport = string.Empty;
                        foreach (DataColumn col in dth.Columns)
                            headerToExport += (char)34 + dth.Rows[0][col].ToString() + (char)34 + (char)44;
                        headerToExport.Remove(headerToExport.Length - 1, 1);
                        headerToExport = headerToExport + Environment.NewLine + Environment.NewLine;
                        builder.Append(headerToExport);
                    }
                    string body = string.Empty;
                    foreach (DataRow row in dt.Rows)
                    {
                        foreach (object obj in row.ItemArray) body = body + obj.ToString() + (char)44;
                        body.Remove(body.Length - 1, 1);
                        body = body + Environment.NewLine;
                    }
                    builder.Append(body);
                    builder.Append(Environment.NewLine);
                    builder.Append(Environment.NewLine);
                    Response.ContentType = "application/ms-excel;charset=UTF-8;";
//                    Response.ContentType = "application/text; charset=UTF-8";
//                    Response.ContentType = "application/text; charset=Unicode";
//                    Response.ContentEncoding = new UnicodeEncoding();
                    Response.ContentEncoding = System.Text.Encoding.UTF8;


                    //Response.ContentType = "application/ms-word"; 
                    string extension = ".CSV";
                    Response.AddHeader("content-disposition", "attachment;filename=" + FileName + extension);
                    Response.Charset = "UTF-8";

                    Response.Write('\uFEFF');
                    Response.Write(builder.ToString());
                    Response.Flush();
                    Response.End();
                }
                if (FileType == ExportType.Excel)
                {
                    //Create a dummy GridView

                    GridView GridView1 = new GridView();
                    GridView1.AllowPaging = false;
                    GridView1.DataSource = dt;
                    GridView1.DataBind();
                    Response.Clear();
                    Response.Buffer = true;
                    string extension = ".XLS";
                    Response.AddHeader("content-disposition", "attachment;filename=" + FileName + extension);
                    Response.Charset = "";
                    Response.ContentType = "application/vnd.ms-excel";
                    StringWriter sw = new StringWriter();
                    HtmlTextWriter hw = new HtmlTextWriter(sw);
                    for (int i = 0; i < GridView1.Rows.Count; i++)
                    {
                        //Apply text style to each Row
                        GridView1.Rows[i].Attributes.Add("class", "textmode");
                    }

                    GridView1.RenderControl(hw);
                    //style to format numbers to string

                    string style = @"<style> .textmode { mso-number-format:\@; } </style>";
                    Response.Write(style);
                    Response.Output.Write(sw.ToString());
                    Response.Flush();
                    Response.End();
                }

            }
        }
        public string LocalisedFileName(string LangInterfaceName, string LangResourceName, string CurrentCultureName)
        {
            using (StoredProcedure sp = new StoredProcedure("prcLocalisationGet",
            StoredProcedure.CreateInputParam("@LangInterfaceName", SqlDbType.NVarChar, 4000, LangInterfaceName),
            StoredProcedure.CreateInputParam("@LangResourceName", SqlDbType.NVarChar, 4000, LangResourceName),
            StoredProcedure.CreateInputParam("@CurrentCultureName", SqlDbType.NVarChar, 4000, CurrentCultureName)
            ))
            {
                string FileName = "";
                try
                {
                    FileName = sp.ExecuteScalar().ToString();
                    if ((FileName.Equals("")) | (FileName == null)) { FileName = "Periodic Report Schedules"; }
                }
                catch
                {
                    FileName = "Periodic Report Schedules";
                }
                return FileName;
            }
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

            Regex r = new Regex(@"Page d of (?<pagecount>\d+), pageHits", RegexOptions.Compiled);

            string pageCount = r.Match(html).Result("${pagecount}");

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
            int tablePosition = html.IndexOf("<TABLE ", position);
            //If the specified td pattern is in the outermost table, remove the widht="100%"
            if (tablePosition == -1)
            {
                html = html.Substring(0, position) + "<TD HEIGHT=\"0\"></TD>" + html.Substring(position + Const_TD.Length);
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
            return "<P style=\"font-family: Verdana; font-size: 11px\">" + message + "</P>";
        }
        /// <summary>
        /// Get the default file name for download
        /// </summary>
        /// <param name="reportPath"></param>
        /// <param name="mimeType"></param>
        /// <returns></returns>
        public static string GetFileName(string reportPath, string mimeType)
        {
            string fileName = Path.GetFileName(reportPath);
            string fileExt = null;

            switch (mimeType.ToLower())
            {
                case "application/pdf": fileExt = "pdf"; break;
                case "application/vnd.ms-excel": fileExt = "xls"; break;
                case "text/xml": fileExt = "xml"; break;
                case "image/tiff": fileExt = "tif"; break;
                case "text/html": fileExt = "htm"; break;
                case "text/plain": fileExt = "txt"; break;
                case "multipart/related": fileExt = "mhtml"; break;
                case "text/csv": fileExt = "csv"; break;
                default: fileExt = ""; break;
            }

            fileName = fileName + "." + fileExt;

            return fileName;
        }

        /// <summary>
        /// Get Reporting Service and setup the service
        /// </summary>
        /// <returns></returns>
        public static ReportExecutionService GetReportExecutionService()
        {
            Bdw.SqlServer.Reporting.ReportExecution20051.ReportExecutionService rsExec = new Bdw.SqlServer.Reporting.ReportExecution20051.ReportExecutionService();
            ReportSettings settings = GetSettings();
            //1. Setup reporting service
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
        public static ReportingService2005 GetReportingService()
        {
            ReportingService2005 rs = new ReportingService2005();
            ReportSettings settings = GetSettings();
            //1. Setup reporting service
            //rs.Url = this.ServerUrl + "/ReportService2005.asmx";
            rs.Url = settings.ReportServer + "/ReportService2005.asmx";
            //Set authentication
            if (settings.CredentialUserName == "")
            {
                rs.Credentials = System.Net.CredentialCache.DefaultCredentials;
            }
            else
            {
                rs.Credentials = new System.Net.NetworkCredential(settings.CredentialUserName, settings.CredentialPassword, settings.CredentialDomain);
            }


            //Set session header
            //TODO			rs.SessionHeaderValue = new SessionHeader();

            {
                //TODO				rs.SessionHeaderValue.SessionId = sessionID;
            }

            return rs;
        }



        /// <summary>
        /// Get report parameter's values from session
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <returns></returns>
        public static Bdw.SqlServer.Reporting.ReportService20051.ParameterValue[] GetReportParameters(string sessionID)
        {

            Bdw.SqlServer.Reporting.ReportService20051.ParameterValue[] reportParameters = new Bdw.SqlServer.Reporting.ReportService20051.ParameterValue[0];

            reportParameters = (Bdw.SqlServer.Reporting.ReportService20051.ParameterValue[])HttpContext.Current.Session[sessionID];

            if (reportParameters == null) throw new Exception("SESSION TIMEOUT: The required Browser session ID of " + sessionID + " could not be found (the current browser session = " + HttpContext.Current.Session.SessionID.ToString() + "), session timeout = " + HttpContext.Current.Session.Timeout.ToString() + " minutes. Has " + HttpContext.Current.Session.Timeout.ToString() + " minutes expired since you first displayed the Report?");

            return reportParameters;
        }

        /// <summary>
        /// Save Report Parameters  to session
        /// </summary>
        /// <param name="sessionID"></param>
        /// <param name="reportParameters"></param>
        public static void SaveReportParameters(string sessionID, Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[] reportParameters)
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
        public static Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[] ConvertReportParameters(Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[] parameters)
        {
            Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[] reportParameters = null;

            reportParameters = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[40];
            reportParameters = parameters;

            return reportParameters;
        }
        public static Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[] ConvertPeriodicReportParameters(Hashtable parameters)
        {
            Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[] reportParameters = null;

            reportParameters = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue[parameters.Count];
            // set the report parameters
            if (parameters.Count > 0)
            {

                int i = 0;
                foreach (DictionaryEntry parameter in parameters)
                {
                    try
                    {
                        reportParameters[i] = new Bdw.SqlServer.Reporting.ReportExecution20051.ParameterValue();
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
    }
}