/*=====================================================================
  File:     ReportViewer.cs
  
This class is used to render navigation bar and HTML content in a web browser.
  
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

using System.Drawing;
using System.Drawing.Design;

using System.Diagnostics;

using System.Web.Services.Protocols;

using Bdw.SqlServer.Reporting;

using Bdw.SqlServer.Reporting.ReportService20051;
using Bdw.SqlServer.Reporting.ReportExecution20051;

using Localization;

namespace Bdw.SqlServer.Reporting.WebControls
{
	[
	ParseChildren(false),
	ToolboxData("<{0}:ReportViewer runat=server></{0}:ReportViewer>"),
	//Designer(typeof(ReportViewerDesigner)),
	]
	public class ReportViewer : Control, INamingContainer, IPostBackEventHandler
	{

		#region Private Member Variables
		/// <summary>
		/// The path used for prefixing the value of the src attribute of the IMG element in the HTML report returned by the report server. 
		/// By default, the report server provides the path. You can use this setting to specify a root path for the images in a report (for example, http://myserver/resources/companyimages).
		/// </summary>
		private string _cssClass;
		private string _reportPath;
		/// <summary>
		/// This stores the values of user defined parameters. they are name(parameter),  value pair
		/// </summary>
		private Hashtable _parameters
        {
            get
            {
                return (Hashtable)ViewState["_parameters"];
            }
            set
            {
                ViewState["_parameters"] = value;
            }
        }
        private ReportExecution20051.ParameterValue[] _parameterValues;

		private ReportSettings _settings;
		//the report rendering content
		private string _content;

		//		private string _systemFolder="/reportviewer";
		//		private string _serverUrl = "http://localhost/reportserver";


		#endregion


		#region public Propertes
		/// <summary>
		/// The CssClass for the TreeNode
		/// </summary>
		[
		Browsable(true), 
		Description("The CssClass for the TreeNode"), 
		DefaultValue(""), 
		Category("Appearance") 
		] 
		public string  CssClass
		{ 
			get  
			{ 
				return this._cssClass;
			} 
			set
			{
				this._cssClass=value;
			} 
		} 


		
		[Category("Reporting Services"),
		Description("Report path such as /SampleReports/Company Sales")]
		public String ReportPath
		{
			get
			{
				return this._reportPath;
			}

			set
			{
				this._reportPath = value;
			}
		}

		/// <summary>
		///  Gets or sets the values of user defined parameters. they are name(parameter),  value pairs.
		/// </summary>
		[
		Browsable(false) 
		] 
		public Hashtable Parameters
		{
			get
			{
				/*
				if (HttpContext.Current.Session[Util.GetSessionID()]==null)
				{
					HttpContext.Current.Session[Util.GetSessionID()] = new Hashtable();
				}
				return (Hashtable)HttpContext.Current.Session[Util.GetSessionID()];
				*/
                if (this._parameters == null) this._parameters = new Hashtable();
				return this._parameters;
			}

			set
			{
				this._parameters = value;
			}
		}


		/// <summary>
		///  Gets or sets sessionID for the Render Web Service Method
		/// </summary>
		[
		Browsable(false) 
		] 
		public string SessionID
		{
			get
			{
				return (string)ViewState["SessionID"];
			}

			set
			{
				ViewState["SessionID"] = value;
			}
		}

		[Category("Action")]
		public event EventHandler PageIndexChanged;


		//		[Category("Reporting Services"),
		//		DefaultValue("http://localhost/reportserver"),
		//		Description("Gets or set server url such as http://localhost/reportserver")]
		//		public string ServerUrl
		//		{
		//			get
		//			{
		//				return this._serverUrl;
		//			}
		//			set
		//			{
		//				this._serverUrl = value;
		//			}
		//		}
		//
		//		[Category("Reporting Services"),
		//		DefaultValue("/reportviewer"),
		//		Description("Gets or sets the system folder that contains the navigation image, style sheets, and other supported files")
		//		]
		//		public string SystemFolder
		//		{
		//			get
		//			{
		//				return this._systemFolder;
		//			}
		//
		//			set
		//			{
		//				this._systemFolder = value;
		//			}
		//		}
		//


		#endregion

		#region private Propertes
		/// <summary>
		///  Gets report settings from application configuration file
		/// </summary>
		private ReportSettings Settings
		{
			get
			{
				return this._settings;
			}
		}

		/// <summary>
		///  Gets or set the total Page Count
		/// </summary>
		private int PageCount
		{
			get
			{
				if (ViewState["PageCount"]==null)
				{
					return -1;
				}
				else
				{
					return (int)ViewState["PageCount"];	
				}
			}
			set
			{
				ViewState["PageCount"] = value;
			}
		}


		/// <summary>
		///  The current Page Index
		/// </summary>
		private int PageIndex
		{
			get
			{
				if (ViewState["PageIndex"]==null)
				{
					return 1;
				}
				else
				{
					return (int)ViewState["PageIndex"];	
				}
			}
			set
			{
				ViewState["PageIndex"] = value;
			}
		}

		/// <summary>
		/// Get rendering HTML format
		/// </summary>
		private string Format
		{
			get
			{
				//If the client browser is IE6 and above, show HTML4.0 format, otherwise show html3.2 format
				if (HttpContext.Current.Request.Browser.Browser == "IE" && HttpContext.Current.Request.Browser.MajorVersion>=6)
				{
					return "HTML4.0";
				}
				else
				{
                    return "HTML4.0";
				}
			}
		}

		/// <summary>
		///  Gets parameter values
		/// </summary>
        private ReportExecution20051.ParameterValue[] ParameterValues
		{
			get
			{
				//if (this._parameterValues==null && this.Parameters.Count>0)
				//{
					// Set the report parameters
					this._parameterValues  = Util.ConvertPeriodicReportParameters(this.Parameters);
				//}

				return this._parameterValues;
			}
		}
		#endregion

		#region Constructors
		public ReportViewer()
		{
			//Input parameters
			_cssClass="";
			_reportPath = "";
			//_parameters = new Hashtable();

			_settings = Util.GetSettings();

			_parameterValues=null;

			_content= "";
			
			//HttpContext.Current.Session[this.UniqueID] =new Hashtable();
		}

      	#endregion

      
		#region private Methods

		/// <summary>
		/// Get parameters string for export and stream rendering
		/// </summary>
		/// <returns></returns>
		private string GetParameters()
		{
			string paras;

			//1. Get System parameters
			paras = "rs:ReportPath=" + HttpContext.Current.Server.UrlEncode(this.ReportPath);
			paras +="&rs:SessionID=" + this.SessionID;
			
			Util.SaveReportParameters(this.SessionID, this.ParameterValues);

			//Append parameter hash value for security check
			//string parasHashValue = Util.GetParasHashValue(this.ParameterValues);
			//paras += "&rs:ParasHash=" + parasHashValue;

			//2. Get reprot parameters
			//string reportParameters;
			//reportParameters = Util.GetReportParameters(this.ParameterValues);
			//paras += "&SessionGUID="+Guid.NewGuid().ToString("N");

			return paras;

		}

		/// <summary>
		/// Renders the report via SOAP
		/// </summary>
		/// <returns></returns>
		private string GetReportContent(bool toolbar)
		{
			ReportService20051.ReportingService2005 rs;
            ReportExecutionService rsExec;
            byte[] content;
			string html;

			//In argements
			string format;
			string deviceInfo;
            //ReportExecutionService2005.ReportParameter[] _parameters = null;
            //string _report = null;
            string _historyID = null;
            //bool _forRendering = false;
            //ReportExecutionService2005.ParameterValue[] _values = null;
            //ReportExecutionService2005.DataSourceCredentials[] _credentials = null;

            //Out arguments
			string encoding;
			string mimeType;
            //ReportExecutionService2005.ParameterValue[] parametersUsed = null;
			string[] streamIDs = null;
            ReportExecution20051.Warning[] warnings = null;
            string extension = null;

			//1 Get input arguments
			//Always using HTML 4.0 format if toolbar is required, this is used for retrieving the page count
			if (toolbar)
			{
				format = "HTML4.0";
			}
			else
			{
				format = this.Format;
			}

			// Set html device information
			deviceInfo = this.GetHTMLDeviceInfo(toolbar);

						
			//2. Get reporting web service
			rs = Util.GetReportingService(this.SessionID);
            rsExec = Util.GetReportExecutionService(this.SessionID);
            //rsExec.Credentials =  System.Net.CredentialCache.DefaultCredentials;


            //3 Call render web service	

//            content = rsExec.Render(format, deviceInfo, out extension, out encoding, out mimeType, out warnings, out streamIDs);




            ReportExecution20051.ExecutionInfo ei = new ExecutionInfo();

            // Load the selected report.
            try
            {

                ei = rsExec.LoadReport(this.Settings.ReportFolder + this.ReportPath, _historyID);
            }
			
			catch (Exception ex)
			{
				
				throw ex;
			}

            PageCountMode Exact = new PageCountMode();
            Exact = PageCountMode.Actual;
        
            
            rsExec.SetExecutionParameters(this.ParameterValues, "en-us");
            rsExec.Timeout = System.Threading.Timeout.Infinite;
            content = rsExec.Render2(format, deviceInfo, Exact, out extension, out mimeType, out encoding, out warnings, out streamIDs);
            ei = rsExec.GetExecutionInfo();
            this.PageCount = ei.NumPages;

            //content = rsExec.Render(this.Format, deviceInfo, out extension, out mimeType, out encoding, out warnings, out streamIDs);

            // Create a file stream and write the report to it
            //            using (FileStream stream = File.OpenWrite(fileName))
            //{
                //                stream.Write(results, 0, results.Length);
            //}




            if (!toolbar) html = Encoding.UTF8.GetString(content);
            else html = "";

			//4. Save session value

			//Save the sessionID for later use
            //this.SessionID = ei.ExecutionID;
            this.SessionID = rsExec.ExecutionHeaderValue.ExecutionID;
			
			return html;
		}
		
		/// <summary>
		/// Set html device information
		/// </summary>
		/// <param name="toolbar"></param>
		/// <returns></returns>
		private string GetHTMLDeviceInfo(bool toolbar)
		{
			string info;
            if (toolbar) this.PageIndex = 1;
			info = "<DeviceInfo>";
            if (!toolbar) info += "<HTMLFragment>True</HTMLFragment>";
            //if (!toolbar) info += "<Parameters>False</Parameters>";
            //if (toolbar) info += "<Parameters>False</Parameters>";
            if (!toolbar) info += "<Toolbar>False</Toolbar>"; //allow room for our toolbar or page will exceed paper size when we add our toolbar
            if (toolbar) info += "<Toolbar>False</Toolbar>";
            if (toolbar) info += "<Section>0</Section>";
            if (!toolbar) info += "<Section>" + this.PageIndex.ToString() + "</Section>";
            if (!toolbar) info += "<StreamRoot>{ReportStream.aspx}</StreamRoot>";
			info +="</DeviceInfo>";

			return info;
		}

		/// <summary>
		/// Get toobar html
		/// It includes page navigation, export to different formats
		/// </summary>
		/// <remarks>
		/// Tool bar Layout:
		/// First Button, Previous Button, Page Num List, Next Button, Last Button, Export Format List, Export Button
		/// </remarks>
		/// <returns></returns>
		private string GetToolbarHtml()
		{
			string html;

			string header = @"<!-- TOOLBAR -->
							<table cellpadding=""0"" cellspacing=""0"" width=""600"">
								<TBODY>
								<tr>";

			string interWidget = @"<td class=""ReportViewer_Toolbar_InterWidget""></td>";
			string pageButton = @"<td onmouseover=""className ='ReportViewer_Toolbar_HoverButton';"" onmouseout=""className = 'ReportViewer_Toolbar_NormalButton';"" class=""ReportViewer_Toolbar_NormalButton"">
											<img class=""ReportViewer_Toolbar_ImageWidget"" src=""{SystemFolder}/{Direction}Page.gif"" alt=""{Direction} " + ResourceManager.GetString("litPage") + @""" title=""{Direction} " + ResourceManager.GetString("litPage") + @""" onclick=""javascript: ReportViewer_GotoPage('{ControlID}', {PageNum});"" />
										</td>";

			string disabledPageButton = @"<td class=""ReportViewer_Toolbar_DisabledButton"">
												<img class=""ReportViewer_Toolbar_ImageWidget"" src=""{SystemFolder}/{Direction}PageDisabled.gif"" alt=""{Direction} " + ResourceManager.GetString("litPage") + @""" title=""{Direction} " + ResourceManager.GetString("litPage") + @""" />
											</td>";

			string pageNum = @"<td class=""ReportViewer_Toolbar_NormalButton"">
									<select size=""1"" {Disabled} class=""ReportViewer_Toolbar_{Disabled}Select"" onchange=""javascript:ReportViewer_SelectPage('{ControlID}', this);"" style=""WIDTH: 44px"">
										{PageList}
									</select>
									<span class=""ReportViewer_Toolbar_PageNumberText"">&nbsp;" + ResourceManager.GetString("litOf") + @"&nbsp;{PageCount}</span>
								</td>";

			string exportFormat = @"<td align=""right"">
											<select id=""{ControlClientID}_ExportFormat_{ToolbarPosition}"" size=""1"" style=""WIDTH: 212px"" class=""ReportViewer_Toolbar_Select"">
												<option selected>" + ResourceManager.GetString("litExportTitle") + @"</option>
														<option value=""PDF"">" + ResourceManager.GetString("litPDF") + @"</option>
														<option value=""EXCEL"">" + ResourceManager.GetString("litExcel") + @"</option>
														<option value=""CSV"">" + ResourceManager.GetString("litCSV") + @"</option>
														<!-- <option value=""XML"">XML file with report data</option>
														<option value=""IMAGE"">TIFF image file</option>
														<option value=""MHTML"">Web archive</option> -->
											</select>
									</td>";
			string exportButton = @"<td ><a class=""ReportViewer_Toolbar_ActiveLink"" href=""javascript:void(ReportViewer_Export('{ControlClientID}','{ToolbarPosition}', '{Parameters}'));""
											title=""" + ResourceManager.GetString("litExportTitle") + @""" >" + ResourceManager.GetString("litExport") + @"</a>
									</td>";

			string footer=@"</tr>
							</TBODY>
							</table>
						<!-- End of TOOLBAR -->";


			//1. Toolbar header
			html = header;
			
			//2. First Page Button
			html += interWidget;
			if (this.PageIndex==1)
			{
				html += disabledPageButton.Replace("{Direction}", "First");
			}
			else
			{
				html += pageButton.Replace("{Direction}", "First").Replace("{PageNum}","1");
			}

			//3. Previous Page Button
			html += interWidget;
			if (this.PageIndex==1)
			{
				html += disabledPageButton.Replace("{Direction}", "Previous");
			}
			else
			{
				html += pageButton.Replace("{Direction}", "Previous").Replace("{PageNum}",(this.PageIndex-1).ToString());
			}		
			
			//4. Page number
			html += interWidget;
			string pageList="";
			for(int i=1;i<=this.PageCount;i++)
			{
				if (i!=this.PageIndex)
				{
					pageList+="\n<option>" + i.ToString()+"</option>";
				}
				else
				{
					pageList+="\n<option selected>" + i.ToString()+"</option>";
				}
			}

			//disabled the page list control if the page count is 1
			string disabled = "";
			if (this.PageCount<=1)
				disabled = "Disabled";

			html += pageNum.Replace("{PageList}", pageList).Replace("{PageCount}",this.PageCount.ToString()).Replace("{Disabled}", disabled);

			//5. Next Page Button
			html += interWidget;
			if (this.PageIndex==this.PageCount)
			{
				html += disabledPageButton.Replace("{Direction}", "Next");
			}
			else
			{
				html += pageButton.Replace("{Direction}", "Next").Replace("{PageNum}",(this.PageIndex+1).ToString());
			}				
			
			//6. Last Page Button
			html += interWidget;
			if (this.PageIndex==this.PageCount)
			{
				html += disabledPageButton.Replace("{Direction}", "Last");
			}
			else
			{
				html += pageButton.Replace("{Direction}", "Last").Replace("{PageNum}",this.PageCount.ToString());
			}

			//7. Export format
			html += interWidget;
			html += interWidget;
			html += exportFormat;

			//Export Button
			html += interWidget;
			html += exportButton;

			//8.Footer
			html += footer;

			html = html.Replace("{ControlID}", this.UniqueID);
			html = html.Replace("{ControlClientID}", this.ClientID);

			html = html.Replace("{SystemFolder}", this.Settings.SystemFolder);

			//html = html.Replace("{ReportPath}", this.ReportPath);
			//html = html.Replace("{SessionID}", this.SessionID);
			string parameters = this.GetParameters();
			html = html.Replace("{Parameters}", parameters);

			return html;
		}

		/// <summary>
		/// Get report html content.
		/// It will format the html for cross browser support and set the stream root
		/// </summary>
		/// <returns></returns>
		private string GetReportHtml()
		{
			string content;
			content = this._content;

			content = Util.FormatHtml(content);

			//Set stream root url
			string parameters;
			string streamUrl;
			parameters = this.GetParameters();
			streamUrl =this.Settings.SystemFolder + "/ReportStream.aspx?" + parameters + "&rs:Format="+ this.Format + "&rs:StreamID=";
			content = content.Replace("{ReportStream.aspx}",streamUrl);

			return content;
		}



		/// <summary>
		/// Get the html of the control
		/// </summary>
		/// <remarks>
		/// Control layout:
		/// <code>
		///		<table>
		///			<tr><td>Toolbar</td></tr>
		///			<tr><td>Report Content via SOAP</td></tr>
		///			<tr><td>Toolbar</td></tr>
		///		</table>
		/// </code>
		/// 
		/// </remarks>
		/// <returns></returns>
		private string GetControlHtml()
		{
			string html;

			//1. header 
			html ="\n<!-- Report viewer -" + this.UniqueID + "-->";
			
			html +="\n<table cellpadding=\"0\" cellspacing=\"0\" width=\"100%\"";
			//customized css class for the outermost table	
			if (this.CssClass !="")
			{
				html +=(" class=\"" + this.CssClass + "\"");
			}
			html +=">";

			//2. Top Toolbar
			string toolbar;
			toolbar = this.GetToolbarHtml();

			html +="\n		<tr><td class=\"ReportViewer_ToolbarcCell\">\n" + toolbar.Replace("{ToolbarPosition}","Top") + "\n</td></tr>";
			
			//3. Content
			string report;
			report = this.GetReportHtml();

			html +="\n		<tr><td class=\"ReportViewer_ContentCell\">\n" + report + "\n</td></tr>";

			//4. bottom Toolbar
			html +="\n		<tr><td class=\"ReportViewer_ToolbarcCell\">\n" + toolbar.Replace("{ToolbarPosition}","Bottom") + "\n</td></tr>";

			//5. footer
			html +="\n</table>";
			html +="\n<!-- End of Report viewer -" + this.UniqueID + "-->";

			return html;
		}
		

	
      #endregion

		#region override methods


		/// <summary>
		/// Handle the postback event
		/// </summary>
		/// <remarks>
		/// implemented the method of IPostBackEventHandler, enables a server control to process an event raised when a form is posted to the server.  
		/// </remarks>
		/// <param name="eventArgument">A System.String that represents an optional event argument to be passed to the event handler.</param>
		public void RaisePostBackEvent(String eventArgument)
		{
			string[] arg= eventArgument.Split(new char[]{':'});
			
			if (arg[0]=="PageNum")
			{
				this.PageIndex = int.Parse(arg[1]);
				if (this.PageIndexChanged!=null)
				{
					this.PageIndexChanged(this,EventArgs.Empty);
				}
			}
		}

	 /// <summary>
      /// Render the report
      /// </summary>
      /// <param name="output"></param>
      protected override void Render(HtmlTextWriter output)
      {
		  // running in design mode
		  if (System.Web.HttpContext.Current == null)
		  {
			  return;
		  }

		  if (this.Visible)
		  {
				string html = this.GetControlHtml();
			    output.Write(html);
		  }
      }


		/// <summary>
		/// Get report content via SOAP
		/// </summary>
		/// <param name="e"></param>
		protected override void OnPreRender(EventArgs e)
		{
			base.OnPreRender (e);
			if (this.Visible)
			{
                // Get the Page Count via SOAP
				//if (this.PageCount==-1)
				{
					//string bodyContent = this.GetReportContent(true);

                }
				// Get the report rendering content via SOAP
				this._content = this.GetReportContent(false);

				

			}
		}

		/// <summary>
		/// Overrides the base CreateChildControls
		/// </summary>
		protected override void CreateChildControls() 
		{
			if (this.Visible)
			{
				//Call base class
				base.CreateChildControls();
			
				this.Page.GetPostBackEventReference(this);
				
				//Output the helper content, it contains style sheet file, and supported javascript functions
				string helperText;

				helperText = Util.GetResource("ReportViewerHelper.txt").Replace("Please select a export format!", ResourceManager.GetString("litSelectReportExportFormat"));

				helperText =  helperText.Replace("{SystemFolder}", this.Settings.SystemFolder);

				this.Page.RegisterClientScriptBlock("ReportViewerHelper", helperText);
			}

		}
	
		#endregion
   }
}


