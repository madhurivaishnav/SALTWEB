using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Configuration;
using System.IO;

using Bdw.Application.Salt.Data;
using Bdw.Application.Salt.Utilities;
using Bdw.Application.Salt.Web.Utilities;
using Bdw.Application.Salt.BusinessServices;


namespace Bdw.Application.Salt.Web.Utilities
{
	/// <summary>
	/// Application level Settings.
	/// All these settings are stored in the database and retrieved when the application starts(Application_Start event in  Global.asax)
	/// </summary>
	public abstract class  ApplicationSettings
	{
		/// <summary>
		/// The page size for pagination
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static int PageSize
		{
			get
			{
                if (ApplicationSettings.GetSetting("PageSize") != null) { return int.Parse(ApplicationSettings.GetSetting("PageSize")); }
                else return 8;
			}
		}

		/// <summary>
		/// The Path of InfoPath Rendering System
		/// The value is: "/General/InfoPath/";
		/// </summary>
        public static string InfoPathSystemPath
        {
            get
            {
                return "/General/InfoPath/";
            }
        }


        /// <summary>
        /// The Path of InfoPath Rendering System
        /// The value is: "/General/Scorm/";
        /// </summary>
        public static string ScormSystemPath
        {
            get
            {
                return "/General/Scorm/";
            }
        }
        /// <summary>
        ///Gets the Name of the application
        /// </summary>
        /// <remarks>
        /// Assumptions: Name is set in config file at instalation
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,16/02/04
        /// Changes:
        /// </remarks>
         public static string AppName
		{
			get
			{
					return ApplicationSettings.GetSetting("AppName");
			}
		}

        /// <summary>
        /// Gets the name of the casscading Style Sheet for the application
        /// if the value does not exist the application uses the Application name
        /// if the name of the css does not end with .css then then it is appended.
        /// </summary>
        /// <remarks>
        /// Assumptions: StyleSheet is set in config file at or after instalation
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,17/05/04
        /// Changes:
        /// </remarks>
         public static string StyleSheet
		{
			get
			{
                string strReturnValue = "";
                try
                {
                    strReturnValue = ApplicationSettings.GetSetting("StyleSheet");
                    if (strReturnValue == null) { strReturnValue = ""; }

                    if(strReturnValue.Length == 0)
                    {
                        strReturnValue = ApplicationSettings.AppName;
                        if (strReturnValue == null) { strReturnValue = ""; }
                    }
                }
                catch
                {
                     strReturnValue = ApplicationSettings.AppName;
                     if (strReturnValue ==null) { strReturnValue = ""; }
                }
                // append '.css' if requied
                if( !strReturnValue.ToLower().EndsWith(".css") )
                {
                    strReturnValue += ".css";
                }
                return strReturnValue;
			}
		}


        /// <summary>
        ///Gets the External Link Disclaimer
        /// </summary>
        /// <remarks>
        /// Assumptions: ExternalLinkDisclaimer is set in config file at instalation
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,13/05/04
        /// Changes:
        /// </remarks>
         public static string ExternalLinkDisclaimer
		{
			get
			{
					return ApplicationSettings.GetSetting("ExternalLinkDisclaimer").ToString();
			}
		}

        /// <summary>
        ///Gets the About page Warning Text 
        /// </summary>
        /// <remarks>
        /// Assumptions: AboutWarningText is set in config file at instalation
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,26/05/04
        /// Changes:
        /// </remarks>
        public static string AboutWarningText 
        {
            get
            {
                return ApplicationSettings.GetSetting("AboutWarningText").ToString();
            }
        }

        /// <summary>
        /// Gets the Privacy Policy URL  
        /// </summary>
        /// <remarks>
        /// Assumptions: PrivacyPolicyURL is set in config file at instalation
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,26/05/04
        /// Changes:
        /// </remarks>
        public static string PrivacyPolicyURL 
        {
            get

            {
                if (ApplicationSettings.GetSetting("PrivacyPolicyURL") != null)
                {
                    return ApplicationSettings.GetSetting("PrivacyPolicyURL").ToString();
                }
                else return "";
            }
        }


        /// <summary>
        /// Gets the Home Page Footer  
        /// </summary>
        /// <remarks>
        /// Assumptions: HomePageFooter is set in config file at instalation
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,26/05/04
        /// Changes:
        /// </remarks>
        public static string HomePageFooter 
        {
            get
            {
                return ApplicationSettings.GetSetting("HomePageFooter").ToString();
            }
        }
        /// <summary>
        ///Gets the (Full) Company Name for branding as it will appear on the login page, footer and about page
        /// </summary>
        /// <remarks>
        /// Assumptions: BrandingCompanyName  is set in config file at instalation
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,26/05/04
        /// Changes:
        /// </remarks>
        public static string BrandingCompanyName 
        {
            get
            {
                String result = "";
                try
                {
                    result = ApplicationSettings.GetSetting("BrandingCompanyName").ToString();
                }
                catch
                {
                }
                if (result == null) result = "";
                return result;
            }
        }

        /// <summary>
        ///Gets the url for the Company the application is branded for. It will appear on the login page, footer and about page
        /// </summary>
        /// <remarks>
        /// Assumptions: BrandingCompanyURL is set in config file at instalation
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,26/05/04
        /// Changes:
        /// </remarks>
        public static string BrandingCompanyURL
        {
            get
            {
                String BCURL = "";
                try
                {
                    BCURL = ApplicationSettings.GetSetting("BrandingCompanyURL").ToString();
                }
                catch
                {
                    BCURL = "";
                }
                return BCURL;
            }
        }

