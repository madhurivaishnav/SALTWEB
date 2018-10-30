using System;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.Win32;
using System.Security.Permissions;
using System.Configuration;
using System.IO;
using System.Windows.Forms;

namespace Bdw.Framework.Deployment.DatabaseConfiguration
{
	/// <summary>
	/// Summary description for ApplicationState.
	/// </summary>
	public abstract class ApplicationState
	{
		[STAThread]
		static void Main() 
		{
			ApplicationState.MigrationSettings =(MigrationSettings)ConfigurationSettings.GetConfig("MigrationSettings");

			if (ApplicationState.DatabaseName==null || ApplicationState.DatabaseName=="")
			{
				ApplicationState.DatabaseName = ConfigurationSettings.AppSettings["DefaultDatabase"];
			}
			ApplicationState.DboUserType = SqlUserType.IntegratedUser;
			ApplicationState.WebGrantPermission = true;

			if (ApplicationState.RptDatabaseName==null || ApplicationState.RptDatabaseName=="")
			{
				ApplicationState.RptDatabaseName = ConfigurationSettings.AppSettings["DefaultRptDatabase"];
			}
			
			ApplicationState.RptDboUserType = SqlUserType.IntegratedUser;
			ApplicationState.RptWebGrantPermission = true;

			System.Windows.Forms.Application.Run(FrmWelcome.Form);
//			System.Windows.Forms.Application.Run(FrmSelectRptDatabase.Form);			
//			System.Windows.Forms.Application.ExitThread();
		}
        /// <summary>
        /// SQL server and database
        /// </summary>
		public static  string ServerName, DatabaseName;

		/// <summary>
		/// Reporting SQL server and database
		/// </summary>
		public static  string RptServerName, RptDatabaseName;

        /// <summary>
        /// Installed version
        /// </summary>
		public static  string InstallVersion;

		/// <summary>
		/// Reporting SQL sever Installed version
		/// </summary>
		public static  string RptInstallVersion;

		/// <summary>
		/// dbo User
		/// </summary>
		public static  SqlUserType DboUserType;

		/// <summary>
		/// reporting server dbo User
		/// </summary>
		public static  SqlUserType RptDboUserType;

        /// <summary>
        /// dbo UserName and Password
        /// </summary>
		public static  string DboUsername,DboPassword;

		/// <summary>
		/// reporting dbo UserName and Password
		/// </summary>
		public static  string RptDboUsername,RptDboPassword;


		
		/// <summary>
		/// Web SQL User
		/// </summary>
		public static  SqlUserType WebUserType; 

		/// <summary>
		/// Reporting Web SQL User
		/// </summary>
		public static  SqlUserType RptWebUserType; 

		/// <summary>
		/// Web NT Username
		/// </summary>												
		public static  string WebNTUsername;

		/// <summary>
		/// Reporting Web NT Username
		/// </summary>												
		public static  string RptWebNTUsername;

        /// <summary>
        /// Web Username and Web Password and password
        /// </summary>
		public static  string WebUsername,WebPassword;

		/// <summary>
		/// Reporting Web Username and Web Password and password
		/// </summary>
		public static  string RptWebUsername,RptWebPassword;

        /// <summary>
        /// GrantPermission 
        /// </summary>
		public static  bool WebGrantPermission;

		/// <summary>
		/// GrantPermission for Reporting SQL Server
		/// </summary>
		public static  bool RptWebGrantPermission;
		
        /// <summary>
        /// Application Administrator
        /// </summary>
		public static  string AdminUsername="",AdminPassword="";

		/// <summary>
		/// Application Administrator for reporting
		/// </summary>
		public static  string RptAdminUsername="", RptAdminPassword="";

		/// <summary>
		/// Migration Settings
		/// </summary>
		public static  MigrationSettings MigrationSettings;


        public static string DBServerTZ = "";
		
		

	}
}
