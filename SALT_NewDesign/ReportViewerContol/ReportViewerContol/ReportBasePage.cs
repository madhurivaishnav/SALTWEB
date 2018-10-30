using System;
using Bdw.SqlServer.Reporting.ReportService20051;
using Bdw.SqlServer.Reporting.ReportExecution20051;

namespace Bdw.SqlServer.Reporting
{
	/// <summary>
	/// Summary description for ReportBasePage.
	/// </summary>
	public class ReportBasePage: System.Web.UI.Page
	{
		
		#region report service arguments

		protected string ReportPath
		{
			get
			{
				return Request.QueryString["rs:ReportPath"];
			}
		}

		protected string Format
		{
			get
			{
				return Request.QueryString["rs:Format"];
			}
		}

		protected string SessionID
		{
			get
			{
				return Request.QueryString["rs:SessionID"];
			}
		}

		protected string StreamID
		{
			get
			{
				return Request.QueryString["rs:StreamID"];
			}
		}

        protected ReportExecution20051.ParameterValue[] ReportParameters
		{
			get
			{
				return Util.GetReportParameters(this.SessionID);
			}
		}

//		protected string ParasHash
//		{
//			get
//			{
//				return Request.QueryString["rs:ParasHash"];
//			}
//		}

		/// <summary>
		///  Gets report settings from application configuration file
		/// </summary>
		protected ReportSettings Settings
		{
			get
			{
				return Util.GetSettings();
			}
		}

		#endregion
	}
}