        /// <summary>
        ///Gets the TearmsOfUseURL for the Company the application is branded for. It will appear on the login page
        /// </summary>
        /// <remarks>
        /// Assumptions: BrandingCompanyURL is set in config file at instalation
        /// Notes: 
        /// Author: Stephen Kennedy-Clark,26/05/04
        /// Changes:
        /// </remarks>
        public static string TermsOfUseURL 
        {
            get
            {
                try
                {
                    if (ApplicationSettings.GetSetting("TermsOfUseURL").ToString() == null) return "";
                    else return ApplicationSettings.GetSetting("TermsOfUseURL").ToString();
                }
                catch
                {
                    return "";
                }
            }
        }


		/// <summary>
		/// Smtp Mail server
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static string MailServer
		{
			get
			{
				return ApplicationSettings.GetSetting("MailServer");
			}
		}
		/// <summary>
		/// Support email address
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static string SupportEmail
		{
			get
			{
				return ApplicationSettings.GetSetting("SupportEmail");
			}
		}

        /// <summary>
        /// Gets the year that the copyright for this application is set
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark 10/3/2004
        /// Changes:
        /// </remarks>
        public static string CopyrightYear
        {
            get
            {
                return ApplicationSettings.GetSetting("CopyrightYear");
            }
        }//GetCopyrightYear

        /// <summary>
        /// Gets the trademark symbol, if there is one for this application
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark 16/3/2004
        /// Changes:
        /// </remarks>
        public static string TradeMark
        {
            get
            {
                string strReturnString = ""; // holding string
                strReturnString = ApplicationSettings.GetSetting("TradeMark");
                if (strReturnString == null) { strReturnString = ""; }
                if( (strReturnString.ToLower().Trim() == "none") || (strReturnString.ToLower().Trim() == "nothing") )
                {
                    strReturnString = "";
                }
                return strReturnString;
            }
        }//TradeMark

        /// <summary>
        /// Gets the version of the application
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark 10/3/2004
        /// Changes:
        /// </remarks>
        public static string Version
        {
            get
            {
               return ApplicationSettings.GetSetting("Version");
            }
        }

        /// <summary>
        /// Gets the show detaild help bool
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark 13/5/2004
        /// Changes:
        /// </remarks>
        public static bool ShowDetailedHelp
        {
            get
            {
                bool bolRetVal = false;
                try
                {
                    OrganisationConfig objOrgConfig = new OrganisationConfig();
                    string strShow = objOrgConfig.GetOne(Utilities.UserContext.UserData.OrgID,"ShowDetailedHelp");
                    return strShow[0].ToString().ToLower()=="y";
                }
                catch
                {
                    bolRetVal = false;
                }
                return bolRetVal;
            }
        }

        /// <summary>
        /// Change the inages button set for button and icon images on the home page
        /// This is equired because some images cant be changed in the CSS
        /// If this value is non null or not a space the home pages images will 
        /// all beed to be appended with this value
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark 24/5/2004
        /// Changes:
        /// </remarks>
        public static string ButtonSet
        {
            get
            {
                string strRetVal = "";
                try
                {
                    strRetVal = ApplicationSettings.GetSetting("ButtonSet").Trim() ;
                }
                catch
                {
                    strRetVal = "";
                }
                // use a regexp to ensure string is alphanumeric
                System.Text.RegularExpressions.Regex objAlphaNumericPattern=new System.Text.RegularExpressions.Regex("[^a-zA-Z0-9]");
                if(objAlphaNumericPattern.IsMatch(strRetVal))
                {
                    // String contains at least one non alphanumeric character therfore not valid for our purposes
                    // - this is because you may have to enter "&nbsp;" to use the default button set
                    strRetVal = "";
                }
                return strRetVal;
            }
        }

        /// <summary>
        /// Gets the name of the company that the product is lisenced to
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Stephen Kennedy-Clark 10/3/2004
        /// Changes:
        /// </remarks>
        public static string LisencedTo
        {
            get
            {
               return ApplicationSettings.GetSetting("LisencedTo");
            }
        }

        /// <summary>
        /// Gets the time delay factor to use for toolbooks
        /// </summary>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Kneale    7/7/2004
        /// Changes:
        /// </remarks>
        public static int ToolbookDelay
        {
            get
            {
                return int.Parse(ApplicationSettings.GetSetting("ToolbookDelay"));
            }
        }

		/// <summary>
		/// Get Application level Settings from database and store in the Application state.
		/// This is only called by Global.asax
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static void  InitializeSettings()
		{
			DataTable dtb;
			string strName, strValue;
			
			AppConfig objAppConfig = new AppConfig();
            try
            {
                dtb = objAppConfig.GetList();
            }
            catch
            {
                throw new Exception("Unable to retrieve application settings");
            }

			foreach(DataRow drwConfig in dtb.Rows)
			{
				strName = (string)drwConfig["Name"];
				strValue = (string)drwConfig["Value"];
				HttpContext.Current.Application[strName]= strValue;
			}

            HttpContext.Current.Application["Version"]= objAppConfig.GetVersion();
        }//InitializeSettings

		/// <summary>
		/// Change the application setting, This is only called by the Application Configuration details page
		/// </summary>
		/// <param name="name">Name of the setting</param>
		/// <param name="value">Value of the setting</param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static void  SetSetting(string name, string value)
		{
			HttpContext.Current.Application[name]= value;
		}

		/// <summary>
		/// Get the application setting, this is only called by this class
		/// </summary>
		/// <param name="name">Name of the setting</param>
		/// <returns>Value of the setting</returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		private static string GetSetting(string name)
		{
			return (string)HttpContext.Current.Application[name];
		}
    }
}