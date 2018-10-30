using System;
using System.Collections;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Security;

using Bdw.Application.Salt.Data;


namespace Bdw.Application.Salt.Web.Utilities
{
	/// <summary>
	/// This class is used to retrieve the current user context such as user ID, user type, organization information
	///	Authentication data are set when the user first logins. They are stored in the authentication ticket
	/// </summary>
	internal abstract class UserContext
	{
		/// <summary>
		/// User ID: Stored in the authentication ticket
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static int UserID
		{
			get
			{
                try
                {
                    int uid = int.Parse(HttpContext.Current.User.Identity.Name);
                    return uid;
                }
                catch
                {
                    throw new ApplicationException("Error converting UserID to integer, userID=" + HttpContext.Current.User.Identity.Name);
                }
			}
		}


		/// <summary>
		/// User Authentication Data
		/// </summary>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public static UserData UserData
		{
			get
			{
				if (HttpContext.Current.Items["__UserData"]==null)
				{
					throw new  SecurityException("No user context");
				}
				else
				{
					return (UserData)HttpContext.Current.Items["__UserData"];
				}
			}
			set
			{
				HttpContext.Current.Items["__UserData"] = value;
			}
		}
	}

	/// <summary>
	/// This class is used to store user authentication data.
	/// </summary>
	/// <remarks>
	/// Assumptions: None
	/// Notes: 
	/// Author: Jack Liu, 26/02/2004
	/// Changes:
	/// </remarks>
	internal class UserData
	{
		private UserType m_enmUserType;
		private int m_intOrgID;
		private string m_strOrgLogo;
		private bool m_blnAdvancedReporting;

		/// <summary>
		/// User Type:	SaltAdmin = 1,	OrgAdmin = 2,	UnitAdmin = 3,	User = 4
		/// Stored in the authentication ticket
		/// </summary>
		public  UserType UserType
		{
			get
			{
				return this.m_enmUserType;
			}
		}

		/// <summary>
		/// Organisation ID: Stored in the authentication ticket
		/// Current user belongs to
		/// </summary>
		public  int OrgID
		{
			get
			{
				return this.m_intOrgID;
			}
		}

		/// <summary>
		/// Organisation Logo: Stored in the authentication ticket
		/// </summary>
		public string OrgLogo
		{
			get
			{
				return this.m_strOrgLogo;
			}
		}

		/// <summary>
		///AdvancedReporting
		/// </summary>
		public bool AdvancedReporting
		{
			get
			{
				return this.m_blnAdvancedReporting;
			}
		}

		

		public UserData(UserType userType,int OrgID, string orgLogo, bool advancedReporting)
		{
			this.m_enmUserType = userType;
			this.m_intOrgID  = OrgID;
			this.m_strOrgLogo = orgLogo;
			this.m_blnAdvancedReporting = advancedReporting;
		}


		/// <summary>
		/// Constructor. Create object from UserData that is saved in the authentication ticket.
		/// The UserData is | seperated string. 
		/// The data format is UserType|OrganisationID|OrgLogo. For Example: SaltAdmin|123|Bdw.gif|true
		/// </summary>
		/// <param name="userData"></param>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public UserData(string userData)
		{
            try
            {
                string[] a_strUserData = userData.Split('|');
                this.m_enmUserType = UserType.User;
                try
                {
                    this.m_enmUserType = (UserType)Enum.Parse(typeof(UserType), a_strUserData[0]);
                }
                catch
                {
                }
                this.m_intOrgID = 0;
                try
                {
                    this.m_intOrgID = int.Parse(a_strUserData[1]);
                }
                catch
                {
                }
                this.m_strOrgLogo = "";
                try
                {
                    this.m_strOrgLogo = a_strUserData[2];
                }
                catch
                {
                }
                this.m_blnAdvancedReporting = false;
                try
                {
                    this.m_blnAdvancedReporting = bool.Parse(a_strUserData[3]);
                }
                catch
                {
                }
            }
            catch
            {
                throw new ApplicationException("Bad data in Cookie? userData ="+userData);
            }

			
		}
		/// <summary>
		/// Convert object to | seperated string. 
		/// The data format is UserType|OrganisationID|OrgLogo.For Example: SaltAdmin|123|Bdw.gif
		/// </summary>
		/// <returns></returns>
		/// <remarks>
		/// Assumptions: None
		/// Notes: 
		/// Author: Jack Liu, 26/02/2004
		/// Changes:
		/// </remarks>
		public override string ToString()
		{
			return 	this.m_enmUserType.ToString() + "|" + this.m_intOrgID.ToString() + "|" + this.m_strOrgLogo + "|"+this.m_blnAdvancedReporting.ToString();
		}
	}

}
